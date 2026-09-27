import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:knowledge_hub/features/notes/presentation/view_models/folder_view_model.dart';

part 'folder_state.freezed.dart';

/// One distinct subclass per folder-list-status scenario — **not** a single
/// "ready" state carrying a status flag/enum, per this project's steering
/// rule against mono-state (same rule `NoteListState`/`NoteEditorState`
/// follow).
///
/// design.md's §"NoteListCubit / FolderCubit / TagCubit / TrashCubit" State
/// Management note specifies `FolderListLoading`, `FolderListLoaded`, and
/// `FolderCreationFailed` (which carries the last-known folder list forward
/// so a duplicate-name error doesn't blank the list).
///
/// **Amendment (2026-09-20, task 4.5 review remediation)**: a 4th subclass,
/// `FolderListLoadFailed(String errorMessage)`, was added — design.md was
/// silent on `Err(failure)` from the live `WatchFoldersUc` subscription
/// (distinct from a `createFolder` action failure). An earlier revision
/// reused `FolderCreationFailed` for this case, which review correctly
/// rejected: it mislabels a stream failure as a creation failure, and for a
/// "not found"-worded `CacheFailure` (whose message `mapFailureToMessage`
/// intentionally maps to `''`, a silent no-op signal for action-failure
/// callers) it would have produced a `FolderCreationFailed` with a blank
/// error message — indistinguishable from an unfinished bug. This mirrors
/// `NoteListState.loadFailed`/`NoteListLoadFailed` (task 4.4), which added
/// the exact same distinction for the same reason.
@freezed
sealed class FolderState with _$FolderState {
  /// The folder-watch stream has not yet emitted.
  const factory FolderState.loading() = FolderListLoading;

  /// `WatchFoldersUc` emitted `Ok(folders)`.
  const factory FolderState.loaded(List<FolderViewModel> folders) = FolderListLoaded;

  /// `CreateFolderUc` emitted `Err(failure)`. [currentFolders] carries
  /// forward whatever folder list was last known, so the failure does not
  /// blank an already-populated list.
  const factory FolderState.creationFailed(
    List<FolderViewModel> currentFolders,
    String errorMessage,
  ) = FolderCreationFailed;

  /// The live `WatchFoldersUc` subscription itself emitted `Err(failure)` --
  /// not a `createFolder` action failure. No folder list is carried forward,
  /// since a broken watch query means the prior list no longer corresponds
  /// to anything trustworthy (same reasoning as `NoteListLoadFailed`).
  const factory FolderState.loadFailed(String errorMessage) = FolderListLoadFailed;
}

/// Derived accessor for "the folder list regardless of which state" —
/// implemented as an `extension`, **not** a getter inside the `@freezed
/// sealed class` declaration above. Freezed's sealed-union codegen
/// generates each variant via `implements`, which does not inherit
/// concrete member bodies declared directly inside the sealed class; a
/// getter placed there causes a "missing implementation" compile error for
/// every variant (confirmed independently during task 4.2, this task's
/// sibling).
extension FolderStateCurrentFoldersX on FolderState {
  List<FolderViewModel> get currentFolders => switch (this) {
    FolderListLoading() => const <FolderViewModel>[],
    FolderListLoaded(:final folders) => folders,
    FolderCreationFailed(:final currentFolders) => currentFolders,
    FolderListLoadFailed() => const <FolderViewModel>[],
  };
}
