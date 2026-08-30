import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note_list_filter.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/notes_repository.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/watch_filtered_notes_uc.dart';
import 'package:mocktail/mocktail.dart';

class MockNotesRepository extends Mock implements NotesRepository {}

void main() {
  late MockNotesRepository notesRepository;
  late WatchFilteredNotesUc watchFilteredNotesUc;

  const NoteListFilterParams tParams = NoteListFilterParams(
    folderId: 'folder-1',
  );
  final Note tNote = Note(
    id: 'note-1',
    title: 'Title',
    body: 'Body',
    createdAt: DateTime(2026, 1, 1, 9),
    updatedAt: DateTime(2026, 1, 1, 10),
  );

  setUp(() {
    notesRepository = MockNotesRepository();
    watchFilteredNotesUc = WatchFilteredNotesUc(notesRepository);
  });

  test(
    'forwards the params to the repository unchanged and emits its '
    'successful stream events unchanged',
    () async {
      when(() => notesRepository.watchNotes(tParams)).thenAnswer(
        (_) => Stream<Result<Failure, List<Note>>>.value(
          Ok<Failure, List<Note>>(<Note>[tNote]),
        ),
      );

      final Stream<Result<Failure, List<Note>>> resultStream =
          watchFilteredNotesUc.call(tParams);

      await expectLater(
        resultStream,
        emits(
          isA<Ok<Failure, List<Note>>>().having(
            (Ok<Failure, List<Note>> ok) => ok.value,
            'value',
            <Note>[tNote],
          ),
        ),
      );
      verify(() => notesRepository.watchNotes(tParams)).called(1);
      verifyNoMoreInteractions(notesRepository);
    },
  );

  test('propagates the repository\'s failure stream events untouched', () async {
    const ValidationFailure tFailure = ValidationFailure('invalid filter');
    when(() => notesRepository.watchNotes(tParams)).thenAnswer(
      (_) => Stream<Result<Failure, List<Note>>>.value(
        const Err<Failure, List<Note>>(tFailure),
      ),
    );

    final Stream<Result<Failure, List<Note>>> resultStream =
        watchFilteredNotesUc.call(tParams);

    await expectLater(
      resultStream,
      emits(
        isA<Err<Failure, List<Note>>>().having(
          (Err<Failure, List<Note>> err) => err.failure_,
          'failure_',
          same(tFailure),
        ),
      ),
    );
    verify(() => notesRepository.watchNotes(tParams)).called(1);
    verifyNoMoreInteractions(notesRepository);
  });

  test(
    'AND-mode and OR-mode calls on the same use case instance are forwarded '
    'to the repository as distinct params and each returns the stream the '
    'repository produced for that exact params value, unchanged',
    () async {
      const NoteListFilterParams paramsAllOf = NoteListFilterParams(
        tagIds: <String>['tag-1', 'tag-2'],
        tagFilterMode: TagFilterMode.allOf,
      );
      const NoteListFilterParams paramsAnyOf = NoteListFilterParams(
        tagIds: <String>['tag-1', 'tag-2'],
        tagFilterMode: TagFilterMode.anyOf,
      );

      final Note tNoteWithBothTags = Note(
        id: 'note-both-tags',
        title: 'Both tags',
        body: 'Carries every selected tag',
        tagIds: const <String>['tag-1', 'tag-2'],
        createdAt: DateTime(2026, 1, 1, 9),
        updatedAt: DateTime(2026, 1, 1, 9),
      );
      final Note tNoteWithOneTag = Note(
        id: 'note-one-tag',
        title: 'One tag',
        body: 'Carries only one selected tag',
        tagIds: const <String>['tag-1'],
        createdAt: DateTime(2026, 1, 1, 9),
        updatedAt: DateTime(2026, 1, 1, 9),
      );

      final List<Note> notesForAllOf = <Note>[tNoteWithBothTags];
      final List<Note> notesForAnyOf = <Note>[
        tNoteWithBothTags,
        tNoteWithOneTag,
      ];

      when(() => notesRepository.watchNotes(paramsAllOf)).thenAnswer(
        (_) => Stream<Result<Failure, List<Note>>>.value(
          Ok<Failure, List<Note>>(notesForAllOf),
        ),
      );
      when(() => notesRepository.watchNotes(paramsAnyOf)).thenAnswer(
        (_) => Stream<Result<Failure, List<Note>>>.value(
          Ok<Failure, List<Note>>(notesForAnyOf),
        ),
      );

      final Stream<Result<Failure, List<Note>>> allOfResultStream =
          watchFilteredNotesUc.call(paramsAllOf);
      final Stream<Result<Failure, List<Note>>> anyOfResultStream =
          watchFilteredNotesUc.call(paramsAnyOf);

      await expectLater(
        allOfResultStream,
        emits(
          isA<Ok<Failure, List<Note>>>().having(
            (Ok<Failure, List<Note>> ok) => ok.value,
            'value',
            notesForAllOf,
          ),
        ),
      );
      await expectLater(
        anyOfResultStream,
        emits(
          isA<Ok<Failure, List<Note>>>().having(
            (Ok<Failure, List<Note>> ok) => ok.value,
            'value',
            notesForAnyOf,
          ),
        ),
      );
      verify(() => notesRepository.watchNotes(paramsAllOf)).called(1);
      verify(() => notesRepository.watchNotes(paramsAnyOf)).called(1);
      verifyNoMoreInteractions(notesRepository);
    },
  );
}
