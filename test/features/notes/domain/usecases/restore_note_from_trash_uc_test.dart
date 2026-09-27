import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/notes_repository.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/restore_note_from_trash_uc.dart';
import 'package:mocktail/mocktail.dart';

class MockNotesRepository extends Mock implements NotesRepository {}

void main() {
  late MockNotesRepository notesRepository;
  late RestoreNoteFromTrashUc restoreNoteFromTrashUc;

  const String tNoteId = 'note-1';

  setUp(() {
    notesRepository = MockNotesRepository();
    restoreNoteFromTrashUc = RestoreNoteFromTrashUc(notesRepository);
  });

  test(
    'forwards the noteId to the repository unchanged and returns its successful result unchanged',
    () async {
      when(() => notesRepository.restoreNoteFromTrash(tNoteId)).thenAnswer(
        (_) async => const Ok<Failure, void>(null),
      );

      final Result<Failure, void> result = await restoreNoteFromTrashUc.call(
        tNoteId,
      );

      expect(result, isA<Ok<Failure, void>>());
      verify(() => notesRepository.restoreNoteFromTrash(tNoteId)).called(1);
      verifyNoMoreInteractions(notesRepository);
    },
  );

  test('propagates the repository\'s failure untouched', () async {
    const ServerFailure tFailure = ServerFailure('boom');
    when(() => notesRepository.restoreNoteFromTrash(tNoteId)).thenAnswer(
      (_) async => const Err<Failure, void>(tFailure),
    );

    final Result<Failure, void> result = await restoreNoteFromTrashUc.call(
      tNoteId,
    );

    expect(result, isA<Err<Failure, void>>());
    expect((result as Err<Failure, void>).failure_, same(tFailure));
    verify(() => notesRepository.restoreNoteFromTrash(tNoteId)).called(1);
    verifyNoMoreInteractions(notesRepository);
  });
}
