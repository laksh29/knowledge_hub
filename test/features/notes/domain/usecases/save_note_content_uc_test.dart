import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/notes_repository.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/save_note_content_uc.dart';
import 'package:mocktail/mocktail.dart';

class MockNotesRepository extends Mock implements NotesRepository {}

void main() {
  late MockNotesRepository notesRepository;
  late SaveNoteContentUc saveNoteContentUc;

  const SaveNoteContentParams tParams = SaveNoteContentParams(
    noteId: 'note-1',
    title: 'Title',
    body: 'Body',
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
    saveNoteContentUc = SaveNoteContentUc(notesRepository);
  });

  test(
    'forwards the params to the repository unchanged and returns its successful result unchanged',
    () async {
      when(() => notesRepository.saveNoteContent(tParams)).thenAnswer(
        (_) async => Ok<Failure, Note>(tNote),
      );

      final Result<Failure, Note> result = await saveNoteContentUc.call(
        tParams,
      );

      expect(result, isA<Ok<Failure, Note>>());
      expect((result as Ok<Failure, Note>).value, tNote);
      verify(() => notesRepository.saveNoteContent(tParams)).called(1);
      verifyNoMoreInteractions(notesRepository);
    },
  );

  test('propagates the repository\'s failure untouched', () async {
    const ValidationFailure tFailure = ValidationFailure('invalid');
    when(() => notesRepository.saveNoteContent(tParams)).thenAnswer(
      (_) async => const Err<Failure, Note>(tFailure),
    );

    final Result<Failure, Note> result = await saveNoteContentUc.call(
      tParams,
    );

    expect(result, isA<Err<Failure, Note>>());
    expect((result as Err<Failure, Note>).failure_, same(tFailure));
    verify(() => notesRepository.saveNoteContent(tParams)).called(1);
    verifyNoMoreInteractions(notesRepository);
  });
}
