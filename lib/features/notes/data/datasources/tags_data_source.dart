import 'package:knowledge_hub/features/notes/data/models/tag_model.dart';

/// Abstract contract the tags data-access layer must satisfy. Narrower and
/// lower-level than `TagsRepository`: it speaks in `TagModel`s, not domain
/// `Tag` entities, and it throws (`CacheException`/`DuplicateNameException`)
/// rather than returning `Result`.
///
/// A single contract shared by every storage-engine-specific implementation
/// (today: `TagsLocalDataSourceImpl`; in v1.1, a `TagsNetworkDataSourceImpl`
/// could implement the same contract), per the guide's §6.2 pattern.
abstract class TagsDataSource {
  /// Throws `DuplicateNameException` when `name` already belongs to an
  /// existing tag (the `tags.name` UNIQUE constraint).
  Future<TagModel> createTag(String name);

  Stream<List<TagModel>> watchTags();

  Future<void> deleteTag(String tagId);
}
