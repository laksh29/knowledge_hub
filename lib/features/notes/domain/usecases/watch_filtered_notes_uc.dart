import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/core/usecase/usecase.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note_list_filter.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/notes_repository.dart';

class WatchFilteredNotesUc
    implements StreamUseCase<List<Note>, NoteListFilterParams> {
  const WatchFilteredNotesUc(this._notesRepository);
  final NotesRepository _notesRepository;

  @override
  Stream<Result<Failure, List<Note>>> call(NoteListFilterParams params) =>
      _notesRepository.watchNotes(params);
}
