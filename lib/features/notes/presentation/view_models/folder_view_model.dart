import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:knowledge_hub/features/notes/domain/entities/folder.dart';

part 'folder_view_model.freezed.dart';

/// Presentation-ready shape for a single folder row/chip. Carries only the
/// fields a folder-list widget needs to render — the domain [Folder] entity
/// never leaks through this ViewModel's public shape (mirrors
/// `NoteListItemViewModel`'s convention).
@freezed
abstract class FolderViewModel with _$FolderViewModel {
  const factory FolderViewModel({required String folderId, required String name}) =
      _FolderViewModel;

  factory FolderViewModel.fromFolder(Folder folder) =>
      FolderViewModel(folderId: folder.id, name: folder.name);
}
