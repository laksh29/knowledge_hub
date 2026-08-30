import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:knowledge_hub/features/notes/presentation/view_models/note_editor_view_model.dart';

part 'note_editor_state.freezed.dart';

/// One distinct subclass per save-status scenario — **not** a single "ready"
/// state carrying a `saveStatusLabel` flag/getter, per design.md's
/// NoteEditorBloc State Management note and this project's steering rule
/// against mono-state ("no single state with loading/loaded/error flags or
/// enums"). Which subclass is active *is* the save status —
/// `SaveStatusIndicatorWidget` switches on `state.runtimeType`, it never
/// reads a label field off a shared state.
///
/// Every non-initializing subclass carries the same [NoteEditorViewModel]
/// forward (title/body/folder/tags — presentation-ready getters, no status
/// field), per the guide's §7.3 pattern of carrying ViewModels across state
/// transitions to avoid UI flicker.
@freezed
sealed class NoteEditorState with _$NoteEditorState {
  /// Before the note exists yet (e.g. `CreateNoteUc` in flight).
  const factory NoteEditorState.initializing() = NoteEditorInitializing;

  /// Content differs from the last persisted version (Requirement 3.5).
  const factory NoteEditorState.notSaved(NoteEditorViewModel viewModel) = NoteEditorNotSaved;

  /// A save is in flight (Requirement 3.6).
  const factory NoteEditorState.saving(NoteEditorViewModel viewModel) = NoteEditorSaving;

  /// The last save completed successfully (Requirement 3.7).
  const factory NoteEditorState.saved(NoteEditorViewModel viewModel) = NoteEditorSaved;

  /// The last save attempt failed; [viewModel] preserves the in-memory
  /// draft rather than discarding it (Requirement 3.8's zero-data-loss
  /// guarantee — the failure must never lose what the user typed).
  const factory NoteEditorState.saveFailed(NoteEditorViewModel viewModel, String errorMessage) =
      NoteEditorSaveFailed;
}
