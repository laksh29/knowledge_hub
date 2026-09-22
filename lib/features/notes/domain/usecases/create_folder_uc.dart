import 'package:injectable/injectable.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/core/usecase/usecase.dart';
import 'package:knowledge_hub/features/notes/domain/entities/folder.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/folders_repository.dart';

@LazySingleton()
class CreateFolderUc implements UseCase<Folder, String> {
  const CreateFolderUc(this._foldersRepository);
  final FoldersRepository _foldersRepository;

  @override
  Future<Result<Failure, Folder>> call(String name) =>
      _foldersRepository.createFolder(name);
}
