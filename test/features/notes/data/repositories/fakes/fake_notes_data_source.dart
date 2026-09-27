import 'package:knowledge_hub/features/notes/data/datasources/notes_data_source.dart';
import 'package:knowledge_hub/features/notes/data/models/note_model.dart';
import 'package:knowledge_hub/features/notes/data/models/note_search_result_model.dart';

/// A trivial in-memory [NotesDataSource], used to unit-test
/// [NotesRepositoryImpl]'s USER-IMPLEMENT logic in isolation from real
/// SQLite — the same Fake-per-contract pattern already used for the
/// domain-level repository contracts (task 2.2).
class FakeNotesDataSource implements NotesDataSource {
  final Map<String, NoteModel> _notesById = <String, NoteModel>{};
  final Map<String, List<String>> _tagIdsByNoteId = <String, List<String>>{};

  void seed(NoteModel note, {List<String> tagIds = const <String>[]}) {
    _notesById[note.id] = note;
    _tagIdsByNoteId[note.id] = List<String>.from(tagIds);
  }

  NoteModel? peek(String noteId) => _notesById[noteId];

  @override
  Future<NoteModel> createNote(NoteModel note) async {
    _notesById[note.id] = note;
    _tagIdsByNoteId[note.id] = const <String>[];
    return note;
  }

  @override
  Future<NoteModel> saveNoteContent({
    required String noteId,
    required String title,
    required String body,
    required DateTime updatedAt,
  }) async {
    final NoteModel updated = _notesById[noteId]!.copyWith(
      title: title,
      body: body,
      updatedAt: updatedAt,
    );
    _notesById[noteId] = updated;
    return updated;
  }

  @override
  Stream<List<NoteModel>> watchNotes({String? folderId, required bool activeOnly}) {
    return Stream<List<NoteModel>>.value(
      _notesById.values
          .where((NoteModel n) => folderId == null || n.folderId == folderId)
          .where((NoteModel n) => activeOnly ? n.deletedAt == null : n.deletedAt != null)
          .toList(),
    );
  }

  @override
  Future<void> setNoteTags({required String noteId, required List<String> tagIds}) async {
    _tagIdsByNoteId[noteId] = List<String>.from(tagIds);
  }

  @override
  Future<List<String>> getNoteTagIds(String noteId) async {
    return List<String>.from(_tagIdsByNoteId[noteId] ?? const <String>[]);
  }

  @override
  Future<void> moveNoteToTrash(String noteId) async {
    _notesById[noteId] = _notesById[noteId]!.copyWith(deletedAt: DateTime.now());
  }

  @override
  Future<void> restoreNoteFromTrash(String noteId) async {
    final NoteModel current = _notesById[noteId]!;
    _notesById[noteId] = NoteModel(
      id: current.id,
      title: current.title,
      body: current.body,
      folderId: current.folderId,
      createdAt: current.createdAt,
      updatedAt: current.updatedAt,
    );
  }

  @override
  Future<void> permanentlyDeleteNote(String noteId) async {
    _notesById.remove(noteId);
    _tagIdsByNoteId.remove(noteId);
  }

  @override
  Future<int> purgeExpiredTrash(DateTime olderThan) async {
    final List<String> toRemove = _notesById.values
        .where((NoteModel n) => n.deletedAt != null && n.deletedAt!.isBefore(olderThan))
        .map((NoteModel n) => n.id)
        .toList();
    for (final String id in toRemove) {
      _notesById.remove(id);
      _tagIdsByNoteId.remove(id);
    }
    return toRemove.length;
  }

  @override
  Stream<List<NoteSearchResultModel>> watchSearchResults(String query) {
    return const Stream<List<NoteSearchResultModel>>.empty();
  }
}
