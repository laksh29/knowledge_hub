import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:knowledge_hub/features/notes/presentation/view_models/tag_view_model.dart';

part 'tag_state.freezed.dart';

/// One distinct subclass per tag-list-status scenario — **not** a single
/// "ready" state carrying a status flag/enum, per this project's steering
/// rule against mono-state (same rule `NoteListState`/`FolderState` follow).
///
/// design.md's §"NoteListCubit / FolderCubit / TagCubit / TrashCubit" State
/// Management note specifies `TagListLoading`, `TagListLoaded`, and
/// `TagCreationFailed` (which carries the last-known tag list forward so a
/// duplicate-name error doesn't blank the list) as "mirrors `FolderState`".
///
/// **Amendment (2026-09-20, task 4.6)**: a 4th subclass,
/// `TagListLoadFailed(String errorMessage)`, was added — mirroring
/// `FolderState`'s own 2026-09-20 (task 4.5) amendment. design.md's
/// `TagState` bullet was silent on `Err(failure)` from the live
/// `WatchTagsUc` subscription (distinct from a `createTag` action failure).
/// Reusing `TagCreationFailed` for this case would mislabel a stream
/// failure as a creation failure, and for a "not found"-worded
/// `CacheFailure` (whose message `mapFailureToMessage` intentionally maps
/// to `''`) it would have produced a `TagCreationFailed` with a blank error
/// message — indistinguishable from an unfinished bug.
///
/// Uses a private constructor (`TagState._()`) rather than an `extension`
/// for the derived [currentTags] accessor below, matching the
/// `Note`/`NoteEditorState` entity pattern in this codebase — a getter
/// placed directly inside a `@freezed sealed class` without this private
/// constructor fails to compile (freezed's own "Getters require a
/// MyClass._() constructor" error).
@freezed
sealed class TagState with _$TagState {
  const TagState._();

  /// The tag-watch stream has not yet emitted.
  const factory TagState.loading() = TagListLoading;

  /// `WatchTagsUc` emitted `Ok(tags)`.
  const factory TagState.loaded(List<TagViewModel> tags) = TagListLoaded;

  /// `CreateTagUc` emitted `Err(failure)`. [currentTags] carries forward
  /// whatever tag list was last known, so the failure does not blank an
  /// already-populated list.
  const factory TagState.creationFailed(List<TagViewModel> currentTags, String errorMessage) =
      TagCreationFailed;

  /// The live `WatchTagsUc` subscription itself emitted `Err(failure)` --
  /// not a `createTag` action failure. No tag list is carried forward,
  /// since a broken watch query means the prior list no longer corresponds
  /// to anything trustworthy (same reasoning as `FolderListLoadFailed`).
  const factory TagState.loadFailed(String errorMessage) = TagListLoadFailed;

  List<TagViewModel> get currentTags => switch (this) {
    TagListLoading() => const <TagViewModel>[],
    TagListLoaded(:final tags) => tags,
    TagCreationFailed(:final currentTags) => currentTags,
    TagListLoadFailed() => const <TagViewModel>[],
  };
}
