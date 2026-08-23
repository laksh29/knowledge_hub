import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/domain/entities/folder.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/folders_repository.dart';

class FakeFoldersRepository implements FoldersRepository {
  FakeFoldersRepository({required this.existingFolders});

  final List<Folder> existingFolders;

  @override
  Future<Result<Failure, Folder>> createFolder(String name) async {
    final bool nameAlreadyTaken = existingFolders.any(
      (Folder folder) => folder.name == name,
    );
    if (nameAlreadyTaken) {
      return Err<Failure, Folder>(
        DuplicateNameFailure('A folder named "$name" already exists'),
      );
    }
    return Ok<Failure, Folder>(Folder(id: 'folder-new', name: name));
  }

  @override
  Stream<Result<Failure, List<Folder>>> watchFolders() =>
      Stream<Result<Failure, List<Folder>>>.value(
        Ok<Failure, List<Folder>>(existingFolders),
      );

  @override
  Future<Result<Failure, void>> deleteFolder(String folderId) async =>
      const Ok<Failure, void>(null);
}
