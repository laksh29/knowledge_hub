import 'package:knowledge_hub/features/notes/data/models/note_model.dart';

/// Abstract contract the notes data-access layer must satisfy. Narrower and
/// lower-level than `NotesRepository`: it speaks in `NoteModel`s and plain
/// tag-id lists, not domain `Note` entities, and it throws
/// (`CacheException`/`ServerException`) rather than returning `Result`.
///
/// A single contract shared by every storage-engine-specific implementation
/// (today: `NotesLocalDataSourceImpl`; in v1.1, a `NotesNetworkDataSourceImpl`
/// could implement the same contract), per the guide's §6.2 pattern.
abstract class NotesDataSource {
  Future<NoteModel> createNote(NoteModel note);

  Future<NoteModel> saveNoteContent({
    required String noteId,
    required String title,
    required String body,
    required DateTime updatedAt,
  });

  Stream<List<NoteModel>> watchNotes({String? folderId, required bool activeOnly});

  /// Replaces every tag association for [noteId] with exactly [tagIds].
  Future<void> setNoteTags({required String noteId, required List<String> tagIds});

  /// The tag ids currently associated with [noteId], via the join table.
  Future<List<String>> getNoteTagIds(String noteId);

  Future<void> moveNoteToTrash(String noteId);

  Future<void> restoreNoteFromTrash(String noteId);

  Future<void> permanentlyDeleteNote(String noteId);

  /// Permanently deletes every note whose `deletedAt` is strictly before
  /// [olderThan]. Returns the number of notes removed.
  Future<int> purgeExpiredTrash(DateTime olderThan);
}
