import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:knowledge_hub/features/notes/domain/entities/tag.dart';

part 'tag_view_model.freezed.dart';

/// Presentation-ready shape for a single tag row/chip. Carries only the
/// fields a tag-list widget needs to render — the domain [Tag] entity never
/// leaks through this ViewModel's public shape (mirrors `FolderViewModel`'s
/// convention).
@freezed
abstract class TagViewModel with _$TagViewModel {
  const factory TagViewModel({required String tagId, required String name}) = _TagViewModel;

  factory TagViewModel.fromTag(Tag tag) => TagViewModel(tagId: tag.id, name: tag.name);
}
