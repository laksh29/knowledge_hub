import 'package:drift/drift.dart';

part 'notes_database.g.dart';

/// **USER-IMPLEMENT stub — design note, not a working schema.**
///
/// Full physical schema (per `.kiro/specs/notes-mvp/design.md`'s Physical
/// Data Model — copy these column lists in verbatim, they are already
/// decided, not open design questions):
///
/// - `notes`: `id` TEXT PRIMARY KEY, `title` TEXT, `body` TEXT,
///   `folder_id` TEXT NULL REFERENCES folders(id) ON DELETE SET NULL,
///   `created_at` DATETIME, `updated_at` DATETIME, `deleted_at` DATETIME NULL.
///   `folder_id` being nullable is what lets a note be "unfiled" (Requirement
///   4.2) — this is NOT the same nullable field as `deleted_at` (trash
///   state); the two are fully independent, never encode each other (see
///   design.md's Data Models section).
/// - `folders`: `id` TEXT PRIMARY KEY, `name` TEXT UNIQUE.
/// - `tags`: `id` TEXT PRIMARY KEY, `name` TEXT UNIQUE.
/// - `note_tags`: `note_id` TEXT REFERENCES notes(id) ON DELETE CASCADE,
///   `tag_id` TEXT REFERENCES tags(id) ON DELETE CASCADE,
///   PRIMARY KEY (note_id, tag_id).
///
/// In Drift, a foreign key with `ON DELETE SET NULL`/`ON DELETE CASCADE` is
/// expressed via a column's `.references(OtherTable, #otherColumn,
/// onDelete: KeyAction.setNull / KeyAction.cascade)` — not a bare
/// `.customConstraint(...)` string (though that works too; either is
/// acceptable as long as the ON DELETE behavior is real, not just
/// documented in a comment). A composite primary key (`note_tags`) is
/// expressed by overriding `@override Set<Column> get primaryKey => {...};`
/// on the table class, not a `.text()()` column.
///
/// Only the `id` column of each table is stubbed below (the minimum for
/// Drift codegen to succeed) — add the rest per the schema above.
class Notes extends Table {
  TextColumn get id => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class Folders extends Table {
  TextColumn get id => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class Tags extends Table {
  TextColumn get id => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class NoteTags extends Table {
  TextColumn get noteId => text()();

  @override
  Set<Column> get primaryKey => {noteId};
}

/// **USER-IMPLEMENT stub — design note, not a working database.**
///
/// `migration` needs to:
/// 1. Run the normal `createAll()` step (creates the four tables above).
/// 2. Build and execute the `notes_fts` external-content virtual-table SQL
///    via `packages/sqlite_wal_fts_toolkit`'s
///    `buildFts5ExternalContentTableSql(virtualTableName: 'notes_fts',
///    contentTableName: 'notes', indexedColumns: ['title', 'body'])`,
///    executed with `customStatement(...)`.
/// 3. Build and execute the sync-trigger SQL via the same package's
///    `buildFts5SyncTriggerSql(...)` with the same parameters.
///
/// The `NotesDatabase` constructor should be given a [QueryExecutor] opened
/// via that same package's `openWalModeSqliteDatabase(fileName: ...)` — this
/// class does not open its own file; the caller (or a later DI-wiring task)
/// supplies the executor, keeping this class testable against an in-memory
/// executor too.
@DriftDatabase(tables: [Notes, Folders, Tags, NoteTags])
class NotesDatabase extends _$NotesDatabase {
  NotesDatabase(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => throw UnimplementedError(
    'NotesDatabase.migration is a USER-IMPLEMENT stub — see notes-mvp '
    'tasks.md task 1.7. It must create all four tables plus the notes_fts '
    'virtual table and its sync triggers, using '
    "packages/sqlite_wal_fts_toolkit's SQL builders.",
  );
}
