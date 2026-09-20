import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note_list_filter.dart';
import 'package:knowledge_hub/features/notes/presentation/view_models/note_list_item_view_model.dart';

part 'note_list_state.freezed.dart';

/// One distinct subclass per list-status scenario — **not** a single
/// "ready" state carrying a status flag/enum, per this project's steering
/// rule against mono-state (same rule `NoteEditorState`/`SearchState`
/// follow). Which subclass is active *is* the list status.
///
/// design.md's §"NoteListCubit / FolderCubit / TagCubit / TrashCubit" State
/// Management note specifies exactly two subclasses: `NoteListLoading` and
/// `NoteListLoaded`, the latter carrying a note-view-model list plus a
/// `NoteListFilterViewModel activeFilter`. Two implementer judgment calls
/// were made on top of that
/// spec (see the implementer's Status Report for full reasoning):
///
/// 1. **`activeFilter` type**: design.md names a `NoteListFilterViewModel`
///    type but never defines its fields anywhere in the spec, and the File
///    Structure Plan does not list a `note_list_filter_view_model.dart`
///    file. The domain `NoteListFilterParams` (`String? folderId`,
///    `List<String> tagIds`, `TagFilterMode`, `NoteLifecycleScope`) is
///    already a primitive-only query/filter descriptor with none of the
///    DB-shaped domain-leakage concerns that motivate a separate ViewModel
///    for `Note`/`Folder`/`Tag` — so this state reuses it directly rather
///    than inventing a redundant type that would just duplicate the same 4
///    fields.
/// 2. **[NoteListLoadFailed] is a third subclass** added by this task, not
///    in design.md's two-subclass list. design.md is silent on
///    `Err(failure)` from `WatchFilteredNotesUc` for this Cubit, the same
///    gap `SearchState.searchFailed` was added to close in task 4.3 (see
///    that class's doc comment) — this is a live *stream* failure (the
///    watch subscription itself broke), not an *action* failure like
///    `FolderCreationFailed`/`TagCreationFailed`/`TrashActionFailed`, which
///    are all triggered by a discrete create/restore/delete call. The
///    previously loaded list is deliberately **not** carried forward: a
///    failure means the current filter's watch query broke, and showing a
///    prior filter/query's results as if they still matched the *current*
///    filter would misrepresent stale data as current — the same reasoning
///    `SearchFailed` used for not carrying forward a prior burst's results.
@freezed
sealed class NoteListState with _$NoteListState {
  /// The list stream for the current filter has not yet emitted.
  const factory NoteListState.loading() = NoteListLoading;

  /// The stream emitted `Ok(notes)` for the current filter. An empty
  /// [notes] list is a legitimate zero-match result, not a separate
  /// "empty" subclass (matching the guide's own §7.3 example, where
  /// `ProductsSearchSuccess` doesn't split into a separate empty variant) —
  /// the page derives an empty-state placeholder from `notes.isEmpty`.
  const factory NoteListState.loaded(
    List<NoteListItemViewModel> notes,
    NoteListFilterParams activeFilter,
  ) = NoteListLoaded;

  /// `WatchFilteredNotesUc` emitted `Err(failure)` for the current filter.
  const factory NoteListState.loadFailed(String errorMessage) = NoteListLoadFailed;
}
