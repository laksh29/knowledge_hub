import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

/// Opens a WAL-mode SQLite database backed by the file named [fileName].
///
/// Uses drift's `NativeDatabase` directly (not the `drift_flutter` setup
/// helper) since this package is intentionally pure-Dart with zero Flutter
/// dependency — `drift_flutter` depends on Flutter/`path_provider`, which
/// would break the "copy verbatim into any Dart project" guarantee this
/// toolkit is meant to provide. WAL mode is enabled via a `setup` callback
/// that runs `PRAGMA journal_mode = WAL;` on the raw `sqlite3.Database`
/// before drift's first query — verified by the accompanying test, which
/// reads `PRAGMA journal_mode` back rather than assuming the pragma
/// succeeded silently.
///
/// [fileName] must already be a fully-resolved, ready-to-use path — this
/// toolkit stays agnostic to platform path resolution (e.g. an app's
/// documents directory via `path_provider`) on purpose; that resolution is
/// the caller's responsibility (in this project, `notes_database.dart`).
Future<QueryExecutor> openWalModeSqliteDatabase({required String fileName}) async {
  return LazyDatabase(() async {
    final File file = File(fileName);

    return NativeDatabase(
      file,
      setup: (database) {
        database.execute('PRAGMA foreign_keys = ON;');
        database.execute('PRAGMA journal_mode = WAL;');
      },
    );
  });
}
