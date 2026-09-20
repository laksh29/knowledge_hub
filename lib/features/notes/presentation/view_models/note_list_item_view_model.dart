import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note.dart';

part 'note_list_item_view_model.freezed.dart';

/// Longest [bodyPreview] a list row will show before truncation. Matches
/// the "muted meta" line design.md's UI Components alignment table
/// describes for `NoteListItemWidget` — a short body snippet, not the full
/// note body.
const int _bodyPreviewMaxLength = 120;

/// Presentation-ready shape for a single note-list row. Carries only the
/// fields a `NoteListItemWidget` needs to render — the domain [Note] entity
/// never leaks through this ViewModel's public shape (per design.md's
/// ViewModel convention, mirrored from `NoteEditorViewModel` /
/// `NoteSearchResultViewModel`).
@freezed
abstract class NoteListItemViewModel with _$NoteListItemViewModel {
  const factory NoteListItemViewModel({
    required String noteId,
    required String title,
    required String bodyPreview,
    String? folderId,
    @Default(<String>[]) List<String> tagIds,
    required DateTime updatedAt,
  }) = _NoteListItemViewModel;

  factory NoteListItemViewModel.fromNote(Note note) => NoteListItemViewModel(
    noteId: note.id,
    title: note.title,
    bodyPreview: _buildBodyPreview(note.body),
    folderId: note.folderId,
    tagIds: note.tagIds,
    updatedAt: note.updatedAt,
  );
}

/// Collapses the note body's whitespace/newlines into a single-line snippet
/// and truncates it to [_bodyPreviewMaxLength] characters, so a multi-
/// paragraph note body doesn't blow out the fixed-height list row.
String _buildBodyPreview(String body) {
  final String collapsed = body.replaceAll(RegExp(r'\s+'), ' ').trim();
  if (collapsed.length <= _bodyPreviewMaxLength) {
    return collapsed;
  }
  return '${collapsed.substring(0, _bodyPreviewMaxLength).trimRight()}…';
}
