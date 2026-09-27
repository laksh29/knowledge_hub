import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/core/error/exception.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/data/models/folder_model.dart';
import 'package:knowledge_hub/features/notes/data/repositories/folders_repository_impl.dart';
import 'package:knowledge_hub/features/notes/domain/entities/folder.dart';

import 'fakes/fake_folders_data_source.dart';

void main() {
  late FakeFoldersDataSource dataSource;
  late FoldersRepositoryImpl repository;

  setUp(() {
    dataSource = FakeFoldersDataSource();
    repository = FoldersRepositoryImpl(dataSource);
  });

  group('createFolder', () {
    test('converts the created FolderModel to a Folder entity', () async {
      final Result<Failure, Folder> result = await repository.createFolder('Work');

      expect(result, isA<Ok<Failure, Folder>>());
      final Folder folder = (result as Ok<Failure, Folder>).value;
      expect(folder.name, 'Work');
      expect(folder.id, isNotEmpty);
    });

    test('a duplicate name surfaces as Err(DuplicateNameFailure), not CacheFailure', () async {
      dataSource.createFolderException = const DuplicateNameException(
        'A folder named "Work" already exists',
      );

      final Result<Failure, Folder> result = await repository.createFolder('Work');

      expect(result, isA<Err<Failure, Folder>>());
      final Failure failure = (result as Err<Failure, Folder>).failure_;
      expect(failure, isA<DuplicateNameFailure>());
      expect(failure.message, 'A folder named "Work" already exists');
    });

    test('a CacheException converts to Err(CacheFailure) with the original message', () async {
      dataSource.createFolderException = const CacheException('disk write failed');

      final Result<Failure, Folder> result = await repository.createFolder('Work');

      expect(result, isA<Err<Failure, Folder>>());
      final Failure failure = (result as Err<Failure, Folder>).failure_;
      expect(failure, isA<CacheFailure>());
      expect(failure.message, 'disk write failed');
    });

    test('a ServerException converts to Err(ServerFailure) with the original message', () async {
      dataSource.createFolderException = const ServerException('upstream unavailable');

      final Result<Failure, Folder> result = await repository.createFolder('Work');

      expect(result, isA<Err<Failure, Folder>>());
      final Failure failure = (result as Err<Failure, Folder>).failure_;
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'upstream unavailable');
    });
  });

  group('watchFolders', () {
    test('converts every emitted FolderModel to a Folder entity', () async {
      dataSource.seedFolder(const FolderModel(id: 'folder-work', name: 'Work'));
      dataSource.seedFolder(const FolderModel(id: 'folder-personal', name: 'Personal'));

      final Result<Failure, List<Folder>> result = await repository.watchFolders().first;

      expect(result, isA<Ok<Failure, List<Folder>>>());
      final List<Folder> folders = (result as Ok<Failure, List<Folder>>).value;
      expect(
        folders.map((Folder f) => f.name).toSet(),
        <String>{'Work', 'Personal'},
      );
    });

    test('a CacheException from the stream converts to Err(CacheFailure)', () async {
      dataSource.watchFoldersException = const CacheException('query failed');

      final Result<Failure, List<Folder>> result = await repository.watchFolders().first;

      expect(result, isA<Err<Failure, List<Folder>>>());
      final Failure failure = (result as Err<Failure, List<Folder>>).failure_;
      expect(failure, isA<CacheFailure>());
      expect(failure.message, 'query failed');
    });

    test('a ServerException from the stream converts to Err(ServerFailure)', () async {
      dataSource.watchFoldersException = const ServerException('sync failed');

      final Result<Failure, List<Folder>> result = await repository.watchFolders().first;

      expect(result, isA<Err<Failure, List<Folder>>>());
      final Failure failure = (result as Err<Failure, List<Folder>>).failure_;
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'sync failed');
    });
  });

  group('deleteFolder', () {
    test('passes through to the data source and returns Ok(void)', () async {
      dataSource.seedFolder(const FolderModel(id: 'folder-work', name: 'Work'));

      final Result<Failure, void> result = await repository.deleteFolder('folder-work');

      expect(result, isA<Ok<Failure, void>>());
    });

    test('notes previously in the deleted folder become unfiled, not deleted', () async {
      dataSource.seedFolder(const FolderModel(id: 'folder-work', name: 'Work'));
      dataSource.seedNoteInFolder(noteId: 'note-1', folderId: 'folder-work');

      final Result<Failure, void> result = await repository.deleteFolder('folder-work');

      expect(result, isA<Ok<Failure, void>>(), reason: 'deleteFolder must not error');
      expect(
        dataSource.folderIdOfNote('note-1'),
        isNull,
        reason: 'the note must survive, now unfiled -- deleteFolder must not delete or error on it',
      );
    });

    test('a CacheException converts to Err(CacheFailure) with the original message', () async {
      dataSource.deleteFolderException = const CacheException('delete failed');

      final Result<Failure, void> result = await repository.deleteFolder('folder-work');

      expect(result, isA<Err<Failure, void>>());
      final Failure failure = (result as Err<Failure, void>).failure_;
      expect(failure, isA<CacheFailure>());
      expect(failure.message, 'delete failed');
    });

    test('a ServerException converts to Err(ServerFailure) with the original message', () async {
      dataSource.deleteFolderException = const ServerException('server unavailable');

      final Result<Failure, void> result = await repository.deleteFolder('folder-work');

      expect(result, isA<Err<Failure, void>>());
      final Failure failure = (result as Err<Failure, void>).failure_;
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'server unavailable');
    });
  });
}
