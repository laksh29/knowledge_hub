import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/domain/entities/tag.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/create_tag_uc.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/delete_tag_uc.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/watch_tags_uc.dart';
import 'package:knowledge_hub/features/notes/presentation/cubit/tag/tag_state.dart';
import 'package:knowledge_hub/features/notes/presentation/map_failure_to_message.dart';
import 'package:knowledge_hub/features/notes/presentation/view_models/tag_view_model.dart';

/// Thin Cubit exposing simple methods (`createTag(name)`, `deleteTag(id)`)
/// that re-invoke the relevant use case and re-subscribe to `WatchTagsUc`
/// (design.md §"NoteListCubit / FolderCubit / TagCubit / TrashCubit").
///
/// `createTag`/`deleteTag` do not eagerly emit a "success" state on `Ok` --
/// the live `WatchTagsUc` subscription started in the constructor naturally
/// emits the updated list once the write lands, avoiding a
/// duplicate/racing source of truth for what the tag list currently is.
class TagCubit extends Cubit<TagState> {
  TagCubit({
    required CreateTagUc createTagUc,
    required WatchTagsUc watchTagsUc,
    required DeleteTagUc deleteTagUc,
  }) : _createTagUc = createTagUc,
       _watchTagsUc = watchTagsUc,
       _deleteTagUc = deleteTagUc,
       super(const TagState.loading()) {
    _tagsSubscription = _watchTagsUc().listen(_emitForWatchResult);
  }

  final CreateTagUc _createTagUc;
  final WatchTagsUc _watchTagsUc;
  final DeleteTagUc _deleteTagUc;

  StreamSubscription<Result<Failure, List<Tag>>>? _tagsSubscription;

  Future<void> createTag(String name) async {
    final Result<Failure, Tag> result = await _createTagUc(name);
    if (isClosed) {
      return;
    }
    // Every `Err` from `createTag` -- not only `DuplicateNameFailure` --
    // routes through `TagCreationFailed`. design.md's Validation note calls
    // out the duplicate-name case specifically because it's the failure a
    // user can self-correct (rename and retry), but the state shape itself
    // carries a plain `String errorMessage` with no failure-type
    // discriminant, and `mapFailureToMessage` already produces a specific,
    // correct message for every `Failure` subtype (including a genuine
    // `CacheFailure` storage problem). Silently swallowing a non-duplicate
    // failure (e.g. leaving the user's `createTag` call with no feedback at
    // all) would be worse than surfacing it through the one failure state
    // this Cubit has.
    result.when(
      failure: (Failure failure) =>
          emit(TagState.creationFailed(state.currentTags, mapFailureToMessage(failure))),
      success: (Tag _) {},
    );
  }

  Future<void> deleteTag(String tagId) async {
    // No dedicated delete-failure state exists for `TagCubit` in design.md
    // (unlike `TrashCubit.TrashActionFailed`, which explicitly covers
    // restore/permanent-delete failures) -- the live `WatchTagsUc`
    // subscription is the sole source of truth for what the list looks
    // like after this call, whether it succeeds or fails. Awaiting the
    // result (rather than firing-and-forgetting) still lets the `isClosed`
    // guard prevent a post-close emit if a failure path is added here
    // later.
    await _deleteTagUc(tagId);
  }

  void _emitForWatchResult(Result<Failure, List<Tag>> result) {
    if (isClosed) {
      return;
    }
    result.when(
      // A live-subscription failure, not a createTag action failure --
      // TagListLoadFailed, not TagCreationFailed (see tag_state.dart's
      // 2026-09-20 amendment for why conflating the two is wrong).
      failure: (Failure failure) => emit(TagState.loadFailed(mapFailureToMessage(failure))),
      success: (List<Tag> tags) =>
          emit(TagState.loaded(tags.map(TagViewModel.fromTag).toList())),
    );
  }

  @override
  Future<void> close() {
    unawaited(_tagsSubscription?.cancel());
    return super.close();
  }
}
