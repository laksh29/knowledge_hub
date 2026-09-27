import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:knowledge_hub/features/notes/presentation/view_models/trashed_note_view_model.dart';

part 'trash_state.freezed.dart';

/// One distinct subclass per trash-list-status scenario — **not** a single
/// "ready" state carrying a status flag/enum, per this project's steering
/// rule against mono-state (same rule `NoteListState`/`FolderState`/
/// `TagState` follow).
///
/// design.md's §"NoteListCubit / FolderCubit / TagCubit / TrashCubit" State
/// Management note specifies `TrashLoading`, `TrashLoaded`, and
/// `TrashActionFailed` (which carries the last-known trashed-item list
/// forward so a restore/permanent-delete error doesn't blank the list).
///
/// **Amendment (2026-09-20, task 4.7)**: a 4th subclass,
/// `TrashListLoadFailed(String errorMessage)`, was added — mirroring
/// `FolderState`'s (task 4.5) and `TagState`'s (task 4.6) own 2026-09-20
/// amendments. design.md's `TrashState` bullet was silent on `Err(failure)`
/// from the live `WatchFilteredNotesUc(lifecycleScope: trash)` subscription
/// (distinct from a `restore`/`permanentlyDelete` action failure). Reusing
/// `TrashActionFailed` for this case would mislabel a stream failure as an
/// action failure, and for a "not found"-worded `CacheFailure` (whose
/// message `mapFailureToMessage` intentionally maps to `''`) it would have
/// produced a `TrashActionFailed` with a blank error message —
/// indistinguishable from an unfinished bug.
///
/// Uses a private constructor (`TrashState._()`) rather than an `extension`
/// for the derived [currentItems] accessor below, matching the
/// `TagState`/`Note` entity pattern in this codebase — a getter placed
/// directly inside a `@freezed sealed class` without this private
/// constructor fails to compile (freezed's own "Getters require a
/// MyClass._() constructor" error).
@freezed
sealed class TrashState with _$TrashState {
  const TrashState._();

  /// The trash-watch stream has not yet emitted.
  const factory TrashState.loading() = TrashLoading;

  /// `WatchFilteredNotesUc(lifecycleScope: trash)` emitted `Ok(notes)`.
  const factory TrashState.loaded(List<TrashedNoteViewModel> items) = TrashLoaded;

  /// `RestoreNoteFromTrashUc`/`PermanentlyDeleteNoteUc` emitted `Err(failure)`.
  /// [currentItems] carries forward whatever trashed-item list was last
  /// known, so the failure does not blank an already-populated list.
  const factory TrashState.actionFailed(
    List<TrashedNoteViewModel> currentItems,
    String errorMessage,
  ) = TrashActionFailed;

  /// The live `WatchFilteredNotesUc(lifecycleScope: trash)` subscription
  /// itself emitted `Err(failure)` -- not a restore/permanent-delete action
  /// failure. No trashed-item list is carried forward, since a broken watch
  /// query means the prior list no longer corresponds to anything
  /// trustworthy (same reasoning as `FolderListLoadFailed`/`TagListLoadFailed`).
  const factory TrashState.loadFailed(String errorMessage) = TrashListLoadFailed;

  List<TrashedNoteViewModel> get currentItems => switch (this) {
    TrashLoading() => const <TrashedNoteViewModel>[],
    TrashLoaded(:final items) => items,
    TrashActionFailed(:final currentItems) => currentItems,
    TrashListLoadFailed() => const <TrashedNoteViewModel>[],
  };
}
