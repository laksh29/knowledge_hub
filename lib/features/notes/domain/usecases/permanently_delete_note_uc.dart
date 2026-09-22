import 'package:injectable/injectable.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/core/usecase/usecase.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/notes_repository.dart';

@LazySingleton()
class PermanentlyDeleteNoteUc implements UseCase<void, String> {
  const PermanentlyDeleteNoteUc(this._notesRepository);
  final NotesRepository _notesRepository;

  @override
  Future<Result<Failure, void>> call(String noteId) =>
      _notesRepository.permanentlyDeleteNote(noteId);
}
