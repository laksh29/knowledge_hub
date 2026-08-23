import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/core/error/exception.dart';
import 'package:knowledge_hub/features/notes/data/datasources/notes_data_source.dart';
import 'package:knowledge_hub/features/notes/data/datasources/notes_local_data_source_impl.dart';
import 'package:knowledge_hub/features/notes/data/local/notes_database.dart';
import 'package:knowledge_hub/features/notes/data/models/note_model.dart';

void main() {
  late NotesDatabase database;
  late NotesDataSource dataSource;

  setUp(() {
    database = NotesDatabase(NativeDatabase.memory());
    dataSource = NotesLocalDataSourceImpl(database);
  });

  tearDown(() async {
    await database.close();
  });

  NoteModel buildNote({
    String id = 'note-1',
    String title = 'Grocery list',
    String body = 'Buy milk and eggs',
    String? folderId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    final DateTime timestamp = createdAt ?? DateTime.utc(2026, 1, 1);
    return NoteModel(
      id: id,
      title: title,
      body: body,
      folderId: folderId,
      createdAt: timestamp,
      updatedAt: updatedAt ?? timestamp,
    );
  }

  group('createNote / round-trip', () {
    test('a note round-trips through storage unchanged, including nullable fields', () async {
      final NoteModel created = await dataSource.createNote(
        buildNote(folderId: null, createdAt: DateTime.utc(2026, 1, 1), updatedAt: DateTime.utc(2026, 1, 1)),
      );

      final List<NoteModel> notes = await dataSource.watchNotes(activeOnly: true).first;
      final NoteModel stored = notes.single;

      expect(stored.id, created.id);
      expect(stored.title, 'Grocery list');
      expect(stored.body, 'Buy milk and eggs');
      expect(stored.folderId, isNull, reason: 'folderId is independent of the rest of the row');
      expect(stored.createdAt.toUtc(), DateTime.utc(2026, 1, 1));
      expect(stored.updatedAt.toUtc(), DateTime.utc(2026, 1, 1));
      expect(stored.deletedAt, isNull, reason: 'deletedAt is independent of folderId');
    });

    test('folderId and deletedAt round-trip independently when both are set', () async {
      await database.into(database.folders).insert(FoldersCompanion.insert(id: 'folder-1', name: 'Work'));
      await dataSource.createNote(buildNote(folderId: 'folder-1'));

      await dataSource.moveNoteToTrash('note-1');
      final List<NoteModel> trashed = await dataSource.watchNotes(activeOnly: false).first;
      final NoteModel stored = trashed.single;

      expect(stored.folderId, 'folder-1', reason: 'trashing must not disturb folder assignment');
      expect(stored.deletedAt, isNotNull);
    });
  });

  group('saveNoteContent', () {
    test('updates title, body, and updatedAt on an existing row', () async {
      await dataSource.createNote(buildNote(title: 'Old title', body: 'Old body'));
      final DateTime newUpdatedAt = DateTime.utc(2026, 2, 1);

      final NoteModel saved = await dataSource.saveNoteContent(
        noteId: 'note-1',
        title: 'New title',
        body: 'New body',
        updatedAt: newUpdatedAt,
      );

      expect(saved.title, 'New title');
      expect(saved.body, 'New body');
      expect(saved.updatedAt.toUtc(), newUpdatedAt.toUtc());

      final List<NoteModel> notes = await dataSource.watchNotes(activeOnly: true).first;
      expect(notes.single.title, 'New title');
    });

    test('throws CacheException (not StateError) when the target noteId does not exist', () async {
      expect(
        () => dataSource.saveNoteContent(
          noteId: 'does-not-exist',
          title: 'New title',
          body: 'New body',
          updatedAt: DateTime.utc(2026, 2, 1),
        ),
        throwsA(isA<CacheException>()),
      );
    });
  });

  group('tag associations', () {
    test('assigning 2+ tags and reading them back resolves an exact match', () async {
      await dataSource.createNote(buildNote());
      await database.into(database.tags).insert(TagsCompanion.insert(id: 'tag-1', name: 'errands'));
      await database.into(database.tags).insert(TagsCompanion.insert(id: 'tag-2', name: 'groceries'));

      await dataSource.setNoteTags(noteId: 'note-1', tagIds: const <String>['tag-1', 'tag-2']);
      final List<String> tagIds = await dataSource.getNoteTagIds('note-1');

      expect(tagIds.toSet(), <String>{'tag-1', 'tag-2'});
      expect(tagIds, hasLength(2));
    });

    test('setNoteTags replaces the prior association set rather than appending to it', () async {
      await dataSource.createNote(buildNote());
      await database.into(database.tags).insert(TagsCompanion.insert(id: 'tag-1', name: 'errands'));
      await database.into(database.tags).insert(TagsCompanion.insert(id: 'tag-2', name: 'groceries'));

      await dataSource.setNoteTags(noteId: 'note-1', tagIds: const <String>['tag-1']);
      await dataSource.setNoteTags(noteId: 'note-1', tagIds: const <String>['tag-2']);
      final List<String> tagIds = await dataSource.getNoteTagIds('note-1');

      expect(tagIds, <String>['tag-2']);
    });

    test('a note with zero tags resolves to an empty list, not an error', () async {
      await dataSource.createNote(buildNote());

      final List<String> tagIds = await dataSource.getNoteTagIds('note-1');

      expect(tagIds, isEmpty);
    });
  });

  group('watchNotes filtering', () {
    test('scopes by folderId when provided', () async {
      await database.into(database.folders).insert(FoldersCompanion.insert(id: 'folder-1', name: 'Work'));
      await dataSource.createNote(buildNote(id: 'note-1', folderId: 'folder-1'));
      await dataSource.createNote(buildNote(id: 'note-2', folderId: null));

      final List<NoteModel> filtered = await dataSource.watchNotes(folderId: 'folder-1', activeOnly: true).first;

      expect(filtered.map((NoteModel n) => n.id), <String>['note-1']);
    });

    test('activeOnly=false scopes to trashed notes only', () async {
      await dataSource.createNote(buildNote(id: 'note-1'));
      await dataSource.createNote(buildNote(id: 'note-2'));
      await dataSource.moveNoteToTrash('note-1');

      final List<NoteModel> active = await dataSource.watchNotes(activeOnly: true).first;
      final List<NoteModel> trashed = await dataSource.watchNotes(activeOnly: false).first;

      expect(active.map((NoteModel n) => n.id), <String>['note-2']);
      expect(trashed.map((NoteModel n) => n.id), <String>['note-1']);
    });
  });

  group('trash lifecycle', () {
    test('restoreNoteFromTrash clears deletedAt', () async {
      await dataSource.createNote(buildNote());
      await dataSource.moveNoteToTrash('note-1');

      await dataSource.restoreNoteFromTrash('note-1');
      final List<NoteModel> active = await dataSource.watchNotes(activeOnly: true).first;

      expect(active.single.deletedAt, isNull);
    });

    test('permanentlyDeleteNote removes the row entirely', () async {
      await dataSource.createNote(buildNote());

      await dataSource.permanentlyDeleteNote('note-1');
      final List<NoteModel> active = await dataSource.watchNotes(activeOnly: true).first;
      final List<NoteModel> trashed = await dataSource.watchNotes(activeOnly: false).first;

      expect(active, isEmpty);
      expect(trashed, isEmpty);
    });

    test('purgeExpiredTrash removes only notes trashed before the cutoff', () async {
      await dataSource.createNote(buildNote(id: 'note-old'));
      await dataSource.createNote(buildNote(id: 'note-new'));
      await (database.update(database.notes)..where((n) => n.id.equals('note-old'))).write(
        NotesCompanion(deletedAt: drift.Value(DateTime.utc(2026, 1, 1))),
      );
      await (database.update(database.notes)..where((n) => n.id.equals('note-new'))).write(
        NotesCompanion(deletedAt: drift.Value(DateTime.utc(2026, 8, 1))),
      );

      final int purgedCount = await dataSource.purgeExpiredTrash(DateTime.utc(2026, 2, 1));

      expect(purgedCount, 1);
      final List<NoteModel> remainingTrash = await dataSource.watchNotes(activeOnly: false).first;
      expect(remainingTrash.map((NoteModel n) => n.id), <String>['note-new']);
    });
  });
}
