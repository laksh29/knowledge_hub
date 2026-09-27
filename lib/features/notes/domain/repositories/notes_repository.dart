import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note_list_filter.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note_search_result.dart';

part 'notes_repository.freezed.dart';

abstract class NotesRepository {
  Future<Result<Failure, Note>> createNote();
  Future<Result<Failure, Note>> saveNoteContent(SaveNoteContentParams params);
  Stream<Result<Failure, List<Note>>> watchNotes(NoteListFilterParams filter);
  Stream<Result<Failure, List<NoteSearchResult>>> watchSearchResults(
    String query,
  );
  Future<Result<Failure, void>> moveNoteToTrash(String noteId);
  Future<Result<Failure, void>> restoreNoteFromTrash(String noteId);
  Future<Result<Failure, void>> permanentlyDeleteNote(String noteId);
  Future<Result<Failure, int>> purgeExpiredTrash();
}

@freezed
abstract class SaveNoteContentParams with _$SaveNoteContentParams {
  const factory SaveNoteContentParams({
    required String noteId,
    required String title,
    required String body,
  }) = _SaveNoteContentParams;
}
