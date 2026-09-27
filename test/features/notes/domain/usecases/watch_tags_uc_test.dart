import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/domain/entities/tag.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/tags_repository.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/watch_tags_uc.dart';
import 'package:mocktail/mocktail.dart';

class MockTagsRepository extends Mock implements TagsRepository {}

void main() {
  late MockTagsRepository tagsRepository;
  late WatchTagsUc watchTagsUc;

  const Tag tTag = Tag(id: 'tag-1', name: 'Biology');

  setUp(() {
    tagsRepository = MockTagsRepository();
    watchTagsUc = WatchTagsUc(tagsRepository);
  });

  test(
    'calls the repository\'s watchTags exactly once and emits its '
    'successful stream events unchanged',
    () async {
      when(() => tagsRepository.watchTags()).thenAnswer(
        (_) => Stream<Result<Failure, List<Tag>>>.value(
          const Ok<Failure, List<Tag>>(<Tag>[tTag]),
        ),
      );

      final Stream<Result<Failure, List<Tag>>> resultStream =
          watchTagsUc.call();

      await expectLater(
        resultStream,
        emits(
          isA<Ok<Failure, List<Tag>>>().having(
            (Ok<Failure, List<Tag>> ok) => ok.value,
            'value',
            <Tag>[tTag],
          ),
        ),
      );
      verify(() => tagsRepository.watchTags()).called(1);
      verifyNoMoreInteractions(tagsRepository);
    },
  );

  test('propagates the repository\'s failure stream events untouched', () async {
    const ServerFailure tFailure = ServerFailure('boom');
    when(() => tagsRepository.watchTags()).thenAnswer(
      (_) => Stream<Result<Failure, List<Tag>>>.value(
        const Err<Failure, List<Tag>>(tFailure),
      ),
    );

    final Stream<Result<Failure, List<Tag>>> resultStream =
        watchTagsUc.call();

    await expectLater(
      resultStream,
      emits(
        isA<Err<Failure, List<Tag>>>().having(
          (Err<Failure, List<Tag>> err) => err.failure_,
          'failure_',
          same(tFailure),
        ),
      ),
    );
    verify(() => tagsRepository.watchTags()).called(1);
    verifyNoMoreInteractions(tagsRepository);
  });
}
