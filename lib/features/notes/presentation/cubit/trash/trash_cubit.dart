import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note_list_filter.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/permanently_delete_note_uc.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/restore_note_from_trash_uc.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/watch_filtered_notes_uc.dart';
import 'package:knowledge_hub/features/notes/presentation/cubit/trash/trash_state.dart';
import 'package:knowledge_hub/features/notes/presentation/map_failure_to_message.dart';
import 'package:knowledge_hub/features/notes/presentation/view_models/trashed_note_view_model.dart';

/// Thin Cubit exposing simple methods (`restore(noteId)`,
/// `permanentlyDelete(noteId)`) that re-invoke the relevant use case and
/// reuse the live `WatchFilteredNotesUc` subscription scoped to
/// `NoteLifecycleScope.trash`, rather than a separate trash-specific watch
/// mechanism (design.md §"NoteListCubit / FolderCubit / TagCubit /
/// TrashCubit"; per that section, `TrashCubit`'s dependency graph has
/// exactly 3 edges: `WatchFilteredNotesUc`, `RestoreNoteFromTrashUc`,
/// `PermanentlyDeleteNoteUc` -- moving a note _to_ trash and auto-purging
/// expired trash both live outside this Cubit's boundary).
///
/// `restore`/`permanentlyDelete` do not eagerly emit a "success" state on
/// `Ok` -- the live `WatchFilteredNotesUc` subscription started in the
/// constructor naturally emits the updated list once the restore/delete
/// lands (the note leaving the trash-scoped result set), avoiding a
/// duplicate/racing source of truth for what the trash list currently is.
class TrashCubit extends Cubit<TrashState> {
  TrashCubit({
    required WatchFilteredNotesUc watchFilteredNotesUc,
    required RestoreNoteFromTrashUc restoreNoteFromTrashUc,
    required PermanentlyDeleteNoteUc permanentlyDeleteNoteUc,
  }) : _watchFilteredNotesUc = watchFilteredNotesUc,
       _restoreNoteFromTrashUc = restoreNoteFromTrashUc,
       _permanentlyDeleteNoteUc = permanentlyDeleteNoteUc,
       super(const TrashState.loading()) {
    _trashedNotesSubscription = _watchFilteredNotesUc(
      const NoteListFilterParams(lifecycleScope: NoteLifecycleScope.trash),
    ).listen(_emitForWatchResult);
  }

  final WatchFilteredNotesUc _watchFilteredNotesUc;
  final RestoreNoteFromTrashUc _restoreNoteFromTrashUc;
  final PermanentlyDeleteNoteUc _permanentlyDeleteNoteUc;

  StreamSubscription<Result<Failure, List<Note>>>? _trashedNotesSubscription;

  Future<void> restore(String noteId) async {
    final Result<Failure, void> result = await _restoreNoteFromTrashUc(noteId);
    if (isClosed) {
      return;
    }
    // Every `Err` from `restore` routes through `TrashActionFailed`,
    // carrying the current trashed-item list forward -- an `Ok` result
    // needs no extra emit here, since the live `WatchFilteredNotesUc`
    // subscription naturally reflects the restored note leaving the
    // trash-scoped list on its own.
    result.when(
      failure: (Failure failure) =>
          emit(TrashState.actionFailed(state.currentItems, mapFailureToMessage(failure))),
      success: (void _) {},
    );
  }

  Future<void> permanentlyDelete(String noteId) async {
    final Result<Failure, void> result = await _permanentlyDeleteNoteUc(noteId);
    if (isClosed) {
      return;
    }
    result.when(
      failure: (Failure failure) =>
          emit(TrashState.actionFailed(state.currentItems, mapFailureToMessage(failure))),
      success: (void _) {},
    );
  }

  void _emitForWatchResult(Result<Failure, List<Note>> result) {
    if (isClosed) {
      return;
    }
    result.when(
      // A live-subscription failure, not a restore/permanentlyDelete action
      // failure -- TrashListLoadFailed, not TrashActionFailed (see
      // trash_state.dart's 2026-09-20 amendment for why conflating the two
      // is wrong).
      failure: (Failure failure) => emit(TrashState.loadFailed(mapFailureToMessage(failure))),
      success: (List<Note> notes) =>
          emit(TrashState.loaded(notes.map(TrashedNoteViewModel.fromNote).toList())),
    );
  }

  @override
  Future<void> close() {
    unawaited(_trashedNotesSubscription?.cancel());
    return super.close();
  }
}
