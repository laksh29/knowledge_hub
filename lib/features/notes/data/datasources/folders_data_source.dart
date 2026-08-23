import 'package:knowledge_hub/features/notes/data/models/folder_model.dart';

/// Abstract contract the folders data-access layer must satisfy. Narrower and
/// lower-level than `FoldersRepository`: it speaks in `FolderModel`s, not
/// domain `Folder` entities, and it throws
/// (`CacheException`/`DuplicateNameException`) rather than returning
/// `Result`.
///
/// A single contract shared by every storage-engine-specific implementation
/// (today: `FoldersLocalDataSourceImpl`; in v1.1, a
/// `FoldersNetworkDataSourceImpl` could implement the same contract), per the
/// guide's §6.2 pattern.
abstract class FoldersDataSource {
  /// Throws `DuplicateNameException` when `name` already belongs to an
  /// existing folder (the `folders.name` UNIQUE constraint).
  Future<FolderModel> createFolder(String name);

  Stream<List<FolderModel>> watchFolders();

  Future<void> deleteFolder(String folderId);
}
