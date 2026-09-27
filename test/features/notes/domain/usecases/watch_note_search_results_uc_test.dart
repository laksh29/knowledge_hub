import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note_search_result.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/notes_repository.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/watch_note_search_results_uc.dart';
import 'package:mocktail/mocktail.dart';

class MockNotesRepository extends Mock implements NotesRepository {}

void main() {
  late MockNotesRepository notesRepository;
  late WatchNoteSearchResultsUc watchNoteSearchResultsUc;

  const String tQuery = 'meeting notes';
  final NoteSearchResult tSearchResult = NoteSearchResult(
    note: Note(
      id: 'note-1',
      title: 'Meeting notes',
      body: 'Discussed the roadmap',
      createdAt: DateTime(2026, 1, 1, 9),
      updatedAt: DateTime(2026, 1, 1, 10),
    ),
    highlightedTitleSnippet: '<mark>Meeting notes</mark>',
    highlightedBodySnippet: 'Discussed the roadmap',
  );

  setUp(() {
    notesRepository = MockNotesRepository();
    watchNoteSearchResultsUc = WatchNoteSearchResultsUc(notesRepository);
  });

  test(
    'forwards the query to the repository unchanged and emits its '
    'successful stream events unchanged',
    () async {
      when(() => notesRepository.watchSearchResults(tQuery)).thenAnswer(
        (_) => Stream<Result<Failure, List<NoteSearchResult>>>.value(
          Ok<Failure, List<NoteSearchResult>>(<NoteSearchResult>[
            tSearchResult,
          ]),
        ),
      );

      final Stream<Result<Failure, List<NoteSearchResult>>> resultStream =
          watchNoteSearchResultsUc.call(tQuery);

      await expectLater(
        resultStream,
        emits(
          isA<Ok<Failure, List<NoteSearchResult>>>().having(
            (Ok<Failure, List<NoteSearchResult>> ok) => ok.value,
            'value',
            <NoteSearchResult>[tSearchResult],
          ),
        ),
      );
      verify(() => notesRepository.watchSearchResults(tQuery)).called(1);
      verifyNoMoreInteractions(notesRepository);
    },
  );

  test('propagates the repository\'s failure stream events untouched', () async {
    const ServerFailure tFailure = ServerFailure('search index unavailable');
    when(() => notesRepository.watchSearchResults(tQuery)).thenAnswer(
      (_) => Stream<Result<Failure, List<NoteSearchResult>>>.value(
        const Err<Failure, List<NoteSearchResult>>(tFailure),
      ),
    );

    final Stream<Result<Failure, List<NoteSearchResult>>> resultStream =
        watchNoteSearchResultsUc.call(tQuery);

    await expectLater(
      resultStream,
      emits(
        isA<Err<Failure, List<NoteSearchResult>>>().having(
          (Err<Failure, List<NoteSearchResult>> err) => err.failure_,
          'failure_',
          same(tFailure),
        ),
      ),
    );
    verify(() => notesRepository.watchSearchResults(tQuery)).called(1);
    verifyNoMoreInteractions(notesRepository);
  });
}
