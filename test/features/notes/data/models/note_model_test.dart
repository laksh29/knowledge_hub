import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/features/notes/data/local/notes_database.dart' as db;
import 'package:knowledge_hub/features/notes/data/models/note_model.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note.dart';

void main() {
  final DateTime createdAt = DateTime.utc(2026, 1, 1);
  final DateTime updatedAt = DateTime.utc(2026, 1, 2);

  group('NoteModel.fromDriftRow', () {
    test('maps every Drift row column onto the model unchanged', () {
      final db.Note row = db.Note(
        id: 'note-1',
        title: 'Grocery list',
        body: 'Buy milk and eggs',
        folderId: 'folder-1',
        createdAt: createdAt,
        updatedAt: updatedAt,
        deletedAt: null,
      );

      final NoteModel model = NoteModel.fromDriftRow(row);

      expect(model.id, 'note-1');
      expect(model.title, 'Grocery list');
      expect(model.body, 'Buy milk and eggs');
      expect(model.folderId, 'folder-1');
      expect(model.createdAt, createdAt);
      expect(model.updatedAt, updatedAt);
      expect(model.deletedAt, isNull);
    });

    test('preserves a null folderId and a non-null deletedAt independently', () {
      final DateTime deletedAt = DateTime.utc(2026, 1, 3);
      final db.Note row = db.Note(
        id: 'note-2',
        title: 'Trashed note',
        body: 'Body',
        folderId: null,
        createdAt: createdAt,
        updatedAt: updatedAt,
        deletedAt: deletedAt,
      );

      final NoteModel model = NoteModel.fromDriftRow(row);

      expect(model.folderId, isNull);
      expect(model.deletedAt, deletedAt);
    });
  });

  group('NoteModel.toCompanion', () {
    test('carries every field as an explicit, present Value', () {
      final NoteModel model = NoteModel(
        id: 'note-1',
        title: 'Grocery list',
        body: 'Buy milk and eggs',
        folderId: 'folder-1',
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      final db.NotesCompanion companion = model.toCompanion();

      expect(companion.id, const Value('note-1'));
      expect(companion.title, const Value('Grocery list'));
      expect(companion.body, const Value('Buy milk and eggs'));
      expect(companion.folderId, const Value('folder-1'));
      expect(companion.createdAt, Value(createdAt));
      expect(companion.updatedAt, Value(updatedAt));
      expect(companion.deletedAt.present, isTrue, reason: 'a null deletedAt must still be explicit, not absent');
      expect(companion.deletedAt.value, isNull);
    });

    test('an unfiled note maps to an explicit, present null folderId Value', () {
      final NoteModel model = NoteModel(
        id: 'note-2',
        title: 'Independent note',
        body: 'Body',
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      final db.NotesCompanion companion = model.toCompanion();

      expect(companion.folderId.present, isTrue, reason: 'unfiling must be explicit, not silently skipped');
      expect(companion.folderId.value, isNull);
    });
  });

  group('NoteModel.toEntity', () {
    test('converts to the domain Note entity with the provided tagIds', () {
      final NoteModel model = NoteModel(
        id: 'note-1',
        title: 'Grocery list',
        body: 'Buy milk and eggs',
        folderId: 'folder-1',
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      final Note entity = model.toEntity(tagIds: const <String>['tag-1', 'tag-2']);

      expect(entity.id, model.id);
      expect(entity.title, model.title);
      expect(entity.body, model.body);
      expect(entity.folderId, model.folderId);
      expect(entity.tagIds, <String>['tag-1', 'tag-2']);
      expect(entity.createdAt, model.createdAt);
      expect(entity.updatedAt, model.updatedAt);
      expect(entity.deletedAt, isNull);
    });
  });
}
