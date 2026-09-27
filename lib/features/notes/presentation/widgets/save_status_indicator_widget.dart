import 'package:flutter/material.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_colors.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_text_styles.dart';
import 'package:knowledge_hub/features/notes/presentation/bloc/note_editor/note_editor_state.dart';

/// Renders the save-status copy/color for whichever [NoteEditorState]
/// subclass is currently active (Requirements 3.5-3.7). Which subclass is
/// active *is* the save status — this widget switches on `state`'s runtime
/// type rather than reading a status field off a shared state, per
/// design.md's NoteEditorBloc State Management note.
///
/// [NoteEditorInitializing] and [NoteEditorCreationFailed] are not
/// save-status scenarios (the note doesn't exist yet, or failed to be
/// created) so nothing is rendered for either — `NoteEditorPage` shows its
/// own dedicated loading/error views for those states instead.
class SaveStatusIndicatorWidget extends StatelessWidget {
  const SaveStatusIndicatorWidget({required this.state, super.key});

  final NoteEditorState state;

  @override
  Widget build(BuildContext context) {
    final _SaveStatusPresentation? presentation = switch (state) {
      NoteEditorInitializing() => null,
      NoteEditorCreationFailed() => null,
      NoteEditorNotSaved() => const _SaveStatusPresentation(
        label: 'Not saved',
        color: KnowledgeHubColors.muted,
      ),
      NoteEditorSaving() => const _SaveStatusPresentation(
        label: 'Saving…',
        color: KnowledgeHubColors.muted,
      ),
      NoteEditorSaved() => const _SaveStatusPresentation(
        label: 'Saved',
        color: KnowledgeHubColors.body,
      ),
      NoteEditorSaveFailed(:final errorMessage) => _SaveStatusPresentation(
        label: 'Save failed: $errorMessage',
        color: KnowledgeHubColors.errorText,
      ),
    };

    if (presentation == null) {
      return const SizedBox.shrink();
    }

    return Text(
      presentation.label,
      style: KnowledgeHubTextStyles.captionSm.copyWith(color: presentation.color),
    );
  }
}

class _SaveStatusPresentation {
  const _SaveStatusPresentation({required this.label, required this.color});

  final String label;
  final Color color;
}
