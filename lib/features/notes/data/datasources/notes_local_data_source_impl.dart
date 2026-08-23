import 'package:drift/drift.dart';
import 'package:knowledge_hub/core/error/exception.dart';
import 'package:knowledge_hub/features/notes/data/datasources/notes_data_source.dart';
import 'package:knowledge_hub/features/notes/data/local/notes_database.dart';
import 'package:knowledge_hub/features/notes/data/models/note_model.dart';
import 'package:knowledge_hub/features/notes/data/models/note_search_result_model.dart';

/// Drift-backed implementation of [NotesDataSource]. Named "Local" (not
/// "Drift") per the guide's §6.2 convention so a future
/// `NotesNetworkDataSourceImpl` (v1.1, Supabase-backed) can implement the
/// same contract without this class being renamed.
class NotesLocalDataSourceImpl implements NotesDataSource {
  const NotesLocalDataSourceImpl(this._database);

  final NotesDatabase _database;

  @override
  Future<NoteModel> createNote(NoteModel note) async {
    try {
      await _database.into(_database.notes).insert(note.toCompanion());
      return note;
    } on Exception catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<NoteModel> saveNoteContent({
    required String noteId,
    required String title,
    required String body,
    required DateTime updatedAt,
  }) async {
    try {
      await (_database.update(_database.notes)..where((n) => n.id.equals(noteId))).write(
        NotesCompanion(title: Value(title), body: Value(body), updatedAt: Value(updatedAt)),
      );
      final Note row = await _selectNoteById(noteId);
      return NoteModel.fromDriftRow(row);
    } on CacheException {
      rethrow;
    } on Exception catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Stream<List<NoteModel>> watchNotes({String? folderId, required bool activeOnly}) {
    final query = _database.select(_database.notes)
      ..where((n) => activeOnly ? n.deletedAt.isNull() : n.deletedAt.isNotNull());
    if (folderId != null) {
      query.where((n) => n.folderId.equals(folderId));
    }
    return query.watch().map((rows) => rows.map(NoteModel.fromDriftRow).toList());
  }

  @override
  Future<void> setNoteTags({required String noteId, required List<String> tagIds}) async {
    try {
      await _database.transaction(() async {
        await (_database.delete(_database.noteTags)..where((nt) => nt.noteId.equals(noteId))).go();
        for (final String tagId in tagIds) {
          await _database
              .into(_database.noteTags)
              .insert(NoteTagsCompanion.insert(noteId: noteId, tagId: tagId));
        }
      });
    } on Exception catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<List<String>> getNoteTagIds(String noteId) async {
    try {
      final List<NoteTag> rows = await (_database.select(
        _database.noteTags,
      )..where((nt) => nt.noteId.equals(noteId))).get();
      return rows.map((NoteTag row) => row.tagId).toList();
    } on Exception catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> moveNoteToTrash(String noteId) async {
    try {
      await (_database.update(_database.notes)..where((n) => n.id.equals(noteId))).write(
        NotesCompanion(deletedAt: Value(DateTime.now())),
      );
    } on Exception catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> restoreNoteFromTrash(String noteId) async {
    try {
      await (_database.update(_database.notes)..where((n) => n.id.equals(noteId))).write(
        const NotesCompanion(deletedAt: Value(null)),
      );
    } on Exception catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<void> permanentlyDeleteNote(String noteId) async {
    try {
      await (_database.delete(_database.notes)..where((n) => n.id.equals(noteId))).go();
    } on Exception catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<int> purgeExpiredTrash(DateTime olderThan) async {
    try {
      return await (_database.delete(
        _database.notes,
      )..where((n) => n.deletedAt.isSmallerThanValue(olderThan))).go();
    } on Exception catch (e) {
      throw CacheException(e.toString());
    }
  }

  /// USER-IMPLEMENT stub — design note, not a working implementation.
  ///
  /// Needs a Drift custom-select against `notes_fts` using `bm25()` for
  /// ranking and `highlight()` for the two snippet strings, joined back to
  /// `notes` for the full row, watched as a Stream so results update live.
  /// See `packages/sqlite_wal_fts_toolkit`'s own tests (task 1.3) for the
  /// `MATCH`/`highlight()` query shape this needs to build on.
  @override
  Stream<List<NoteSearchResultModel>> watchSearchResults(String query) {
    throw UnimplementedError(
      'NotesLocalDataSourceImpl.watchSearchResults is a USER-IMPLEMENT stub '
      '— see notes-mvp tasks.md task 2.6.',
    );
  }

  Future<Note> _selectNoteById(String noteId) async {
    final Note? row = await (_database.select(
      _database.notes,
    )..where((n) => n.id.equals(noteId))).getSingleOrNull();
    if (row == null) {
      throw CacheException('Note $noteId not found');
    }
    return row;
  }
}
