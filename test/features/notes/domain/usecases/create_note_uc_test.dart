import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/notes_repository.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/create_note_uc.dart';
import 'package:mocktail/mocktail.dart';

class MockNotesRepository extends Mock implements NotesRepository {}

void main() {
  late MockNotesRepository notesRepository;
  late CreateNoteUc createNoteUc;

  final Note tNote = Note(
    id: 'note-1',
    title: '',
    body: '',
    createdAt: DateTime(2026, 1, 1, 9),
    updatedAt: DateTime(2026, 1, 1, 9),
  );

  setUp(() {
    notesRepository = MockNotesRepository();
    createNoteUc = CreateNoteUc(notesRepository);
  });

  test('returns the repository\'s successful result unchanged', () async {
    when(() => notesRepository.createNote()).thenAnswer(
      (_) async => Ok<Failure, Note>(tNote),
    );

    final Result<Failure, Note> result = await createNoteUc.call();

    expect(result, isA<Ok<Failure, Note>>());
    expect((result as Ok<Failure, Note>).value, tNote);
    verify(() => notesRepository.createNote()).called(1);
    verifyNoMoreInteractions(notesRepository);
  });

  test('propagates the repository\'s failure untouched', () async {
    const ServerFailure tFailure = ServerFailure('boom');
    when(() => notesRepository.createNote()).thenAnswer(
      (_) async => const Err<Failure, Note>(tFailure),
    );

    final Result<Failure, Note> result = await createNoteUc.call();

    expect(result, isA<Err<Failure, Note>>());
    expect((result as Err<Failure, Note>).failure_, same(tFailure));
    verify(() => notesRepository.createNote()).called(1);
    verifyNoMoreInteractions(notesRepository);
  });
}
