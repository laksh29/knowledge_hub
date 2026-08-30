import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/notes_repository.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/move_note_to_trash_uc.dart';
import 'package:mocktail/mocktail.dart';

class MockNotesRepository extends Mock implements NotesRepository {}

void main() {
  late MockNotesRepository notesRepository;
  late MoveNoteToTrashUc moveNoteToTrashUc;

  const String tNoteId = 'note-1';

  setUp(() {
    notesRepository = MockNotesRepository();
    moveNoteToTrashUc = MoveNoteToTrashUc(notesRepository);
  });

  test(
    'forwards the noteId to the repository unchanged and returns its successful result unchanged',
    () async {
      when(() => notesRepository.moveNoteToTrash(tNoteId)).thenAnswer(
        (_) async => const Ok<Failure, void>(null),
      );

      final Result<Failure, void> result = await moveNoteToTrashUc.call(
        tNoteId,
      );

      expect(result, isA<Ok<Failure, void>>());
      verify(() => notesRepository.moveNoteToTrash(tNoteId)).called(1);
      verifyNoMoreInteractions(notesRepository);
    },
  );

  test('propagates the repository\'s failure untouched', () async {
    const ServerFailure tFailure = ServerFailure('boom');
    when(() => notesRepository.moveNoteToTrash(tNoteId)).thenAnswer(
      (_) async => const Err<Failure, void>(tFailure),
    );

    final Result<Failure, void> result = await moveNoteToTrashUc.call(
      tNoteId,
    );

    expect(result, isA<Err<Failure, void>>());
    expect((result as Err<Failure, void>).failure_, same(tFailure));
    verify(() => notesRepository.moveNoteToTrash(tNoteId)).called(1);
    verifyNoMoreInteractions(notesRepository);
  });
}
