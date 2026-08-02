/// Generic WAL-mode SQLite database opener and FTS5 virtual-table/trigger
/// SQL builders, parameterized only by file/table/column names.
///
/// This package has zero dependency on any consuming application's domain
/// types. The functions below are USER-IMPLEMENT stubs (signature + design
/// note + failing test only) per notes-mvp tasks.md task 1.3 — the real
/// logic is intentionally left for hands-on implementation.
library;

export 'src/fts5_virtual_table_builder.dart';
export 'src/wal_mode_database_opener.dart';
