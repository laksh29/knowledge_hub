import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/domain/entities/tag.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/tags_repository.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/create_tag_uc.dart';
import 'package:mocktail/mocktail.dart';

class MockTagsRepository extends Mock implements TagsRepository {}

void main() {
  late MockTagsRepository tagsRepository;
  late CreateTagUc createTagUc;

  const String tName = 'Biology';
  const Tag tTag = Tag(id: 'tag-1', name: tName);

  setUp(() {
    tagsRepository = MockTagsRepository();
    createTagUc = CreateTagUc(tagsRepository);
  });

  test(
    'forwards the name to the repository unchanged and returns its successful result unchanged',
    () async {
      when(() => tagsRepository.createTag(tName)).thenAnswer(
        (_) async => const Ok<Failure, Tag>(tTag),
      );

      final Result<Failure, Tag> result = await createTagUc.call(tName);

      expect(result, isA<Ok<Failure, Tag>>());
      expect((result as Ok<Failure, Tag>).value, tTag);
      verify(() => tagsRepository.createTag(tName)).called(1);
      verifyNoMoreInteractions(tagsRepository);
    },
  );

  test(
    'propagates a duplicate-name failure from the repository untouched',
    () async {
      const DuplicateNameFailure tFailure = DuplicateNameFailure(
        'A tag named "Biology" already exists',
      );
      when(() => tagsRepository.createTag(tName)).thenAnswer(
        (_) async => const Err<Failure, Tag>(tFailure),
      );

      final Result<Failure, Tag> result = await createTagUc.call(tName);

      expect(result, isA<Err<Failure, Tag>>());
      final Failure resultFailure = (result as Err<Failure, Tag>).failure_;
      expect(resultFailure, isA<DuplicateNameFailure>());
      expect(resultFailure, same(tFailure));
      expect(resultFailure.message, tFailure.message);
      verify(() => tagsRepository.createTag(tName)).called(1);
      verifyNoMoreInteractions(tagsRepository);
    },
  );

  test('propagates the repository\'s failure untouched', () async {
    const ServerFailure tFailure = ServerFailure('boom');
    when(() => tagsRepository.createTag(tName)).thenAnswer(
      (_) async => const Err<Failure, Tag>(tFailure),
    );

    final Result<Failure, Tag> result = await createTagUc.call(tName);

    expect(result, isA<Err<Failure, Tag>>());
    expect((result as Err<Failure, Tag>).failure_, same(tFailure));
    verify(() => tagsRepository.createTag(tName)).called(1);
    verifyNoMoreInteractions(tagsRepository);
  });
}
