import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_event.freezed.dart';

/// A single trigger: the user typed or cleared search input. [SearchBloc]
/// gates this behind a 3-character threshold and a 300ms idle debounce
/// (design.md §"SearchBloc" — Requirements 6.1, 6.5) before invoking
/// `WatchNoteSearchResultsUc`.
@freezed
sealed class SearchEvent with _$SearchEvent {
  const factory SearchEvent.queryChanged(String query) = SearchQueryChanged;
}
