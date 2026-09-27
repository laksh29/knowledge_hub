import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/domain/entities/folder.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/create_folder_uc.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/delete_folder_uc.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/watch_folders_uc.dart';
import 'package:knowledge_hub/features/notes/presentation/cubit/folder/folder_state.dart';
import 'package:knowledge_hub/features/notes/presentation/map_failure_to_message.dart';
import 'package:knowledge_hub/features/notes/presentation/view_models/folder_view_model.dart';

/// Thin Cubit exposing simple methods (`createFolder(name)`,
/// `deleteFolder(id)`) that re-invoke the relevant use case and
/// re-subscribe to `WatchFoldersUc` (design.md §"NoteListCubit /
/// FolderCubit / TagCubit / TrashCubit").
///
/// `createFolder`/`deleteFolder` do not eagerly emit a "success" state on
/// `Ok` — the live `WatchFoldersUc` subscription started in the constructor
/// naturally emits the updated list once the write lands, avoiding a
/// duplicate/racing source of truth for what the folder list currently is.
class FolderCubit extends Cubit<FolderState> {
  FolderCubit({
    required CreateFolderUc createFolderUc,
    required WatchFoldersUc watchFoldersUc,
    required DeleteFolderUc deleteFolderUc,
  }) : _createFolderUc = createFolderUc,
       _watchFoldersUc = watchFoldersUc,
       _deleteFolderUc = deleteFolderUc,
       super(const FolderState.loading()) {
    _foldersSubscription = _watchFoldersUc().listen(_emitForWatchResult);
  }

  final CreateFolderUc _createFolderUc;
  final WatchFoldersUc _watchFoldersUc;
  final DeleteFolderUc _deleteFolderUc;

  StreamSubscription<Result<Failure, List<Folder>>>? _foldersSubscription;

  Future<void> createFolder(String name) async {
    final Result<Failure, Folder> result = await _createFolderUc(name);
    if (isClosed) {
      return;
    }
    // Every `Err` from `createFolder` -- not only `DuplicateNameFailure` --
    // routes through `FolderCreationFailed`. design.md's Validation note
    // calls out the duplicate-name case specifically because it's the
    // failure a user can self-correct (rename and retry), but the state
    // shape itself carries a plain `String errorMessage` with no
    // failure-type discriminant, and `mapFailureToMessage` already produces
    // a specific, correct message for every `Failure` subtype (including a
    // genuine `CacheFailure` storage problem). Silently swallowing a
    // non-duplicate failure (e.g. leaving the user's `createFolder` call
    // with no feedback at all) would be worse than surfacing it through the
    // one failure state this Cubit has.
    result.when(
      failure: (Failure failure) =>
          emit(FolderState.creationFailed(state.currentFolders, mapFailureToMessage(failure))),
      success: (Folder _) {},
    );
  }

  Future<void> deleteFolder(String folderId) async {
    // No dedicated delete-failure state exists for `FolderCubit` in
    // design.md (unlike `TrashCubit.TrashActionFailed`, which explicitly
    // covers restore/permanent-delete failures) -- the live
    // `WatchFoldersUc` subscription is the sole source of truth for what
    // the list looks like after this call, whether it succeeds or fails.
    // Awaiting the result (rather than firing-and-forgetting) still lets
    // the `isClosed` guard prevent a post-close emit if a failure path is
    // added here later.
    await _deleteFolderUc(folderId);
  }

  void _emitForWatchResult(Result<Failure, List<Folder>> result) {
    if (isClosed) {
      return;
    }
    result.when(
      // A live-subscription failure, not a createFolder action failure --
      // FolderListLoadFailed, not FolderCreationFailed (see folder_state.dart's
      // 2026-09-20 amendment for why conflating the two is wrong).
      failure: (Failure failure) => emit(FolderState.loadFailed(mapFailureToMessage(failure))),
      success: (List<Folder> folders) =>
          emit(FolderState.loaded(folders.map(FolderViewModel.fromFolder).toList())),
    );
  }

  @override
  Future<void> close() {
    unawaited(_foldersSubscription?.cancel());
    return super.close();
  }
}
