/// Generates a `CREATE VIRTUAL TABLE ... USING fts5(...)` statement for an
/// external-content full-text-search table over [contentTableName]'s
/// [indexedColumns].
///
/// **USER-IMPLEMENT stub — design note, not a working implementation.**
///
/// An external-content table avoids duplicating [contentTableName]'s text
/// inside the FTS5 index (see sqlite.org/fts5.html). Things worth deciding:
/// - `content_rowid='rowid'` mapping when [contentTableName]'s declared
///   primary key is not an INTEGER — SQLite still maintains a hidden rowid
///   in that case, but this must be verified with a round-trip test, not
///   assumed (see `research.md`'s "SQLite rowid mapping" risk).
/// - Whether to expose a `detail` mode parameter (`full`/`column`/`none`)
///   for the storage-size-vs-snippet-precision tradeoff noted in
///   `research.md` — full detail is ~45% of source text size, `none` is
///   ~8%, but `none` limits what `snippet()`/`highlight()` can do.
String buildFts5ExternalContentTableSql({
  required String virtualTableName,
  required String contentTableName,
  required List<String> indexedColumns,
}) {
  throw UnimplementedError(
    'buildFts5ExternalContentTableSql is a USER-IMPLEMENT stub — see '
    'notes-mvp tasks.md task 1.3.',
  );
}

/// Generates the `AFTER INSERT`/`AFTER UPDATE`/`AFTER DELETE` trigger SQL on
/// [contentTableName] that keeps the [virtualTableName] external-content FTS5
/// table synchronized with [indexedColumns].
///
/// **USER-IMPLEMENT stub — design note, not a working implementation.**
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
  throw UnimplementedError(
    'buildFts5SyncTriggerSql is a USER-IMPLEMENT stub — see notes-mvp '
    'tasks.md task 1.3.',
  );
}
