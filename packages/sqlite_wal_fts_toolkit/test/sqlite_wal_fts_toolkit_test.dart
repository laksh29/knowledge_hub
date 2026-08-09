import 'dart:io';

import 'package:drift/drift.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite3;
import 'package:sqlite_wal_fts_toolkit/sqlite_wal_fts_toolkit.dart';
import 'package:test/test.dart';

class _TestExecutorUser implements QueryExecutorUser {
  @override
  int get schemaVersion => 1;

  @override
  Future<void> beforeOpen(QueryExecutor executor, OpeningDetails details) async {}
}

void main() {
  test('package resolves and the barrel library is importable', () {
    expect(true, isTrue);
  });

  // USER-IMPLEMENT (notes-mvp task 1.3): these express the intended
  // behavior of the real implementation and currently fail (RED) because
  // openWalModeSqliteDatabase / buildFts5ExternalContentTableSql /
  // buildFts5SyncTriggerSql throw UnimplementedError.
  group('openWalModeSqliteDatabase (USER-IMPLEMENT)', () {
    test('opens a database with WAL journal mode active', () async {
      const String fileName = 'sqlite_wal_fts_toolkit_test_wal_mode.sqlite';
      addTearDown(() {
        final File file = File(fileName);
        if (file.existsSync()) file.deleteSync();
        // WAL mode also leaves a "-shm"/"-wal" sidecar file next to the
        // main database file until it's cleanly closed with no pending
        // writes; clean those up too so nothing lingers between runs.
        for (final String suffix in const ['-shm', '-wal']) {
          final File sidecar = File('$fileName$suffix');
          if (sidecar.existsSync()) sidecar.deleteSync();
        }
      });

      final QueryExecutor executor = await openWalModeSqliteDatabase(
        fileName: fileName,
      );
      await executor.ensureOpen(_TestExecutorUser());

      final List<Map<String, Object?>> result = await executor.runSelect(
        'PRAGMA journal_mode;',
        const [],
      );

      expect(result.single.values.single.toString().toLowerCase(), 'wal');
      await executor.close();
    });
  });

  group('buildFts5ExternalContentTableSql (USER-IMPLEMENT)', () {
    test('generates an external-content virtual table statement', () {
      final String sql = buildFts5ExternalContentTableSql(
        virtualTableName: 'items_fts',
        contentTableName: 'items',
        indexedColumns: const ['title', 'body'],
      );

      expect(sql, contains('CREATE VIRTUAL TABLE'));
      expect(sql, contains('items_fts'));
      expect(sql, contains('fts5'));
      expect(sql, contains('title'));
      expect(sql, contains('body'));
      expect(sql, contains("content='items'"));
    });
  });

  group('buildFts5SyncTriggerSql (USER-IMPLEMENT)', () {
    test('generates insert/update/delete triggers keeping the fts table in sync', () {
      final String sql = buildFts5SyncTriggerSql(
        virtualTableName: 'items_fts',
        contentTableName: 'items',
        indexedColumns: const ['title', 'body'],
      );

      expect(sql, contains('CREATE TRIGGER'));
      expect(sql, contains('AFTER INSERT'));
      expect(sql, contains('AFTER UPDATE'));
      expect(sql, contains('AFTER DELETE'));
    });
  });

  group('FTS5 round-trip (USER-IMPLEMENT)', () {
    test(
      'insert, update, and delete on the content table keep the FTS5 index in sync',
      () {
        // A TEXT primary key deliberately matches design.md's hidden-rowid-mapping
        // risk scenario (notes.id is a UUID string, not an INTEGER) -- this is the
        // exact case where content_rowid='rowid' must rely on SQLite's implicit
        // hidden rowid rather than the declared primary key.
        final sqlite3.Database db = sqlite3.sqlite3.openInMemory();
        addTearDown(db.close);

        db.execute('''
          CREATE TABLE items (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            body TEXT NOT NULL
          );
        ''');

        db.execute(
          buildFts5ExternalContentTableSql(
            virtualTableName: 'items_fts',
            contentTableName: 'items',
            indexedColumns: const ['title', 'body'],
          ),
        );

        db.execute(
          buildFts5SyncTriggerSql(
            virtualTableName: 'items_fts',
            contentTableName: 'items',
            indexedColumns: const ['title', 'body'],
          ),
        );

        // Insert -> the new row must be found by a search on its own text.
        db.execute('''
          INSERT INTO items (id, title, body)
          VALUES ('item-1', 'Grocery list', 'Buy milk and eggs');
        ''');
        expect(
          db.select("SELECT rowid FROM items_fts WHERE items_fts MATCH 'milk';"),
          hasLength(1),
          reason: 'insert trigger should have indexed the new row',
        );

        // Update -> the old term must disappear and the new term must be found.
        db.execute('''
          UPDATE items SET body = 'Buy bread and cheese' WHERE id = 'item-1';
        ''');
        expect(
          db.select("SELECT rowid FROM items_fts WHERE items_fts MATCH 'milk';"),
          isEmpty,
          reason: 'update trigger should have removed the old indexed text',
        );
        expect(
          db.select("SELECT rowid FROM items_fts WHERE items_fts MATCH 'bread';"),
          hasLength(1),
          reason: 'update trigger should have indexed the new text',
        );

        // Delete -> the row must no longer be found by any search.
        db.execute("DELETE FROM items WHERE id = 'item-1';");
        expect(
          db.select("SELECT rowid FROM items_fts WHERE items_fts MATCH 'bread';"),
          isEmpty,
          reason: 'delete trigger should have removed the row from the index',
        );
      },
    );
  });
}
