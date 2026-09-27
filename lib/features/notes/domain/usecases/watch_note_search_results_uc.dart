import 'package:injectable/injectable.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/core/usecase/usecase.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note_search_result.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/notes_repository.dart';

@LazySingleton()
class WatchNoteSearchResultsUc
    implements StreamUseCase<List<NoteSearchResult>, String> {
  const WatchNoteSearchResultsUc(this._notesRepository);
  final NotesRepository _notesRepository;

  @override
  Stream<Result<Failure, List<NoteSearchResult>>> call(String query) =>
      _notesRepository.watchSearchResults(query);
}
