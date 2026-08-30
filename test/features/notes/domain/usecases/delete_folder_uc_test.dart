import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/folders_repository.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/delete_folder_uc.dart';
import 'package:mocktail/mocktail.dart';

class MockFoldersRepository extends Mock implements FoldersRepository {}

void main() {
  late MockFoldersRepository foldersRepository;
  late DeleteFolderUc deleteFolderUc;

  const String tFolderId = 'folder-1';

  setUp(() {
    foldersRepository = MockFoldersRepository();
    deleteFolderUc = DeleteFolderUc(foldersRepository);
  });

  test(
    'forwards the folderId to the repository unchanged and returns its successful result unchanged',
    () async {
      when(() => foldersRepository.deleteFolder(tFolderId)).thenAnswer(
        (_) async => const Ok<Failure, void>(null),
      );

      final Result<Failure, void> result = await deleteFolderUc.call(
        tFolderId,
      );

      expect(result, isA<Ok<Failure, void>>());
      verify(() => foldersRepository.deleteFolder(tFolderId)).called(1);
      verifyNoMoreInteractions(foldersRepository);
    },
  );

  test('propagates the repository\'s failure untouched', () async {
    const ServerFailure tFailure = ServerFailure('boom');
    when(() => foldersRepository.deleteFolder(tFolderId)).thenAnswer(
      (_) async => const Err<Failure, void>(tFailure),
    );

    final Result<Failure, void> result = await deleteFolderUc.call(
      tFolderId,
    );

    expect(result, isA<Err<Failure, void>>());
    expect((result as Err<Failure, void>).failure_, same(tFailure));
    verify(() => foldersRepository.deleteFolder(tFolderId)).called(1);
    verifyNoMoreInteractions(foldersRepository);
  });
}
