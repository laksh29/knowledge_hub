import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/core/usecase/usecase.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/notes_repository.dart';

class RestoreNoteFromTrashUc implements UseCase<void, String> {
  const RestoreNoteFromTrashUc(this._notesRepository);
  final NotesRepository _notesRepository;

  @override
  Future<Result<Failure, void>> call(String noteId) =>
      _notesRepository.restoreNoteFromTrash(noteId);
}
