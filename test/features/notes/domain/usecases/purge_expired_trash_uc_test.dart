import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/notes_repository.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/purge_expired_trash_uc.dart';
import 'package:mocktail/mocktail.dart';

class MockNotesRepository extends Mock implements NotesRepository {}

void main() {
  late MockNotesRepository notesRepository;
  late PurgeExpiredTrashUc purgeExpiredTrashUc;

  setUp(() {
    notesRepository = MockNotesRepository();
    purgeExpiredTrashUc = PurgeExpiredTrashUc(notesRepository);
  });

  test(
    'returns the repository\'s reported removed-note count unchanged',
    () async {
      when(() => notesRepository.purgeExpiredTrash()).thenAnswer(
        (_) async => const Ok<Failure, int>(5),
      );

      final Result<Failure, int> result = await purgeExpiredTrashUc.call();

      expect(result, isA<Ok<Failure, int>>());
      expect((result as Ok<Failure, int>).value, 5);
      verify(() => notesRepository.purgeExpiredTrash()).called(1);
      verifyNoMoreInteractions(notesRepository);
    },
  );

  test('propagates the repository\'s failure untouched', () async {
    const ServerFailure tFailure = ServerFailure('boom');
    when(() => notesRepository.purgeExpiredTrash()).thenAnswer(
      (_) async => const Err<Failure, int>(tFailure),
    );

    final Result<Failure, int> result = await purgeExpiredTrashUc.call();

    expect(result, isA<Err<Failure, int>>());
    expect((result as Err<Failure, int>).failure_, same(tFailure));
    verify(() => notesRepository.purgeExpiredTrash()).called(1);
    verifyNoMoreInteractions(notesRepository);
  });
}
