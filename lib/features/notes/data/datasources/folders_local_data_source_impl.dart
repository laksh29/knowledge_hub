import 'package:injectable/injectable.dart';
import 'package:knowledge_hub/core/error/exception.dart';
import 'package:knowledge_hub/features/notes/data/datasources/folders_data_source.dart';
import 'package:knowledge_hub/features/notes/data/local/notes_database.dart';
import 'package:knowledge_hub/features/notes/data/models/folder_model.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:uuid/uuid.dart';

/// SQLite's extended result code for a UNIQUE constraint violation
/// (`SQLITE_CONSTRAINT_UNIQUE`). See https://sqlite.org/rescode.html.
const int _sqliteConstraintUniqueExtendedResultCode = 2067;

/// Drift-backed implementation of [FoldersDataSource]. Named "Local" (not
/// "Drift") per the guide's §6.2 convention so a future
/// `FoldersNetworkDataSourceImpl` (v1.1, Supabase-backed) can implement the
/// same contract without this class being renamed.
@LazySingleton(as: FoldersDataSource)
class FoldersLocalDataSourceImpl implements FoldersDataSource {
  const FoldersLocalDataSourceImpl(this._database);

  final NotesDatabase _database;

  @override
  Future<FolderModel> createFolder(String name) async {
    try {
      final Folder? existing = await (_database.select(
        _database.folders,
      )..where((f) => f.name.equals(name))).getSingleOrNull();
      if (existing != null) {
        throw DuplicateNameException('A folder named "$name" already exists');
      }

      final FolderModel folder = FolderModel(id: const Uuid().v4(), name: name);
      await _database.into(_database.folders).insert(folder.toCompanion());
      return folder;
    } on DuplicateNameException {
      rethrow;
    } on SqliteException catch (e) {
      // The SELECT-then-INSERT precheck above can lose a race between two
      // concurrent createFolder calls with the same name: both SELECTs can
      // find no existing row before either INSERT runs. The schema-level
      // UNIQUE constraint on folders.name is the backstop for that case —
      // reclassify its violation as DuplicateNameException instead of
      // letting it fall through as a generic CacheException.
      if (e.extendedResultCode == _sqliteConstraintUniqueExtendedResultCode) {
        throw DuplicateNameException('A folder named "$name" already exists');
      }
      throw CacheException(e.toString());
    } on Exception catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Stream<List<FolderModel>> watchFolders() {
    return _database.select(_database.folders).watch().map(
      (rows) => rows.map(FolderModel.fromDriftRow).toList(),
    );
  }

  @override
  Future<void> deleteFolder(String folderId) async {
    try {
      await (_database.delete(_database.folders)..where((f) => f.id.equals(folderId))).go();
    } on Exception catch (e) {
      throw CacheException(e.toString());
    }
  }
}
