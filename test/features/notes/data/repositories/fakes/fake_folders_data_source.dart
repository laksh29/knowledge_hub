import 'package:knowledge_hub/features/notes/data/datasources/folders_data_source.dart';
import 'package:knowledge_hub/features/notes/data/models/folder_model.dart';

/// A trivial in-memory [FoldersDataSource], used to unit-test
/// [FoldersRepositoryImpl] in isolation from real SQLite -- mirrors the
/// Fake-per-contract pattern already used for [FakeNotesDataSource] (task
/// 2.6).
///
/// [FoldersDataSource] itself has no concept of notes -- the real
/// deleting-a-folder-unfiles-its-notes cascade is an `ON DELETE SET NULL`
/// foreign key owned by the DB schema/`FoldersLocalDataSourceImpl`, already
/// proven at that layer (tasks 1.7/2.4;
/// `folders_local_data_source_impl_test.dart`'s "unfiles notes previously
/// assigned to the deleted folder" case). This fake mirrors that cascade in
/// memory purely so the repository-level test suite can observe, from
/// outside, that `FoldersRepositoryImpl.deleteFolder` is a pure passthrough
/// that neither re-implements nor breaks it -- not to re-prove the DB-level
/// cascade itself.
class FakeFoldersDataSource implements FoldersDataSource {
  final Map<String, FolderModel> _foldersById = <String, FolderModel>{};
  final Map<String, String?> _folderIdByNoteId = <String, String?>{};

  Exception? createFolderException;
  Exception? watchFoldersException;
  Exception? deleteFolderException;

  void seedFolder(FolderModel folder) {
    _foldersById[folder.id] = folder;
  }

  void seedNoteInFolder({required String noteId, required String folderId}) {
    _folderIdByNoteId[noteId] = folderId;
  }

  String? folderIdOfNote(String noteId) => _folderIdByNoteId[noteId];

  @override
  Future<FolderModel> createFolder(String name) async {
    if (createFolderException != null) {
      throw createFolderException!;
    }
    final FolderModel folder = FolderModel(id: 'folder-${_foldersById.length + 1}', name: name);
    _foldersById[folder.id] = folder;
    return folder;
  }

  @override
  Stream<List<FolderModel>> watchFolders() {
    if (watchFoldersException != null) {
      return Stream<List<FolderModel>>.error(watchFoldersException!);
    }
    return Stream<List<FolderModel>>.value(_foldersById.values.toList());
  }

  @override
  Future<void> deleteFolder(String folderId) async {
    if (deleteFolderException != null) {
      throw deleteFolderException!;
    }
    _foldersById.remove(folderId);
    // Mirror the DB's `ON DELETE SET NULL` cascade in memory, since this
    // fake stands in for the whole DataSource/DB layer that owns it.
    for (final String noteId in _folderIdByNoteId.keys.toList()) {
      if (_folderIdByNoteId[noteId] == folderId) {
        _folderIdByNoteId[noteId] = null;
      }
    }
  }
}
