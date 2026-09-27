import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note_search_result.dart';

part 'note_search_result_view_model.freezed.dart';

/// Presentation-ready shape for a single search-result list item. Carries
/// only the fields a `NoteSearchResultItemWidget` needs to render — the
/// domain `Note` entity never leaks through this ViewModel's public shape
/// (per design.md's ViewModel convention, mirrored from
/// `NoteEditorViewModel`).
@freezed
abstract class NoteSearchResultViewModel with _$NoteSearchResultViewModel {
  const factory NoteSearchResultViewModel({
    required String noteId,
    required String title,
    required String highlightedTitleSnippet,
    required String highlightedBodySnippet,
    String? folderId,
    @Default(<String>[]) List<String> tagIds,
  }) = _NoteSearchResultViewModel;

  factory NoteSearchResultViewModel.fromSearchResult(NoteSearchResult result) =>
      NoteSearchResultViewModel(
        noteId: result.note.id,
        title: result.note.title,
        highlightedTitleSnippet: result.highlightedTitleSnippet,
        highlightedBodySnippet: result.highlightedBodySnippet,
        folderId: result.note.folderId,
        tagIds: result.note.tagIds,
      );
}
