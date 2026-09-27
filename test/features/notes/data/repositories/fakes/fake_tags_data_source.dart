import 'dart:async';

import 'package:knowledge_hub/features/notes/data/datasources/tags_data_source.dart';
import 'package:knowledge_hub/features/notes/data/models/tag_model.dart';

/// A trivial in-memory [TagsDataSource], used to unit-test
/// [TagsRepositoryImpl] in isolation from real SQLite -- mirrors the
/// Fake-per-contract pattern already used for [FakeFoldersDataSource] (task
/// 2.7).
///
/// [TagsDataSource] itself has no concept of notes -- the real
/// deleting-a-tag-removes-its-NoteTags-rows cascade is an `ON DELETE CASCADE`
/// foreign key owned by the DB schema/`TagsLocalDataSourceImpl`, already
/// proven at that layer (tasks 1.7/2.5). This fake mirrors that cascade in
/// memory purely so the repository-level test suite can observe, from
/// outside, that `TagsRepositoryImpl.deleteTag` is a pure passthrough that
/// neither re-implements nor breaks it (notes survive, only the association
/// is removed) -- not to re-prove the DB-level cascade itself.
class FakeTagsDataSource implements TagsDataSource {
  final Map<String, TagModel> _tagsById = <String, TagModel>{};
  final Map<String, Set<String>> _tagIdsByNoteId = <String, Set<String>>{};

  Exception? createTagException;
  Exception? watchTagsException;
  Exception? deleteTagException;

  StreamController<List<TagModel>>? _watchTagsController;

  void seedTag(TagModel tag) {
    _tagsById[tag.id] = tag;
  }

  void seedNoteWithTag({required String noteId, required String tagId}) {
    _tagIdsByNoteId.putIfAbsent(noteId, () => <String>{}).add(tagId);
  }

  bool noteExists(String noteId) => _tagIdsByNoteId.containsKey(noteId);

  Set<String> tagIdsOfNote(String noteId) => _tagIdsByNoteId[noteId] ?? const <String>{};

  /// Switches [watchTags] to a controller-backed stream so a test can push a
  /// genuine *asynchronous* error event via the returned controller's
  /// `addError`, distinct from the synchronous `Stream.error(...)` used when
  /// [watchTagsException] is set.
  StreamController<List<TagModel>> useControllerBackedWatchTags() {
    final StreamController<List<TagModel>> controller = StreamController<List<TagModel>>();
    _watchTagsController = controller;
    return controller;
  }

  @override
  Future<TagModel> createTag(String name) async {
    if (createTagException != null) {
      throw createTagException!;
    }
    final TagModel tag = TagModel(id: 'tag-${_tagsById.length + 1}', name: name);
    _tagsById[tag.id] = tag;
    return tag;
  }

  @override
  Stream<List<TagModel>> watchTags() {
    if (watchTagsException != null) {
      return Stream<List<TagModel>>.error(watchTagsException!);
    }
    final StreamController<List<TagModel>>? controller = _watchTagsController;
    if (controller != null) {
      return controller.stream;
    }
    return Stream<List<TagModel>>.value(_tagsById.values.toList());
  }

  @override
  Future<void> deleteTag(String tagId) async {
    if (deleteTagException != null) {
      throw deleteTagException!;
    }
    _tagsById.remove(tagId);
    // Mirror the DB's `ON DELETE CASCADE` on `NoteTags` in memory, since this
    // fake stands in for the whole DataSource/DB layer that owns it.
    for (final String noteId in _tagIdsByNoteId.keys.toList()) {
      _tagIdsByNoteId[noteId]!.remove(tagId);
    }
  }
}
