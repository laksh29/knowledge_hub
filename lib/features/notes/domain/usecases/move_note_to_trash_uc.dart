import 'package:injectable/injectable.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/core/usecase/usecase.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/notes_repository.dart';

@LazySingleton()
class MoveNoteToTrashUc implements UseCase<void, String> {
  const MoveNoteToTrashUc(this._notesRepository);
  final NotesRepository _notesRepository;

  @override
  Future<Result<Failure, void>> call(String noteId) =>
      _notesRepository.moveNoteToTrash(noteId);
}
