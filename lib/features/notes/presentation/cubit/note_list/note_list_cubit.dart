import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note_list_filter.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/watch_filtered_notes_uc.dart';
import 'package:knowledge_hub/features/notes/presentation/cubit/note_list/note_list_state.dart';
import 'package:knowledge_hub/features/notes/presentation/map_failure_to_message.dart';
import 'package:knowledge_hub/features/notes/presentation/view_models/note_list_item_view_model.dart';

/// Thin Cubit exposing simple methods (`selectFolder`, `toggleTag`,
/// `setTagFilterMode`) that mutate the active filter and re-subscribe to
/// `WatchFilteredNotesUc` (design.md §"NoteListCubit / FolderCubit /
/// TagCubit / TrashCubit").
///
/// `NotesRepositoryImpl.watchNotes` already applies the default
/// most-recently-modified-first sort unconditionally (`notes.sort((a, b) =>
/// b.updatedAt.compareTo(a.updatedAt))`, satisfying Requirement 10.1) — this
/// Cubit deliberately does not re-sort the emitted list a second time, to
/// avoid duplicating business logic that's already correctly placed at the
/// repository layer.
class NoteListCubit extends Cubit<NoteListState> {
  NoteListCubit({required WatchFilteredNotesUc watchFilteredNotesUc})
    : _watchFilteredNotesUc = watchFilteredNotesUc,
      super(const NoteListState.loading()) {
    _resubscribe();
  }

  final WatchFilteredNotesUc _watchFilteredNotesUc;

  NoteListFilterParams _activeFilter = const NoteListFilterParams();
  StreamSubscription<Result<Failure, List<Note>>>? _filteredNotesSubscription;

  void selectFolder(String? folderId) {
    _activeFilter = _activeFilter.copyWith(folderId: folderId);
    _resubscribe();
  }

  void toggleTag(String tagId) {
    final List<String> currentTagIds = _activeFilter.tagIds;
    final List<String> updatedTagIds = currentTagIds.contains(tagId)
        ? currentTagIds.where((String id) => id != tagId).toList()
        : <String>[...currentTagIds, tagId];
    _activeFilter = _activeFilter.copyWith(tagIds: updatedTagIds);
    _resubscribe();
  }

  void setTagFilterMode(TagFilterMode mode) {
    _activeFilter = _activeFilter.copyWith(tagFilterMode: mode);
    _resubscribe();
  }

  void _resubscribe() {
    unawaited(_filteredNotesSubscription?.cancel());
    final NoteListFilterParams filterAtSubscriptionTime = _activeFilter;
    _filteredNotesSubscription = _watchFilteredNotesUc(filterAtSubscriptionTime).listen(
      (Result<Failure, List<Note>> result) => _emitForResult(result, filterAtSubscriptionTime),
    );
  }

  void _emitForResult(Result<Failure, List<Note>> result, NoteListFilterParams filter) {
    if (isClosed) {
      return;
    }
    result.when(
      failure: (Failure failure) => emit(NoteListState.loadFailed(mapFailureToMessage(failure))),
      success: (List<Note> notes) => emit(
        NoteListState.loaded(notes.map(NoteListItemViewModel.fromNote).toList(), filter),
      ),
    );
  }

  @override
  Future<void> close() {
    unawaited(_filteredNotesSubscription?.cancel());
    return super.close();
  }
}
