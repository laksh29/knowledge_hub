/// Generates a `CREATE VIRTUAL TABLE ... USING fts5(...)` statement for an
/// external-content full-text-search table over [contentTableName]'s
/// [indexedColumns].
///
/// An external-content table avoids duplicating [contentTableName]'s text
/// inside the FTS5 index (see sqlite.org/fts5.html). `content_rowid='rowid'`
/// is always the literal SQLite hidden rowid — this is what lets a content
/// table with a non-INTEGER declared primary key (e.g. a TEXT UUID) still
/// work correctly, verified by this package's FTS5 round-trip test.
///
/// Not yet implemented: an optional `detail` mode parameter
/// (`full`/`column`/`none`) for the storage-size-vs-snippet-precision
/// tradeoff noted in `research.md` — full detail is ~45% of source text
/// size, `none` is ~8%, but `none` limits what `snippet()`/`highlight()`
/// can do. Defaults to FTS5's own default (`full`) for now.
String buildFts5ExternalContentTableSql({
  required String virtualTableName,
  required String contentTableName,
  required List<String> indexedColumns,
}) {
  assert(indexedColumns.isNotEmpty, "indexedColumns cannot be empty");
  assert(virtualTableName.isNotEmpty && contentTableName.isNotEmpty, "virtualTableName or contentTableName cannot be empty");

  final String columns = indexedColumns.join(", ");

  return '''
CREATE VIRTUAL TABLE $virtualTableName USING fts5(
  $columns,
  content='$contentTableName',
  content_rowid='rowid'
);
''';
}

/// Generates the `AFTER INSERT`/`AFTER UPDATE`/`AFTER DELETE` trigger SQL on
/// [contentTableName] that keeps the [virtualTableName] external-content FTS5
/// table synchronized with [indexedColumns].
///
/// Per SQLite's documented external-content-table pattern, three triggers are
/// typically needed: insert mirrors the new row into the FTS5 table; delete
/// removes it; update is usually implemented as a delete-then-insert pair
/// against the FTS5 table (not a plain SQL `UPDATE`) because FTS5's index
/// structure doesn't support in-place text updates efficiently.
String buildFts5SyncTriggerSql({
  required String virtualTableName,
  required String contentTableName,
  required List<String> indexedColumns,
}) {
  assert(indexedColumns.isNotEmpty, "indexedColumns cannot be empty");
  assert(virtualTableName.isNotEmpty && contentTableName.isNotEmpty, "virtualTableName or contentTableName cannot be empty");

  final String columns = indexedColumns.join(", ");
  final String newColumns = indexedColumns.map((c) => "new.$c").join(", ");
  final String oldColumns = indexedColumns.map((c) => "old.$c").join(", ");

  final String insertTrigger =
      '''
CREATE TRIGGER ${contentTableName}_ai AFTER INSERT ON $contentTableName BEGIN
  INSERT INTO $virtualTableName(rowid, $columns) VALUES (new.rowId, $newColumns);
END;
''';

  final String deleteTrigger =
      '''
CREATE TRIGGER ${contentTableName}_ad AFTER DELETE ON $contentTableName BEGIN
  INSERT INTO $virtualTableName($virtualTableName, rowid, $columns) VALUES('delete', old.rowid, $oldColumns);
END;
''';

  final String updateTrigger =
      '''
CREATE TRIGGER ${contentTableName}_au AFTER UPDATE ON $contentTableName BEGIN
  INSERT INTO $virtualTableName($virtualTableName, rowid, $columns) VALUES('delete', old.rowid, $oldColumns);
  INSERT INTO $virtualTableName(rowid, $columns) VALUES (new.rowid, $newColumns);
END;
''';
  return insertTrigger + deleteTrigger + updateTrigger;
}
