import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/domain/entities/tag.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/tags_repository.dart';

class FakeTagsRepository implements TagsRepository {
  FakeTagsRepository({required this.existingTags});

  final List<Tag> existingTags;

  @override
  Future<Result<Failure, Tag>> createTag(String name) async {
    final bool nameAlreadyTaken = existingTags.any(
      (Tag tag) => tag.name == name,
    );
    if (nameAlreadyTaken) {
      return Err<Failure, Tag>(
        DuplicateNameFailure('A tag named "$name" already exists'),
      );
    }
    return Ok<Failure, Tag>(Tag(id: 'tag-new', name: name));
  }

  @override
  Stream<Result<Failure, List<Tag>>> watchTags() =>
      Stream<Result<Failure, List<Tag>>>.value(
        Ok<Failure, List<Tag>>(existingTags),
      );

  @override
  Future<Result<Failure, void>> deleteTag(String tagId) async =>
      const Ok<Failure, void>(null);
}
