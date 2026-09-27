import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/domain/entities/tag.dart';

abstract class TagsRepository {
  Future<Result<Failure, Tag>> createTag(String name);
  Stream<Result<Failure, List<Tag>>> watchTags();
  Future<Result<Failure, void>> deleteTag(String tagId);
}
