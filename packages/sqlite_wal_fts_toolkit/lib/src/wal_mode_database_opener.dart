import 'package:drift/drift.dart';

/// Opens a WAL-mode SQLite database backed by the file named [fileName].
///
/// **USER-IMPLEMENT stub — design note, not a working implementation.**
///
/// Per `notes-mvp`'s `research.md`, `sqlite3_flutter_libs` is a no-op as of
/// v0.6.0; current setups open a `package:sqlite3` database directly (or via
/// drift's `drift_flutter` setup helper) and enable WAL mode with
/// `PRAGMA journal_mode=WAL` immediately after opening, before wrapping it in
/// a [QueryExecutor] and returning it. Things worth deciding when you
/// implement this:
/// - `NativeDatabase` (drift) directly vs. the `drift_flutter` helper, which
///   handles platform-specific native-library loading for you.
/// - Read back `PRAGMA journal_mode` after setting it to confirm WAL mode
///   actually took effect, rather than assuming the PRAGMA succeeded
///   silently — some SQLite configurations (e.g. certain in-memory modes)
///   silently ignore WAL and stay on the default journal mode.
/// - Whether `fileName` should be resolved relative to the platform's
///   application-documents directory here, or whether that's the caller's
///   (`notes_database.dart`'s) responsibility — this toolkit should probably
///   stay agnostic to platform path resolution and take a ready-to-use path.
Future<QueryExecutor> openWalModeSqliteDatabase({required String fileName}) {
  throw UnimplementedError(
    'openWalModeSqliteDatabase is a USER-IMPLEMENT stub — see notes-mvp '
    'tasks.md task 1.3 and research.md for the WAL-mode setup rationale.',
  );
}
