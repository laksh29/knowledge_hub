import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/tags_repository.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/delete_tag_uc.dart';
import 'package:mocktail/mocktail.dart';

class MockTagsRepository extends Mock implements TagsRepository {}

void main() {
  late MockTagsRepository tagsRepository;
  late DeleteTagUc deleteTagUc;

  const String tTagId = 'tag-1';

  setUp(() {
    tagsRepository = MockTagsRepository();
    deleteTagUc = DeleteTagUc(tagsRepository);
  });

  test(
    'forwards the tagId to the repository unchanged and returns its successful result unchanged',
    () async {
      when(() => tagsRepository.deleteTag(tTagId)).thenAnswer(
        (_) async => const Ok<Failure, void>(null),
      );

      final Result<Failure, void> result = await deleteTagUc.call(tTagId);

      expect(result, isA<Ok<Failure, void>>());
      verify(() => tagsRepository.deleteTag(tTagId)).called(1);
      verifyNoMoreInteractions(tagsRepository);
    },
  );

  test('propagates the repository\'s failure untouched', () async {
    const ServerFailure tFailure = ServerFailure('boom');
    when(() => tagsRepository.deleteTag(tTagId)).thenAnswer(
      (_) async => const Err<Failure, void>(tFailure),
    );

    final Result<Failure, void> result = await deleteTagUc.call(tTagId);

    expect(result, isA<Err<Failure, void>>());
    expect((result as Err<Failure, void>).failure_, same(tFailure));
    verify(() => tagsRepository.deleteTag(tTagId)).called(1);
    verifyNoMoreInteractions(tagsRepository);
  });
}
