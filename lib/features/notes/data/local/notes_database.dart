import 'package:drift/drift.dart';
import 'package:sqlite_wal_fts_toolkit/sqlite_wal_fts_toolkit.dart';

part 'notes_database.g.dart';

class Notes extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  TextColumn get folderId => text().nullable().references(Folders, #id, onDelete: KeyAction.setNull)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Folders extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().unique()();

  @override
  Set<Column> get primaryKey => {id};
}

class Tags extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().unique()();

  @override
  Set<Column> get primaryKey => {id};
}

class NoteTags extends Table {
  TextColumn get noteId => text().references(Notes, #id, onDelete: KeyAction.cascade)();
  TextColumn get tagId => text().references(Tags, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {noteId, tagId};
}

@DriftDatabase(tables: [Notes, Folders, Tags, NoteTags])
class NotesDatabase extends _$NotesDatabase {
  NotesDatabase(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      await customStatement("PRAGMA foreign_keys = ON;");
    },

    onCreate: (Migrator m) async {
      await m.createAll();

      await customStatement(
        buildFts5ExternalContentTableSql(
          virtualTableName: "notes_fts",
          contentTableName: "notes",
          indexedColumns: ["title", "body"],
        ),
      );

      await customStatement(
        buildFts5SyncTriggerSql(
          virtualTableName: "notes_fts",
          contentTableName: "notes",
          indexedColumns: ["title", "body"],
        ),
      );

      await Future.wait([
        customStatement('CREATE INDEX idx_notes_folder_id ON notes(folder_id);'),
        customStatement('CREATE INDEX idx_notes_deleted_at ON notes(deleted_at);'),
        customStatement('CREATE INDEX idx_notes_updated_at ON notes(updated_at);'),
      ]);
    },
  );
}
