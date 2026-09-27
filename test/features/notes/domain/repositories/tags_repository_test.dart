import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/domain/entities/tag.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/tags_repository.dart';

import 'fakes/fake_tags_repository.dart';

void main() {
  final Tag existingTag = const Tag(id: 'tag-1', name: 'algorithms');

  late TagsRepository tagsRepository;

  setUp(() {
    tagsRepository = FakeTagsRepository(existingTags: <Tag>[existingTag]);
  });

  test('a fake genuinely implements TagsRepository', () {
    expect(tagsRepository, isA<TagsRepository>());
  });

  test(
    'createTag takes a String name and returns Future<Result<Failure, Tag>>',
    () async {
      final Future<Result<Failure, Tag>> pending = tagsRepository.createTag(
        'databases',
      );

      expect(pending, isA<Future<Result<Failure, Tag>>>());
      final Result<Failure, Tag> result = await pending;
      expect(result, isA<Ok<Failure, Tag>>());
      expect((result as Ok<Failure, Tag>).value.name, 'databases');
    },
  );

  test('createTag surfaces a duplicate name as Err(DuplicateNameFailure)', () async {
    final Result<Failure, Tag> result = await tagsRepository.createTag(
      'algorithms',
    );

    expect(result, isA<Err<Failure, Tag>>());
    expect(
      (result as Err<Failure, Tag>).failure_,
      isA<DuplicateNameFailure>(),
    );
  });

  test('watchTags returns Stream<Result<Failure, List<Tag>>>', () async {
    final Stream<Result<Failure, List<Tag>>> stream = tagsRepository
        .watchTags();

    expect(stream, isA<Stream<Result<Failure, List<Tag>>>>());
    final Result<Failure, List<Tag>> result = await stream.first;
    expect(result, isA<Ok<Failure, List<Tag>>>());
    expect((result as Ok<Failure, List<Tag>>).value, <Tag>[existingTag]);
  });

  test(
    'deleteTag takes a tagId and returns Future<Result<Failure, void>>',
    () async {
      final Result<Failure, void> result = await tagsRepository.deleteTag(
        'tag-1',
      );

      expect(result, isA<Ok<Failure, void>>());
    },
  );
}
