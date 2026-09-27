import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/domain/entities/folder.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/folders_repository.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/create_folder_uc.dart';
import 'package:mocktail/mocktail.dart';

class MockFoldersRepository extends Mock implements FoldersRepository {}

void main() {
  late MockFoldersRepository foldersRepository;
  late CreateFolderUc createFolderUc;

  const String tName = 'Coursework';
  const Folder tFolder = Folder(id: 'folder-1', name: tName);

  setUp(() {
    foldersRepository = MockFoldersRepository();
    createFolderUc = CreateFolderUc(foldersRepository);
  });

  test(
    'forwards the name to the repository unchanged and returns its successful result unchanged',
    () async {
      when(() => foldersRepository.createFolder(tName)).thenAnswer(
        (_) async => const Ok<Failure, Folder>(tFolder),
      );

      final Result<Failure, Folder> result = await createFolderUc.call(
        tName,
      );

      expect(result, isA<Ok<Failure, Folder>>());
      expect((result as Ok<Failure, Folder>).value, tFolder);
      verify(() => foldersRepository.createFolder(tName)).called(1);
      verifyNoMoreInteractions(foldersRepository);
    },
  );

  test(
    'propagates a duplicate-name failure from the repository untouched',
    () async {
      const DuplicateNameFailure tFailure = DuplicateNameFailure(
        'A folder named "Coursework" already exists',
      );
      when(() => foldersRepository.createFolder(tName)).thenAnswer(
        (_) async => const Err<Failure, Folder>(tFailure),
      );

      final Result<Failure, Folder> result = await createFolderUc.call(
        tName,
      );

      expect(result, isA<Err<Failure, Folder>>());
      final Failure resultFailure = (result as Err<Failure, Folder>).failure_;
      expect(resultFailure, isA<DuplicateNameFailure>());
      expect(resultFailure, same(tFailure));
      expect(resultFailure.message, tFailure.message);
      verify(() => foldersRepository.createFolder(tName)).called(1);
      verifyNoMoreInteractions(foldersRepository);
    },
  );

  test('propagates the repository\'s failure untouched', () async {
    const ServerFailure tFailure = ServerFailure('boom');
    when(() => foldersRepository.createFolder(tName)).thenAnswer(
      (_) async => const Err<Failure, Folder>(tFailure),
    );

    final Result<Failure, Folder> result = await createFolderUc.call(tName);

    expect(result, isA<Err<Failure, Folder>>());
    expect((result as Err<Failure, Folder>).failure_, same(tFailure));
    verify(() => foldersRepository.createFolder(tName)).called(1);
    verifyNoMoreInteractions(foldersRepository);
  });
}
