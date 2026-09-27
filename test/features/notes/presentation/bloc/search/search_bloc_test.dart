import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note_search_result.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/watch_note_search_results_uc.dart';
import 'package:knowledge_hub/features/notes/presentation/bloc/search/search_bloc.dart';
import 'package:knowledge_hub/features/notes/presentation/bloc/search/search_event.dart';
import 'package:knowledge_hub/features/notes/presentation/bloc/search/search_state.dart';
import 'package:knowledge_hub/features/notes/presentation/view_models/note_search_result_view_model.dart';
import 'package:mocktail/mocktail.dart';

class MockWatchNoteSearchResultsUc extends Mock implements WatchNoteSearchResultsUc {}

// The debounce window is a real Timer (`package:stream_transform`'s
// `.debounce(Duration)`); plain `flutter_test` has no `bloc_test` fake-clock
// helper available on this toolchain (see design.md's 2026-08-30 tooling
// correction), so these tests wait past the real 300ms window with a
// generous buffer rather than using a fake clock.
const Duration _pastDebounce = Duration(milliseconds: 400);

void main() {
  late MockWatchNoteSearchResultsUc watchNoteSearchResultsUc;

  final NoteSearchResult tSearchResult = NoteSearchResult(
    note: Note(
      id: 'note-1',
      title: 'Meeting notes',
      body: 'Discussed the roadmap',
      folderId: 'folder-1',
      tagIds: const <String>['tag-1'],
      createdAt: DateTime.utc(2026, 1, 1, 9),
      updatedAt: DateTime.utc(2026, 1, 1, 10),
    ),
    highlightedTitleSnippet: '<mark>Meeting</mark> notes',
    highlightedBodySnippet: 'Discussed the roadmap',
  );

  setUpAll(() {
    registerFallbackValue('fallback-query');
  });

  setUp(() {
    watchNoteSearchResultsUc = MockWatchNoteSearchResultsUc();
  });

  SearchBloc buildBloc() => SearchBloc(watchNoteSearchResultsUc: watchNoteSearchResultsUc);

  group('SearchBloc', () {
    test(
      'a query below the 3-character threshold never calls '
      'WatchNoteSearchResultsUc, even after waiting past the 300ms debounce',
      () async {
        final SearchBloc bloc = buildBloc();
        addTearDown(bloc.close);

        bloc.add(const SearchEvent.queryChanged('ab'));
        await Future<void>.delayed(_pastDebounce);

        verifyNever(() => watchNoteSearchResultsUc.call(any()));
        expect(bloc.state, isA<SearchInitial>());
      },
    );

    test(
      'rapid-fire query changes before the 300ms idle debounce settles only '
      'trigger one final call to WatchNoteSearchResultsUc, with the last query value',
      () async {
        when(() => watchNoteSearchResultsUc.call(any())).thenAnswer(
          (_) => Stream<Result<Failure, List<NoteSearchResult>>>.value(
            Ok<Failure, List<NoteSearchResult>>(<NoteSearchResult>[tSearchResult]),
          ),
        );

        final SearchBloc bloc = buildBloc();
        addTearDown(bloc.close);

        bloc.add(const SearchEvent.queryChanged('exa'));
        bloc.add(const SearchEvent.queryChanged('exam'));
        bloc.add(const SearchEvent.queryChanged('examp'));
        bloc.add(const SearchEvent.queryChanged('example'));
        await Future<void>.delayed(_pastDebounce);

        verify(() => watchNoteSearchResultsUc.call('example')).called(1);
        verifyNever(() => watchNoteSearchResultsUc.call('exa'));
        verifyNever(() => watchNoteSearchResultsUc.call('exam'));
        verifyNever(() => watchNoteSearchResultsUc.call('examp'));
      },
    );

    test(
      'a settled query matching zero notes emits the distinct SearchNoResults '
      'state, not SearchResultsLoaded with an empty list',
      () async {
        when(() => watchNoteSearchResultsUc.call('nomatch')).thenAnswer(
          (_) => Stream<Result<Failure, List<NoteSearchResult>>>.value(
            const Ok<Failure, List<NoteSearchResult>>(<NoteSearchResult>[]),
          ),
        );

        final SearchBloc bloc = buildBloc();
        addTearDown(bloc.close);

        bloc.add(const SearchEvent.queryChanged('nomatch'));

        await expectLater(
          bloc.stream,
          emitsInOrder(<Matcher>[isA<SearchSearching>(), isA<SearchNoResults>()]),
        );
      },
    );

    test(
      'a settled query matching notes emits SearchResultsLoaded with the '
      'correctly converted NoteSearchResultViewModel list',
      () async {
        when(() => watchNoteSearchResultsUc.call('meeting')).thenAnswer(
          (_) => Stream<Result<Failure, List<NoteSearchResult>>>.value(
            Ok<Failure, List<NoteSearchResult>>(<NoteSearchResult>[tSearchResult]),
          ),
        );

        final SearchBloc bloc = buildBloc();
        addTearDown(bloc.close);

        bloc.add(const SearchEvent.queryChanged('meeting'));

        final NoteSearchResultViewModel expectedViewModel =
            NoteSearchResultViewModel.fromSearchResult(tSearchResult);

        await expectLater(
          bloc.stream,
          emitsInOrder(<Matcher>[
            isA<SearchSearching>(),
            isA<SearchResultsLoaded>().having(
              (SearchResultsLoaded state) => state.viewModels,
              'viewModels',
              <NoteSearchResultViewModel>[expectedViewModel],
            ),
          ]),
        );
      },
    );

    test(
      'a repository failure for the settled query emits SearchFailed with a '
      'mapped error message, not the no-results state',
      () async {
        when(() => watchNoteSearchResultsUc.call('meeting')).thenAnswer(
          (_) => Stream<Result<Failure, List<NoteSearchResult>>>.value(
            const Err<Failure, List<NoteSearchResult>>(ServerFailure('search index unavailable')),
          ),
        );

        final SearchBloc bloc = buildBloc();
        addTearDown(bloc.close);

        bloc.add(const SearchEvent.queryChanged('meeting'));

        await expectLater(
          bloc.stream,
          emitsInOrder(<Matcher>[isA<SearchSearching>(), isA<SearchFailed>()]),
        );
      },
    );
  });
}
