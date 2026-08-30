import 'dart:async';
import 'dart:developer';

import 'package:knowledge_hub/core/error/exception.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/data/datasources/folders_data_source.dart';
import 'package:knowledge_hub/features/notes/data/models/folder_model.dart';
import 'package:knowledge_hub/features/notes/domain/entities/folder.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/folders_repository.dart';

/// `FoldersDataSource`-backed implementation of `FoldersRepository`. Per the
/// guide's §6.3 discipline, this is the layer where `FoldersDataSource`'s
/// thrown exceptions are converted to `Result`/`Failure` values -- it never
/// lets a raw exception escape, and never re-implements business rules that
/// already live at the DataSource/DB layer (in particular, the
/// deleting-a-folder-unfiles-its-notes cascade is an `ON DELETE SET NULL`
/// foreign key owned by `FoldersLocalDataSourceImpl`/the schema, already
/// covered by tasks 1.7/2.4 -- this repository only needs to pass
/// `deleteFolder` through without swallowing or altering its outcome).
class FoldersRepositoryImpl implements FoldersRepository {
  const FoldersRepositoryImpl(this._dataSource);

  final FoldersDataSource _dataSource;

  @override
  Future<Result<Failure, Folder>> createFolder(String name) async {
    try {
      final FolderModel createdFolder = await _dataSource.createFolder(name);

      return Ok(createdFolder.toEntity());
    } on DuplicateNameException catch (e, stackTrace) {
      log('createFolder failed', error: e, stackTrace: stackTrace, name: 'folders.repository');
      return Err(DuplicateNameFailure(e.message ?? 'A folder with this name already exists'));
    } on CacheException catch (e, stackTrace) {
      log('createFolder failed', error: e, stackTrace: stackTrace, name: 'folders.repository');
      return Err(CacheFailure(e.message ?? 'No cached data available'));
    } on ServerException catch (e, stackTrace) {
      log('createFolder failed', error: e, stackTrace: stackTrace, name: 'folders.repository');
      return Err(ServerFailure(e.message ?? 'Server error'));
    }
  }

  // Unlike `NotesRepositoryImpl.watchNotes`/`watchSearchResults` (task 2.6),
  // there is no per-emission async I/O here -- `FolderModel.toEntity()` is a
  // pure, synchronous, non-throwing field copy (see `folder_model.dart`), so
  // an `asyncMap` + inner try/catch (task 2.6's pattern) would have nothing
  // to guard against. What still needs handling is a stream-level *error*
  // event (the data source's `watchFolders()` erroring out asynchronously,
  // e.g. a Drift query failure) -- a plain `try/catch` wrapped around this
  // synchronous stream-construction code would not catch that (the same
  // "outside vs. inside the stream" bug fixed in task 2.6), and `.map`
  // leaves error events untouched, letting them propagate as raw stream
  // errors instead of `Err(...)`. `StreamTransformer.fromHandlers` is the
  // correct tool: its `handleError` callback receives error *events* and can
  // push a replacement *data* event (`Err(...)`) onto the sink, converting
  // the error into the same `Result` shape every successful emission uses.
  @override
  Stream<Result<Failure, List<Folder>>> watchFolders() {
    return _dataSource.watchFolders().transform(
      StreamTransformer<List<FolderModel>, Result<Failure, List<Folder>>>.fromHandlers(
        handleData: (List<FolderModel> folderModels, EventSink<Result<Failure, List<Folder>>> sink) {
          sink.add(Ok(folderModels.map((FolderModel folder) => folder.toEntity()).toList()));
        },
        handleError: (Object error, StackTrace stackTrace, EventSink<Result<Failure, List<Folder>>> sink) {
          if (error is CacheException) {
            log('watchFolders failed', error: error, stackTrace: stackTrace, name: 'folders.repository');
            sink.add(Err(CacheFailure(error.message ?? 'No cached data available')));
          } else if (error is ServerException) {
            log('watchFolders failed', error: error, stackTrace: stackTrace, name: 'folders.repository');
            sink.add(Err(ServerFailure(error.message ?? 'Server error')));
          } else {
            sink.addError(error, stackTrace);
          }
        },
      ),
    );
  }

  @override
  Future<Result<Failure, void>> deleteFolder(String folderId) async {
    try {
      final void deletedFolder = await _dataSource.deleteFolder(folderId);

      return Ok(deletedFolder);
    } on CacheException catch (e, stackTrace) {
      log('deleteFolder failed', error: e, stackTrace: stackTrace, name: 'folders.repository');
      return Err(CacheFailure(e.message ?? 'No cached data available'));
    } on ServerException catch (e, stackTrace) {
      log('deleteFolder failed', error: e, stackTrace: stackTrace, name: 'folders.repository');
      return Err(ServerFailure(e.message ?? 'Server error'));
    }
  }
}
