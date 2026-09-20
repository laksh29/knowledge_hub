import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/domain/entities/tag.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/create_tag_uc.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/delete_tag_uc.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/watch_tags_uc.dart';
import 'package:knowledge_hub/features/notes/presentation/cubit/tag/tag_cubit.dart';
import 'package:knowledge_hub/features/notes/presentation/cubit/tag/tag_state.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateTagUc extends Mock implements CreateTagUc {}

class MockWatchTagsUc extends Mock implements WatchTagsUc {}

class MockDeleteTagUc extends Mock implements DeleteTagUc {}

void main() {
  late MockCreateTagUc createTagUc;
  late MockWatchTagsUc watchTagsUc;
  late MockDeleteTagUc deleteTagUc;

  Tag buildTag(String id, String name) => Tag(id: id, name: name);

  TagCubit buildCubit() =>
      TagCubit(createTagUc: createTagUc, watchTagsUc: watchTagsUc, deleteTagUc: deleteTagUc);

  setUp(() {
    createTagUc = MockCreateTagUc();
    watchTagsUc = MockWatchTagsUc();
    deleteTagUc = MockDeleteTagUc();
    // The constructor immediately subscribes -- stub a default so every
    // test's setUp doesn't hit a MissingStubError before the test body
    // overrides it with a more specific stub.
    when(
      () => watchTagsUc.call(),
    ).thenAnswer((_) => Stream<Result<Failure, List<Tag>>>.value(const Ok(<Tag>[])));
  });

  group('TagCubit', () {
    test(
      'watchTags live subscription maps Ok(tags) to TagListLoaded with '
      'correctly converted TagViewModels',
      () async {
        final List<Tag> tags = <Tag>[buildTag('tag-1', 'Work'), buildTag('tag-2', 'Personal')];
        when(
          () => watchTagsUc.call(),
        ).thenAnswer((_) => Stream<Result<Failure, List<Tag>>>.value(Ok(tags)));

        final TagCubit cubit = buildCubit();
        addTearDown(cubit.close);
        await pumpEventQueue();

        expect(cubit.state, isA<TagListLoaded>());
        final TagListLoaded loaded = cubit.state as TagListLoaded;
        expect(loaded.tags.map((t) => t.tagId), <String>['tag-1', 'tag-2']);
        expect(loaded.tags.map((t) => t.name), <String>['Work', 'Personal']);
      },
    );

    test(
      'createTag with a duplicate name emits TagCreationFailed carrying '
      'the existing tag list forward plus a specific error message',
      () async {
        final List<Tag> existingTags = <Tag>[buildTag('tag-1', 'Work')];
        when(
          () => watchTagsUc.call(),
        ).thenAnswer((_) => Stream<Result<Failure, List<Tag>>>.value(Ok(existingTags)));
        when(
          () => createTagUc.call('Work'),
        ).thenAnswer((_) async => const Err(DuplicateNameFailure('A tag named "Work" already exists')));

        final TagCubit cubit = buildCubit();
        addTearDown(cubit.close);
        await pumpEventQueue();
        expect(cubit.state, isA<TagListLoaded>());

        await cubit.createTag('Work');
        await pumpEventQueue();

        expect(cubit.state, isA<TagCreationFailed>());
        final TagCreationFailed failedState = cubit.state as TagCreationFailed;
        expect(failedState.currentTags.map((t) => t.tagId), <String>['tag-1']);
        expect(failedState.currentTags.map((t) => t.name), <String>['Work']);
        expect(
          failedState.errorMessage,
          'A tag named "Work" already exists — choose a different name.',
        );
      },
    );

    test(
      'createTag with a non-duplicate failure (CacheFailure) also emits '
      'TagCreationFailed carrying the existing list forward',
      () async {
        final List<Tag> existingTags = <Tag>[buildTag('tag-1', 'Work')];
        when(
          () => watchTagsUc.call(),
        ).thenAnswer((_) => Stream<Result<Failure, List<Tag>>>.value(Ok(existingTags)));
        when(
          () => createTagUc.call('New Tag'),
        ).thenAnswer((_) async => const Err(CacheFailure('disk I/O error')));

        final TagCubit cubit = buildCubit();
        addTearDown(cubit.close);
        await pumpEventQueue();

        await cubit.createTag('New Tag');
        await pumpEventQueue();

        expect(cubit.state, isA<TagCreationFailed>());
        final TagCreationFailed failedState = cubit.state as TagCreationFailed;
        expect(failedState.currentTags.map((t) => t.tagId), <String>['tag-1']);
        expect(failedState.errorMessage, isNotEmpty);
      },
    );

    test(
      'a WatchTagsUc stream failure emits the dedicated TagListLoadFailed '
      'state, never TagCreationFailed -- no tag creation was attempted',
      () async {
        when(() => watchTagsUc.call()).thenAnswer(
          (_) =>
              Stream<Result<Failure, List<Tag>>>.value(const Err(CacheFailure('disk I/O error'))),
        );

        final TagCubit cubit = buildCubit();
        addTearDown(cubit.close);
        await pumpEventQueue();

        expect(cubit.state, isA<TagListLoadFailed>());
        expect((cubit.state as TagListLoadFailed).errorMessage, isNotEmpty);
      },
    );

    test('deleteTag invokes DeleteTagUc with the given tagId', () async {
      when(() => deleteTagUc.call('tag-1')).thenAnswer((_) async => const Ok(null));

      final TagCubit cubit = buildCubit();
      addTearDown(cubit.close);
      await pumpEventQueue();

      await cubit.deleteTag('tag-1');
      await pumpEventQueue();

      verify(() => deleteTagUc.call('tag-1')).called(1);
    });
  });
}
