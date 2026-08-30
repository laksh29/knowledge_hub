import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/core/usecase/usecase.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/notes_repository.dart';

class SaveNoteContentUc implements UseCase<Note, SaveNoteContentParams> {
  const SaveNoteContentUc(this._notesRepository);
  final NotesRepository _notesRepository;

  @override
  Future<Result<Failure, Note>> call(SaveNoteContentParams params) =>
      _notesRepository.saveNoteContent(params);
}
