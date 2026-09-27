import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:knowledge_hub/features/notes/presentation/view_models/note_search_result_view_model.dart';

part 'search_state.freezed.dart';

/// One distinct subclass per search-status scenario — **not** a single
/// "ready" state carrying a status flag/enum, per this project's steering
/// rule against mono-state (same rule `NoteEditorState` follows). Which
/// subclass is active *is* the search status.
///
/// design.md's §"SearchBloc" State Management note specifies exactly four
/// subclasses: [SearchInitial], [SearchSearching], [SearchResultsLoaded],
/// [SearchNoResults]. [SearchFailed] is a fifth subclass added by this task
/// as a judgment call — design.md's model is silent on repository/query
/// failures (`Err(failure)` from `WatchNoteSearchResultsUc`), and collapsing
/// a failure into [SearchNoResults] would misrepresent a broken query as a
/// legitimate zero-match search to the user. This mirrors the established
/// codebase pattern of a distinct `*Failed` subclass (e.g.
/// `FolderCreationFailed`, `TrashActionFailed`) rather than a shared status
/// flag. See the implementer's Status Report for the full reasoning.
@freezed
sealed class SearchState with _$SearchState {
  /// Query is empty or below the 3-character threshold (Requirement 6.1).
  const factory SearchState.initial() = SearchInitial;

  /// The query has met the threshold and idle-debounce gate; a search is in
  /// flight.
  const factory SearchState.searching() = SearchSearching;

  /// The settled query matched at least one note.
  const factory SearchState.results(List<NoteSearchResultViewModel> viewModels) =
      SearchResultsLoaded;

  /// The settled query matched zero notes — distinct from [SearchResultsLoaded]
  /// with an empty list (Requirement 6.5).
  const factory SearchState.noResults() = SearchNoResults;

  /// `WatchNoteSearchResultsUc` emitted `Err(failure)` for the settled query.
  const factory SearchState.searchFailed(String errorMessage) = SearchFailed;
}
