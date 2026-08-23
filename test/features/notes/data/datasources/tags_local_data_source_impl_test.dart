import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/core/error/exception.dart';
import 'package:knowledge_hub/features/notes/data/datasources/tags_data_source.dart';
import 'package:knowledge_hub/features/notes/data/datasources/tags_local_data_source_impl.dart';
import 'package:knowledge_hub/features/notes/data/local/notes_database.dart';
import 'package:knowledge_hub/features/notes/data/models/tag_model.dart';

void main() {
  late NotesDatabase database;
  late TagsDataSource dataSource;

  setUp(() {
    database = NotesDatabase(NativeDatabase.memory());
    dataSource = TagsLocalDataSourceImpl(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('createTag / round-trip', () {
    test('a tag round-trips through storage unchanged', () async {
      final TagModel created = await dataSource.createTag('errands');

      final List<TagModel> tags = await dataSource.watchTags().first;
      final TagModel stored = tags.single;

      expect(stored.id, created.id);
      expect(stored.id, isNotEmpty);
      expect(stored.name, 'errands');
    });

    test('creating a duplicate tag name throws DuplicateNameException', () async {
      await dataSource.createTag('errands');

      expect(() => dataSource.createTag('errands'), throwsA(isA<DuplicateNameException>()));
    });

    test('a duplicate-name failure does not insert a second row', () async {
      await dataSource.createTag('errands');
      try {
        await dataSource.createTag('errands');
      } on DuplicateNameException {
        // expected
      }

      final List<TagModel> tags = await dataSource.watchTags().first;

      expect(tags, hasLength(1));
    });

    test(
      'two concurrent createTag calls with the same name never surface CacheException, '
      'and exactly one row is persisted',
      () async {
        Future<Object?> createOrCaptureError() async {
          try {
            return await dataSource.createTag('errands');
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
            reason: 'A racing createTag call must never surface CacheException',
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

        final List<TagModel> tags = await dataSource.watchTags().first;
        expect(tags, hasLength(1));
      },
    );
  });

  group('watchTags', () {
    test('emits every created tag', () async {
      await dataSource.createTag('errands');
      await dataSource.createTag('school');

      final List<TagModel> tags = await dataSource.watchTags().first;

      expect(tags.map((TagModel t) => t.name).toSet(), <String>{'errands', 'school'});
    });
  });

  group('deleteTag', () {
    test('removes the tag row entirely', () async {
      final TagModel created = await dataSource.createTag('errands');

      await dataSource.deleteTag(created.id);
      final List<TagModel> tags = await dataSource.watchTags().first;

      expect(tags, isEmpty);
    });

    test(
      'removes only the note-tag association for the deleted tag, never the note itself',
      () async {
        final TagModel created = await dataSource.createTag('errands');
        await database
            .into(database.notes)
            .insert(
              NotesCompanion.insert(
                id: 'note-1',
                title: 'Grocery list',
                body: 'Buy milk and eggs',
                createdAt: DateTime.utc(2026),
                updatedAt: DateTime.utc(2026),
              ),
            );
        await database
            .into(database.noteTags)
            .insert(
              NoteTagsCompanion.insert(noteId: 'note-1', tagId: created.id),
            );

        await dataSource.deleteTag(created.id);

        final int remainingAssociations = await database
            .select(database.noteTags)
            .get()
            .then((rows) => rows.length);
        final Note note = await (database.select(
          database.notes,
        )..where((n) => n.id.equals('note-1'))).getSingle();

        expect(remainingAssociations, 0, reason: 'the note-tag association must be gone');
        expect(note.title, 'Grocery list', reason: 'the note itself must survive untouched');
      },
    );
  });
}
