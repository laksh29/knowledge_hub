import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note_list_filter.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note_search_result.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/notes_repository.dart';

class FakeNotesRepository implements NotesRepository {
  FakeNotesRepository({required this.note, required this.searchResult});

  final Note note;
  final NoteSearchResult searchResult;

  @override
  Future<Result<Failure, Note>> createNote() async => Ok<Failure, Note>(note);

  @override
  Future<Result<Failure, Note>> saveNoteContent(
    SaveNoteContentParams params,
  ) async => Ok<Failure, Note>(note);

  @override
  Stream<Result<Failure, List<Note>>> watchNotes(NoteListFilterParams filter) =>
      Stream<Result<Failure, List<Note>>>.value(
        Ok<Failure, List<Note>>(<Note>[note]),
      );

  @override
  Stream<Result<Failure, List<NoteSearchResult>>> watchSearchResults(
    String query,
  ) => Stream<Result<Failure, List<NoteSearchResult>>>.value(
    Ok<Failure, List<NoteSearchResult>>(<NoteSearchResult>[searchResult]),
  );

  @override
  Future<Result<Failure, void>> moveNoteToTrash(String noteId) async =>
      const Ok<Failure, void>(null);

  @override
  Future<Result<Failure, void>> restoreNoteFromTrash(String noteId) async =>
      const Ok<Failure, void>(null);

  @override
  Future<Result<Failure, void>> permanentlyDeleteNote(String noteId) async =>
      const Ok<Failure, void>(null);

  @override
  Future<Result<Failure, int>> purgeExpiredTrash() async =>
      const Ok<Failure, int>(0);
}
