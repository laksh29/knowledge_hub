import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/core/usecase/usecase.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/folders_repository.dart';

class DeleteFolderUc implements UseCase<void, String> {
  const DeleteFolderUc(this._foldersRepository);
  final FoldersRepository _foldersRepository;

  @override
  Future<Result<Failure, void>> call(String folderId) =>
      _foldersRepository.deleteFolder(folderId);
}
