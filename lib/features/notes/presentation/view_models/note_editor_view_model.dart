import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note.dart';

part 'note_editor_view_model.freezed.dart';

/// Presentation-ready shape for the note editor. Carries title/body/folder/
/// tag content only — save status is which [NoteEditorState] subclass is
/// active, never a field here (per design.md's §"NoteEditorBloc" State
/// Management note).
@freezed
abstract class NoteEditorViewModel with _$NoteEditorViewModel {
  const factory NoteEditorViewModel({
    required String noteId,
    required String title,
    required String body,
    String? folderId,
    @Default(<String>[]) List<String> tagIds,
  }) = _NoteEditorViewModel;

  factory NoteEditorViewModel.fromNote(Note note) => NoteEditorViewModel(
    noteId: note.id,
    title: note.title,
    body: note.body,
    folderId: note.folderId,
    tagIds: note.tagIds,
  );
}
