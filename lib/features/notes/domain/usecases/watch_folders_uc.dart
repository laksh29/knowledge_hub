import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/core/usecase/usecase.dart';
import 'package:knowledge_hub/features/notes/domain/entities/folder.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/folders_repository.dart';

class WatchFoldersUc implements StreamUseCaseNoParams<List<Folder>> {
  const WatchFoldersUc(this._foldersRepository);
  final FoldersRepository _foldersRepository;

  @override
  Stream<Result<Failure, List<Folder>>> call() =>
      _foldersRepository.watchFolders();
}
