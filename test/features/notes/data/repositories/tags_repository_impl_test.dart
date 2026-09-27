import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/core/error/exception.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/data/models/tag_model.dart';
import 'package:knowledge_hub/features/notes/data/repositories/tags_repository_impl.dart';
import 'package:knowledge_hub/features/notes/domain/entities/tag.dart';

import 'fakes/fake_tags_data_source.dart';

void main() {
  late FakeTagsDataSource dataSource;
  late TagsRepositoryImpl repository;

  setUp(() {
    dataSource = FakeTagsDataSource();
    repository = TagsRepositoryImpl(dataSource);
  });

  group('createTag', () {
    test('converts the created TagModel to a Tag entity', () async {
      final Result<Failure, Tag> result = await repository.createTag('Biology');

      expect(result, isA<Ok<Failure, Tag>>());
      final Tag tag = (result as Ok<Failure, Tag>).value;
      expect(tag.name, 'Biology');
      expect(tag.id, isNotEmpty);
    });

    test('a duplicate name surfaces as Err(DuplicateNameFailure), not CacheFailure', () async {
      dataSource.createTagException = const DuplicateNameException(
        'A tag named "Biology" already exists',
      );

      final Result<Failure, Tag> result = await repository.createTag('Biology');

      expect(result, isA<Err<Failure, Tag>>());
      final Failure failure = (result as Err<Failure, Tag>).failure_;
      expect(failure, isA<DuplicateNameFailure>());
      expect(failure.message, 'A tag named "Biology" already exists');
    });

    test('a CacheException converts to Err(CacheFailure) with the original message', () async {
      dataSource.createTagException = const CacheException('disk write failed');

      final Result<Failure, Tag> result = await repository.createTag('Biology');

      expect(result, isA<Err<Failure, Tag>>());
      final Failure failure = (result as Err<Failure, Tag>).failure_;
      expect(failure, isA<CacheFailure>());
      expect(failure.message, 'disk write failed');
    });

    test('a ServerException converts to Err(ServerFailure) with the original message', () async {
      dataSource.createTagException = const ServerException('upstream unavailable');

      final Result<Failure, Tag> result = await repository.createTag('Biology');

      expect(result, isA<Err<Failure, Tag>>());
      final Failure failure = (result as Err<Failure, Tag>).failure_;
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'upstream unavailable');
    });
  });

  group('watchTags', () {
    test('converts every emitted TagModel to a Tag entity', () async {
      dataSource.seedTag(const TagModel(id: 'tag-biology', name: 'Biology'));
      dataSource.seedTag(const TagModel(id: 'tag-chemistry', name: 'Chemistry'));

      final Result<Failure, List<Tag>> result = await repository.watchTags().first;

      expect(result, isA<Ok<Failure, List<Tag>>>());
      final List<Tag> tags = (result as Ok<Failure, List<Tag>>).value;
      expect(
        tags.map((Tag t) => t.name).toSet(),
        <String>{'Biology', 'Chemistry'},
      );
    });

    test('a CacheException from the stream converts to Err(CacheFailure)', () async {
      dataSource.watchTagsException = const CacheException('query failed');

      final Result<Failure, List<Tag>> result = await repository.watchTags().first;

      expect(result, isA<Err<Failure, List<Tag>>>());
      final Failure failure = (result as Err<Failure, List<Tag>>).failure_;
      expect(failure, isA<CacheFailure>());
      expect(failure.message, 'query failed');
    });

    test('a ServerException from the stream converts to Err(ServerFailure)', () async {
      dataSource.watchTagsException = const ServerException('sync failed');

      final Result<Failure, List<Tag>> result = await repository.watchTags().first;

      expect(result, isA<Err<Failure, List<Tag>>>());
      final Failure failure = (result as Err<Failure, List<Tag>>).failure_;
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'sync failed');
    });

    test(
      'a genuine async stream error (StreamController.addError, not a sync throw) converts to Err(...)',
      () async {
        final StreamController<List<TagModel>> controller = dataSource.useControllerBackedWatchTags();

        final Future<Result<Failure, List<Tag>>> pendingResult = repository.watchTags().first;

        // Delivered asynchronously via the event loop -- StreamController
        // (non-sync) always schedules its events as a microtask, never
        // during this synchronous call -- proving the repository's
        // StreamTransformer intercepts a real async error event, not just a
        // stream that is already erroring at construction time
        // (`Stream.error(...)`).
        controller.addError(const CacheException('async query failure'), StackTrace.current);

        final Result<Failure, List<Tag>> result = await pendingResult;

        expect(result, isA<Err<Failure, List<Tag>>>());
        final Failure failure = (result as Err<Failure, List<Tag>>).failure_;
        expect(failure, isA<CacheFailure>());
        expect(failure.message, 'async query failure');
      },
    );
  });

  group('deleteTag', () {
    test('passes through to the data source and returns Ok(void)', () async {
      dataSource.seedTag(const TagModel(id: 'tag-biology', name: 'Biology'));

      final Result<Failure, void> result = await repository.deleteTag('tag-biology');

      expect(result, isA<Ok<Failure, void>>());
    });

    test(
      'notes previously carrying the deleted tag remain intact, minus that one tag association',
      () async {
        dataSource.seedTag(const TagModel(id: 'tag-biology', name: 'Biology'));
        dataSource.seedNoteWithTag(noteId: 'note-1', tagId: 'tag-biology');

        final Result<Failure, void> result = await repository.deleteTag('tag-biology');

        expect(result, isA<Ok<Failure, void>>(), reason: 'deleteTag must not error');
        expect(
          dataSource.noteExists('note-1'),
          isTrue,
          reason: 'the note must survive -- deleteTag must not delete or error on it',
        );
        expect(
          dataSource.tagIdsOfNote('note-1'),
          isNot(contains('tag-biology')),
          reason: 'only the tag association is removed, not the note',
        );
      },
    );

    test('a CacheException converts to Err(CacheFailure) with the original message', () async {
      dataSource.deleteTagException = const CacheException('delete failed');

      final Result<Failure, void> result = await repository.deleteTag('tag-biology');

      expect(result, isA<Err<Failure, void>>());
      final Failure failure = (result as Err<Failure, void>).failure_;
      expect(failure, isA<CacheFailure>());
      expect(failure.message, 'delete failed');
    });

    test('a ServerException converts to Err(ServerFailure) with the original message', () async {
      dataSource.deleteTagException = const ServerException('server unavailable');

      final Result<Failure, void> result = await repository.deleteTag('tag-biology');

      expect(result, isA<Err<Failure, void>>());
      final Failure failure = (result as Err<Failure, void>).failure_;
      expect(failure, isA<ServerFailure>());
      expect(failure.message, 'server unavailable');
    });
  });
}
