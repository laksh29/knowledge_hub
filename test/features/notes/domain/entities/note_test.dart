import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note.dart';

void main() {
  group('Note', () {
    final DateTime createdAt = DateTime(2026, 1, 1, 9);
    final DateTime updatedAt = DateTime(2026, 1, 2, 10);

    test('holds every constructed field with its explicit, concrete type', () {
      final Note note = Note(
        id: 'note-1',
        title: 'Title',
        body: 'Body',
        folderId: 'folder-1',
        tagIds: const <String>['tag-1', 'tag-2'],
        createdAt: createdAt,
        updatedAt: updatedAt,
        deletedAt: null,
      );

      expect(note.id, isA<String>());
      expect(note.id, 'note-1');
      expect(note.title, isA<String>());
      expect(note.title, 'Title');
      expect(note.body, isA<String>());
      expect(note.body, 'Body');
      expect(note.folderId, isA<String?>());
      expect(note.folderId, 'folder-1');
      expect(note.tagIds, isA<List<String>>());
      expect(note.tagIds, <String>['tag-1', 'tag-2']);
      expect(note.createdAt, isA<DateTime>());
      expect(note.createdAt, createdAt);
      expect(note.updatedAt, isA<DateTime>());
      expect(note.updatedAt, updatedAt);
      expect(note.deletedAt, isNull);
    });

    test('defaults tagIds to an empty list when omitted', () {
      final Note note = Note(
        id: 'note-2',
        title: 'Title',
        body: 'Body',
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(note.tagIds, isA<List<String>>());
      expect(note.tagIds, isEmpty);
    });

    test('folderId null and deletedAt non-null: unfiled and trashed', () {
      final DateTime deletedAt = DateTime(2026, 1, 3);
      final Note note = Note(
        id: 'note-3',
        title: 'Title',
        body: 'Body',
        folderId: null,
        createdAt: createdAt,
        updatedAt: updatedAt,
        deletedAt: deletedAt,
      );

      expect(note.folderId, isNull);
      expect(note.deletedAt, deletedAt);
      expect(note.isUnfiled, isTrue);
      expect(note.isTrashed, isTrue);
    });

    test('folderId non-null and deletedAt null: filed and active', () {
      final Note note = Note(
        id: 'note-4',
        title: 'Title',
        body: 'Body',
        folderId: 'folder-1',
        createdAt: createdAt,
        updatedAt: updatedAt,
        deletedAt: null,
      );

      expect(note.folderId, 'folder-1');
      expect(note.deletedAt, isNull);
      expect(note.isUnfiled, isFalse);
      expect(note.isTrashed, isFalse);
    });

    test('folderId null and deletedAt null: unfiled and active', () {
      final Note note = Note(
        id: 'note-5',
        title: 'Title',
        body: 'Body',
        folderId: null,
        createdAt: createdAt,
        updatedAt: updatedAt,
        deletedAt: null,
      );

      expect(note.isUnfiled, isTrue);
      expect(note.isTrashed, isFalse);
    });

    test('folderId non-null and deletedAt non-null: filed and trashed', () {
      final DateTime deletedAt = DateTime(2026, 1, 3);
      final Note note = Note(
        id: 'note-6',
        title: 'Title',
        body: 'Body',
        folderId: 'folder-1',
        createdAt: createdAt,
        updatedAt: updatedAt,
        deletedAt: deletedAt,
      );

      expect(note.isUnfiled, isFalse);
      expect(note.isTrashed, isTrue);
    });

    test('equality and copyWith are value-based (freezed)', () {
      final Note original = Note(
        id: 'note-7',
        title: 'Title',
        body: 'Body',
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
      final Note sameValues = Note(
        id: 'note-7',
        title: 'Title',
        body: 'Body',
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
      final Note copied = original.copyWith(title: 'New Title');

      expect(original, sameValues);
      expect(copied.title, 'New Title');
      expect(copied.id, original.id);
    });
  });
}
