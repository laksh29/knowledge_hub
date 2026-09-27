import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/features/notes/data/local/notes_database.dart';

// USER-IMPLEMENT (notes-mvp task 1.7): these express the intended behavior
// of the real schema and currently fail — either to compile (the Notes/
// Folders/Tags/NoteTags companions don't yet have the columns these tests
// reference) or at runtime (NotesDatabase.migration throws
// UnimplementedError) — because the real implementation doesn't exist yet.
void main() {
  late NotesDatabase database;

  setUp(() {
    database = NotesDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  test('creates the full notes schema and the note round-trips unchanged', () async {
    await database.into(database.folders).insert(
      FoldersCompanion.insert(id: 'folder-1', name: 'Work'),
    );

    await database.into(database.notes).insert(
      NotesCompanion.insert(
        id: 'note-1',
        title: 'Grocery list',
        body: 'Buy milk and eggs',
        folderId: const Value('folder-1'),
        createdAt: DateTime.utc(2026, 1, 1),
        updatedAt: DateTime.utc(2026, 1, 1),
      ),
    );

    final Note note = await (database.select(
      database.notes,
    )..where((n) => n.id.equals('note-1'))).getSingle();

    expect(note.title, 'Grocery list');
    expect(note.body, 'Buy milk and eggs');
    expect(note.folderId, 'folder-1');
    expect(note.deletedAt, isNull, reason: 'a freshly created note is active, not trashed');
  });

  test('a note can be created with no folder assignment (unfiled)', () async {
    await database.into(database.notes).insert(
      NotesCompanion.insert(
        id: 'note-2',
        title: 'Independent note',
        body: 'Not in any folder',
        createdAt: DateTime.utc(2026, 1, 1),
        updatedAt: DateTime.utc(2026, 1, 1),
      ),
    );

    final Note note = await (database.select(
      database.notes,
    )..where((n) => n.id.equals('note-2'))).getSingle();

    expect(note.folderId, isNull);
  });

  test('deleting a folder unfiles its notes rather than deleting them', () async {
    await database.into(database.folders).insert(
      FoldersCompanion.insert(id: 'folder-1', name: 'Work'),
    );
    await database.into(database.notes).insert(
      NotesCompanion.insert(
        id: 'note-1',
        title: 'Grocery list',
        body: 'Buy milk and eggs',
        folderId: const Value('folder-1'),
        createdAt: DateTime.utc(2026, 1, 1),
        updatedAt: DateTime.utc(2026, 1, 1),
      ),
    );

    await (database.delete(
      database.folders,
    )..where((f) => f.id.equals('folder-1'))).go();

    final Note note = await (database.select(
      database.notes,
    )..where((n) => n.id.equals('note-1'))).getSingle();

    expect(note.folderId, isNull, reason: 'the note must survive, unfiled — not be deleted');
  });

  test('deleting a tag removes only its note association, never the note', () async {
    await database.into(database.notes).insert(
      NotesCompanion.insert(
        id: 'note-1',
        title: 'Grocery list',
        body: 'Buy milk and eggs',
        createdAt: DateTime.utc(2026, 1, 1),
        updatedAt: DateTime.utc(2026, 1, 1),
      ),
    );
    await database.into(database.tags).insert(TagsCompanion.insert(id: 'tag-1', name: 'errands'));
    await database.into(database.noteTags).insert(
      NoteTagsCompanion.insert(noteId: 'note-1', tagId: 'tag-1'),
    );

    await (database.delete(database.tags)..where((t) => t.id.equals('tag-1'))).go();

    final int remainingAssociations = await database
        .select(database.noteTags)
        .get()
        .then((rows) => rows.length);
    final Note note = await (database.select(
      database.notes,
    )..where((n) => n.id.equals('note-1'))).getSingle();

    expect(remainingAssociations, 0, reason: 'the tag association must be gone');
    expect(note.title, 'Grocery list', reason: 'the note itself must survive untouched');
  });

  test('the notes_fts index finds a note by a word in its body', () async {
    await database.into(database.notes).insert(
      NotesCompanion.insert(
        id: 'note-1',
        title: 'Grocery list',
        body: 'Buy milk and eggs',
        createdAt: DateTime.utc(2026, 1, 1),
        updatedAt: DateTime.utc(2026, 1, 1),
      ),
    );

    final List<Map<String, Object?>> results = await database.customSelect(
      "SELECT rowid FROM notes_fts WHERE notes_fts MATCH 'milk';",
    ).get().then((rows) => rows.map((row) => row.data).toList());

    expect(results, hasLength(1), reason: 'the FTS5 index must stay in sync after insert');
  });
}
