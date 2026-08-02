import 'package:drift/drift.dart';
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
      final QueryExecutor executor = await openWalModeSqliteDatabase(
        fileName: 'sqlite_wal_fts_toolkit_test_wal_mode.sqlite',
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
}
