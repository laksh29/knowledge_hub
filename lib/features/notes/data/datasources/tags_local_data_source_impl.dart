import 'package:injectable/injectable.dart';
import 'package:knowledge_hub/core/error/exception.dart';
import 'package:knowledge_hub/features/notes/data/datasources/tags_data_source.dart';
import 'package:knowledge_hub/features/notes/data/local/notes_database.dart';
import 'package:knowledge_hub/features/notes/data/models/tag_model.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:uuid/uuid.dart';

/// SQLite's extended result code for a UNIQUE constraint violation
/// (`SQLITE_CONSTRAINT_UNIQUE`). See https://sqlite.org/rescode.html.
const int _sqliteConstraintUniqueExtendedResultCode = 2067;

/// Drift-backed implementation of [TagsDataSource]. Named "Local" (not
/// "Drift") per the guide's §6.2 convention so a future
/// `TagsNetworkDataSourceImpl` (v1.1, Supabase-backed) can implement the
/// same contract without this class being renamed.
@LazySingleton(as: TagsDataSource)
class TagsLocalDataSourceImpl implements TagsDataSource {
  const TagsLocalDataSourceImpl(this._database);

  final NotesDatabase _database;

  @override
  Future<TagModel> createTag(String name) async {
    try {
      final Tag? existing = await (_database.select(
        _database.tags,
      )..where((t) => t.name.equals(name))).getSingleOrNull();
      if (existing != null) {
        throw DuplicateNameException('A tag named "$name" already exists');
      }

      final TagModel tag = TagModel(id: const Uuid().v4(), name: name);
      await _database.into(_database.tags).insert(tag.toCompanion());
      return tag;
    } on DuplicateNameException {
      rethrow;
    } on SqliteException catch (e) {
      // The SELECT-then-INSERT precheck above can lose a race between two
      // concurrent createTag calls with the same name: both SELECTs can
      // find no existing row before either INSERT runs. The schema-level
      // UNIQUE constraint on tags.name is the backstop for that case —
      // reclassify its violation as DuplicateNameException instead of
      // letting it fall through as a generic CacheException.
      if (e.extendedResultCode == _sqliteConstraintUniqueExtendedResultCode) {
        throw DuplicateNameException('A tag named "$name" already exists');
      }
      throw CacheException(e.toString());
    } on Exception catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Stream<List<TagModel>> watchTags() {
    return _database.select(_database.tags).watch().map(
      (rows) => rows.map(TagModel.fromDriftRow).toList(),
    );
  }

  @override
  Future<void> deleteTag(String tagId) async {
    try {
      await (_database.delete(_database.tags)..where((t) => t.id.equals(tagId))).go();
    } on Exception catch (e) {
      throw CacheException(e.toString());
    }
  }
}
