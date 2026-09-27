/// Generic WAL-mode SQLite database opener and FTS5 virtual-table/trigger
/// SQL builders, parameterized only by file/table/column names.
///
/// This package has zero dependency on any consuming application's domain
/// types or on Flutter — it's meant to be copied verbatim into any Dart
/// project that needs the same WAL-mode-and-FTS5 setup.
library;

export 'src/fts5_virtual_table_builder.dart';
export 'src/wal_mode_database_opener.dart';
