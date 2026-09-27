import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note_search_result.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/watch_note_search_results_uc.dart';
import 'package:knowledge_hub/features/notes/presentation/bloc/search/search_event.dart';
import 'package:knowledge_hub/features/notes/presentation/bloc/search/search_state.dart';
import 'package:knowledge_hub/features/notes/presentation/map_failure_to_message.dart';
import 'package:knowledge_hub/features/notes/presentation/view_models/note_search_result_view_model.dart';
import 'package:stream_transform/stream_transform.dart';

/// Minimum query length before a search is dispatched to
/// `WatchNoteSearchResultsUc` (design.md §"SearchBloc" — Requirement 6.1).
const int _minimumQueryLength = 3;

/// Idle time the query must remain unchanged before it settles and a search
/// fires (design.md §"SearchBloc" — Requirement 6.1).
const Duration _searchIdleDebounce = Duration(milliseconds: 300);

/// Debounces every [SearchQueryChanged] event by [duration], then applies
/// `bloc_concurrency`'s `restartable()` semantics so a fresh keystroke that
/// arrives after the debounce settles cancels any in-flight search stream
/// subscription from a prior query. `bloc_concurrency` alone does not ship a
/// debounce transformer (only `concurrent`/`sequential`/`droppable`/
/// `restartable`) — the idle wait itself comes from
/// `package:stream_transform`'s `.debounce(Duration)` extension, composed
/// with `restartable()` around it.
EventTransformer<E> _debounceRestartable<E>(Duration duration) {
  return (Stream<E> events, EventMapper<E> mapper) =>
      restartable<E>()(events.debounce(duration), mapper);
}

/// Debounced, gated search orchestration (design.md §"SearchBloc" —
/// Requirements 6.1-6.5).
///
/// Every [SearchQueryChanged] event — including one that drops the query
/// back below [_minimumQueryLength] — passes through the same
/// [_debounceRestartable] transformer before its handler runs. This is a
/// deliberate judgment call: Requirement 6.1's trigger condition is "typed
/// at least 3 characters AND remained idle for 300ms" with no separate
/// wording about an immediate below-threshold UI reset, and registering a
/// second, un-debounced handler for the same event isn't possible without
/// introducing a second event type — which would contradict this task's
/// "keep it minimal" scope. The single-handler design still satisfies the
/// task's Observable exactly: no call to `WatchNoteSearchResultsUc` ever
/// fires for a query under [_minimumQueryLength] characters, and no call
/// fires before the 300ms idle debounce settles, regardless of which
/// direction the query is heading. The one accepted trade-off is that
/// resetting to [SearchState.initial] after backspacing below the threshold
/// also waits out the debounce rather than firing immediately — see the
/// implementer's Status Report for the full reasoning.
///
/// [SearchState.searchFailed] is a judgment-call addition beyond
/// design.md's documented four-state model — see `search_state.dart`'s
/// class-level doc comment.
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({required WatchNoteSearchResultsUc watchNoteSearchResultsUc})
    : _watchNoteSearchResultsUc = watchNoteSearchResultsUc,
      super(const SearchState.initial()) {
    on<SearchQueryChanged>(
      _onQueryChanged,
      transformer: _debounceRestartable<SearchQueryChanged>(_searchIdleDebounce),
    );
  }

  final WatchNoteSearchResultsUc _watchNoteSearchResultsUc;

  Future<void> _onQueryChanged(SearchQueryChanged event, Emitter<SearchState> emit) async {
    final String query = event.query;
    if (query.length < _minimumQueryLength) {
      emit(const SearchState.initial());
      return;
    }

    emit(const SearchState.searching());
    await emit.forEach<Result<Failure, List<NoteSearchResult>>>(
      _watchNoteSearchResultsUc(query),
      onData: _mapSearchResultToState,
    );
  }

  SearchState _mapSearchResultToState(Result<Failure, List<NoteSearchResult>> result) {
    return result.when(
      failure: (Failure failure) => SearchState.searchFailed(mapFailureToMessage(failure)),
      success: (List<NoteSearchResult> results) => results.isEmpty
          ? const SearchState.noResults()
          : SearchState.results(
              results.map(NoteSearchResultViewModel.fromSearchResult).toList(),
            ),
    );
  }
}
