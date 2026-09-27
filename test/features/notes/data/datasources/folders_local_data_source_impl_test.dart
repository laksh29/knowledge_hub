import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/core/error/exception.dart';
import 'package:knowledge_hub/features/notes/data/datasources/folders_data_source.dart';
import 'package:knowledge_hub/features/notes/data/datasources/folders_local_data_source_impl.dart';
import 'package:knowledge_hub/features/notes/data/local/notes_database.dart';
import 'package:knowledge_hub/features/notes/data/models/folder_model.dart';

void main() {
  late NotesDatabase database;
  late FoldersDataSource dataSource;

  setUp(() {
    database = NotesDatabase(NativeDatabase.memory());
    dataSource = FoldersLocalDataSourceImpl(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('createFolder / round-trip', () {
    test('a folder round-trips through storage unchanged', () async {
      final FolderModel created = await dataSource.createFolder('Work');

      final List<FolderModel> folders = await dataSource.watchFolders().first;
      final FolderModel stored = folders.single;

      expect(stored.id, created.id);
      expect(stored.id, isNotEmpty);
      expect(stored.name, 'Work');
    });

    test('creating a duplicate folder name throws DuplicateNameException', () async {
      await dataSource.createFolder('Work');

      expect(() => dataSource.createFolder('Work'), throwsA(isA<DuplicateNameException>()));
    });

    test('a duplicate-name failure does not insert a second row', () async {
      await dataSource.createFolder('Work');
      try {
        await dataSource.createFolder('Work');
      } on DuplicateNameException {
        // expected
      }

      final List<FolderModel> folders = await dataSource.watchFolders().first;

      expect(folders, hasLength(1));
    });

    test(
      'two concurrent createFolder calls with the same name never surface CacheException, '
      'and exactly one row is persisted',
      () async {
        Future<Object?> createOrCaptureError() async {
          try {
            return await dataSource.createFolder('Work');
          } on Exception catch (e) {
            return e;
          }
        }

        final List<Object?> results = await Future.wait<Object?>(<Future<Object?>>[
          createOrCaptureError(),
          createOrCaptureError(),
        ]);

        for (final Object? result in results) {
          expect(
            result,
            isNot(isA<CacheException>()),
            reason: 'A racing createFolder call must never surface CacheException',
          );
        }

        final bool atLeastOneDuplicateNameException = results.any(
          (Object? r) => r is DuplicateNameException,
        );
        expect(
          atLeastOneDuplicateNameException,
          isTrue,
          reason: 'At least one of the two racing calls must throw DuplicateNameException',
        );

        final List<FolderModel> folders = await dataSource.watchFolders().first;
        expect(folders, hasLength(1));
      },
    );
  });

  group('watchFolders', () {
    test('emits every created folder', () async {
      await dataSource.createFolder('Work');
      await dataSource.createFolder('Personal');

      final List<FolderModel> folders = await dataSource.watchFolders().first;

      expect(folders.map((FolderModel f) => f.name).toSet(), <String>{'Work', 'Personal'});
    });
  });

  group('deleteFolder', () {
    test('removes the folder row entirely', () async {
      final FolderModel created = await dataSource.createFolder('Work');

      await dataSource.deleteFolder(created.id);
      final List<FolderModel> folders = await dataSource.watchFolders().first;

      expect(folders, isEmpty);
    });

    test('unfiles notes previously assigned to the deleted folder', () async {
      final FolderModel created = await dataSource.createFolder('Work');
      await database
          .into(database.notes)
          .insert(
            NotesCompanion.insert(
              id: 'note-1',
              title: 'Note',
              body: 'Body',
              folderId: drift.Value(created.id),
              createdAt: DateTime.utc(2026),
              updatedAt: DateTime.utc(2026),
            ),
          );

      await dataSource.deleteFolder(created.id);
      final Note? note = await (database.select(
        database.notes,
      )..where((n) => n.id.equals('note-1'))).getSingleOrNull();

      expect(note?.folderId, isNull);
    });
  });
}
