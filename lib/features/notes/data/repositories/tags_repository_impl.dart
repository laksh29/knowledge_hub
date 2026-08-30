import 'dart:async';
import 'dart:developer';

import 'package:knowledge_hub/core/error/exception.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/data/datasources/tags_data_source.dart';
import 'package:knowledge_hub/features/notes/data/models/tag_model.dart';
import 'package:knowledge_hub/features/notes/domain/entities/tag.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/tags_repository.dart';

/// `TagsDataSource`-backed implementation of `TagsRepository`. Per the
/// guide's §6.3 discipline, this is the layer where `TagsDataSource`'s
/// thrown exceptions are converted to `Result`/`Failure` values -- it never
/// lets a raw exception escape, and never re-implements business rules that
/// already live at the DataSource/DB layer (in particular, the
/// deleting-a-tag-removes-its-note-associations cascade is an
/// `ON DELETE CASCADE` foreign key on `NoteTags`, owned by
/// `TagsLocalDataSourceImpl`/the schema, already covered by tasks 1.7/2.5 --
/// this repository only needs to pass `deleteTag` through without swallowing
/// or altering its outcome, and without ever touching the notes themselves).
class TagsRepositoryImpl implements TagsRepository {
  const TagsRepositoryImpl(this._dataSource);

  final TagsDataSource _dataSource;

  @override
  Future<Result<Failure, Tag>> createTag(String name) async {
    try {
      final TagModel createdTag = await _dataSource.createTag(name);

      return Ok(createdTag.toEntity());
    } on DuplicateNameException catch (e, stackTrace) {
      log('createTag failed', error: e, stackTrace: stackTrace, name: 'tags.repository');
      return Err(DuplicateNameFailure(e.message ?? 'A tag with this name already exists'));
    } on CacheException catch (e, stackTrace) {
      log('createTag failed', error: e, stackTrace: stackTrace, name: 'tags.repository');
      return Err(CacheFailure(e.message ?? 'No cached data available'));
    } on ServerException catch (e, stackTrace) {
      log('createTag failed', error: e, stackTrace: stackTrace, name: 'tags.repository');
      return Err(ServerFailure(e.message ?? 'Server error'));
    }
  }

  // As with `FoldersRepositoryImpl.watchFolders` (task 2.7), there is no
  // per-emission async I/O here -- `TagModel.toEntity()` is a pure,
  // synchronous, non-throwing field copy (see `tag_model.dart`), so a plain
  // `try/catch` around this synchronous stream-construction code would have
  // nothing to guard against and would not catch a stream-level *error*
  // event (the data source's `watchTags()` erroring out asynchronously,
  // e.g. a Drift query failure) -- that is the same "outside vs. inside the
  // stream" bug fixed in task 2.6. `StreamTransformer.fromHandlers` is the
  // correct tool: its `handleError` callback receives error *events* and can
  // push a replacement *data* event (`Err(...)`) onto the sink, converting
  // the error into the same `Result` shape every successful emission uses.
  @override
  Stream<Result<Failure, List<Tag>>> watchTags() {
    return _dataSource.watchTags().transform(
      StreamTransformer<List<TagModel>, Result<Failure, List<Tag>>>.fromHandlers(
        handleData: (List<TagModel> tagModels, EventSink<Result<Failure, List<Tag>>> sink) {
          sink.add(Ok(tagModels.map((TagModel tag) => tag.toEntity()).toList()));
        },
        handleError: (Object error, StackTrace stackTrace, EventSink<Result<Failure, List<Tag>>> sink) {
          if (error is CacheException) {
            log('watchTags failed', error: error, stackTrace: stackTrace, name: 'tags.repository');
            sink.add(Err(CacheFailure(error.message ?? 'No cached data available')));
          } else if (error is ServerException) {
            log('watchTags failed', error: error, stackTrace: stackTrace, name: 'tags.repository');
            sink.add(Err(ServerFailure(error.message ?? 'Server error')));
          } else {
            sink.addError(error, stackTrace);
          }
        },
      ),
    );
  }

  @override
  Future<Result<Failure, void>> deleteTag(String tagId) async {
    try {
      final void deletedTag = await _dataSource.deleteTag(tagId);

      return Ok(deletedTag);
    } on CacheException catch (e, stackTrace) {
      log('deleteTag failed', error: e, stackTrace: stackTrace, name: 'tags.repository');
      return Err(CacheFailure(e.message ?? 'No cached data available'));
    } on ServerException catch (e, stackTrace) {
      log('deleteTag failed', error: e, stackTrace: stackTrace, name: 'tags.repository');
      return Err(ServerFailure(e.message ?? 'Server error'));
    }
  }
}
