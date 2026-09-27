import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/domain/entities/folder.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/folders_repository.dart';

import 'fakes/fake_folders_repository.dart';

void main() {
  final Folder existingFolder = const Folder(id: 'folder-1', name: 'Work');

  late FoldersRepository foldersRepository;

  setUp(() {
    foldersRepository = FakeFoldersRepository(
      existingFolders: <Folder>[existingFolder],
    );
  });

  test('a fake genuinely implements FoldersRepository', () {
    expect(foldersRepository, isA<FoldersRepository>());
  });

  test(
    'createFolder takes a String name and returns Future<Result<Failure, Folder>>',
    () async {
      final Future<Result<Failure, Folder>> pending = foldersRepository
          .createFolder('Personal');

      expect(pending, isA<Future<Result<Failure, Folder>>>());
      final Result<Failure, Folder> result = await pending;
      expect(result, isA<Ok<Failure, Folder>>());
      expect((result as Ok<Failure, Folder>).value.name, 'Personal');
    },
  );

  test(
    'createFolder surfaces a duplicate name as Err(DuplicateNameFailure)',
    () async {
      final Result<Failure, Folder> result = await foldersRepository
          .createFolder('Work');

      expect(result, isA<Err<Failure, Folder>>());
      expect(
        (result as Err<Failure, Folder>).failure_,
        isA<DuplicateNameFailure>(),
      );
    },
  );

  test('watchFolders returns Stream<Result<Failure, List<Folder>>>', () async {
    final Stream<Result<Failure, List<Folder>>> stream = foldersRepository
        .watchFolders();

    expect(stream, isA<Stream<Result<Failure, List<Folder>>>>());
    final Result<Failure, List<Folder>> result = await stream.first;
    expect(result, isA<Ok<Failure, List<Folder>>>());
    expect((result as Ok<Failure, List<Folder>>).value, <Folder>[
      existingFolder,
    ]);
  });

  test(
    'deleteFolder takes a folderId and returns Future<Result<Failure, void>>',
    () async {
      final Result<Failure, void> result = await foldersRepository
          .deleteFolder('folder-1');

      expect(result, isA<Ok<Failure, void>>());
    },
  );
}
