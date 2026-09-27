import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/domain/entities/folder.dart';

abstract class FoldersRepository {
  Future<Result<Failure, Folder>> createFolder(String name);
  Stream<Result<Failure, List<Folder>>> watchFolders();
  Future<Result<Failure, void>> deleteFolder(String folderId);
}
