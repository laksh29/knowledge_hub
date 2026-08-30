import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/core/usecase/usecase.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/notes_repository.dart';

class PurgeExpiredTrashUc implements UseCaseNoParams<int> {
  const PurgeExpiredTrashUc(this._notesRepository);
  final NotesRepository _notesRepository;

  @override
  Future<Result<Failure, int>> call() => _notesRepository.purgeExpiredTrash();
}
