import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_colors.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_spacing.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_text_styles.dart';
import 'package:knowledge_hub/core/design_system/widgets/app_text_field_widget.dart';
import 'package:knowledge_hub/core/design_system/widgets/primary_button_widget.dart';
import 'package:knowledge_hub/core/design_system/widgets/tertiary_text_button_widget.dart';
import 'package:knowledge_hub/features/notes/presentation/bloc/note_editor/note_editor_bloc.dart';
import 'package:knowledge_hub/features/notes/presentation/bloc/note_editor/note_editor_event.dart';
import 'package:knowledge_hub/features/notes/presentation/bloc/note_editor/note_editor_state.dart';
import 'package:knowledge_hub/features/notes/presentation/view_models/note_editor_view_model.dart';
import 'package:knowledge_hub/features/notes/presentation/widgets/code_block_highlighted_text_widget.dart';
import 'package:knowledge_hub/features/notes/presentation/widgets/save_status_indicator_widget.dart';

/// Presents distinct title/body editing for a single note (Requirements
/// 1.1, 1.2, 2.1, 2.2) plus the save-status sequence (3.5-3.7). Assumes a
/// [NoteEditorBloc] is already provided above it in the widget tree via
/// `BlocProvider` — actual DI/navigation wiring is a later task (6.1/6.2).
class NoteEditorPage extends StatefulWidget {
  const NoteEditorPage({super.key});

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  /// Owned locally (not re-read from the Bloc's [NoteEditorViewModel] every
  /// build) so that typing isn't fought by the Bloc's own saving -> saved
  /// state churn after every keystroke. [AppTextFieldWidget] requires an
  /// externally-managed controller, so it must live here rather than inside
  /// a child widget that could be rebuilt/recreated.
  final TextEditingController _titleController = TextEditingController();

  /// The `noteId` whose content the controllers currently reflect. Only a
  /// transition to a genuinely different `noteId` (i.e. first successful
  /// note creation) re-syncs [_titleController.text] / [_bodyInitialText] —
  /// this is what stops mid-typing cursor resets caused by the Bloc's own
  /// not-saved -> saving -> saved transitions.
  String? _loadedNoteId;

  /// [CodeBlockHighlightedTextWidget] wraps a package `StatefulWidget` that
  /// reads its `initialText` exactly once, at controller creation — it has
  /// no external controller to manage directly. Content resync is instead
  /// achieved by changing the widget's `Key` (keyed by `_loadedNoteId`),
  /// which forces Flutter to discard and recreate that internal state; this
  /// field is the `initialText` captured at that same sync point.
  String _bodyInitialText = '';

  @override
  void initState() {
    super.initState();
    context.read<NoteEditorBloc>().add(const NoteEditorEvent.started());
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _syncControllersFromViewModel(NoteEditorViewModel viewModel) {
    setState(() {
      _loadedNoteId = viewModel.noteId;
      _titleController.text = viewModel.title;
      _bodyInitialText = viewModel.body;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NoteEditorBloc, NoteEditorState>(
      listenWhen: (NoteEditorState previous, NoteEditorState current) {
        final NoteEditorViewModel? currentViewModel = current.currentVm;
        if (currentViewModel == null) return false;
        return currentViewModel.noteId != _loadedNoteId;
      },
      listener: (BuildContext context, NoteEditorState state) {
        final NoteEditorViewModel? viewModel = state.currentVm;
        if (viewModel != null) _syncControllersFromViewModel(viewModel);
      },
      child: BlocSelector<NoteEditorBloc, NoteEditorState, _EditorPageViewInfo>(
        selector: _viewInfoFor,
        builder: (BuildContext context, _EditorPageViewInfo viewInfo) {
          return switch (viewInfo.mode) {
            _EditorPageMode.initializing => const _NoteEditorLoadingView(),
            _EditorPageMode.creationFailed => _NoteEditorCreationFailedView(
              message: viewInfo.creationFailedMessage ?? '',
              onRetry: () => context.read<NoteEditorBloc>().add(const NoteEditorEvent.started()),
            ),
            _EditorPageMode.editor => _NoteEditorContentView(
              titleController: _titleController,
              bodyInitialText: _bodyInitialText,
              bodyFieldKey: ValueKey<String>(_loadedNoteId ?? 'note-editor-body-draft'),
            ),
          };
        },
      ),
    );
  }
}

enum _EditorPageMode { initializing, creationFailed, editor }

@immutable
class _EditorPageViewInfo {
  const _EditorPageViewInfo({required this.mode, this.creationFailedMessage});

  final _EditorPageMode mode;
  final String? creationFailedMessage;

  @override
  bool operator ==(Object other) =>
      other is _EditorPageViewInfo &&
      other.mode == mode &&
      other.creationFailedMessage == creationFailedMessage;

  @override
  int get hashCode => Object.hash(mode, creationFailedMessage);
}

_EditorPageViewInfo _viewInfoFor(NoteEditorState state) => switch (state) {
  NoteEditorInitializing() => const _EditorPageViewInfo(mode: _EditorPageMode.initializing),
  NoteEditorCreationFailed(:final message) => _EditorPageViewInfo(
    mode: _EditorPageMode.creationFailed,
    creationFailedMessage: message,
  ),
  NoteEditorNotSaved() ||
  NoteEditorSaving() ||
  NoteEditorSaved() ||
  NoteEditorSaveFailed() => const _EditorPageViewInfo(mode: _EditorPageMode.editor),
};

class _NoteEditorLoadingView extends StatelessWidget {
  const _NoteEditorLoadingView();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: KnowledgeHubColors.canvas,
      body: Center(child: CircularProgressIndicator(color: KnowledgeHubColors.ink)),
    );
  }
}

class _NoteEditorCreationFailedView extends StatelessWidget {
  const _NoteEditorCreationFailedView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KnowledgeHubColors.canvas,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(KnowledgeHubSpacing.base),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                message,
                textAlign: TextAlign.center,
                style: KnowledgeHubTextStyles.bodyMd.copyWith(color: KnowledgeHubColors.ink),
              ),
              const SizedBox(height: KnowledgeHubSpacing.base),
              PrimaryButtonWidget(label: 'Retry', onPressed: onRetry),
            ],
          ),
        ),
      ),
    );
  }
}

/// Renders the title/body editor plus the top back/save-status row and the
/// bottom manual-save action. Only rebuilt when [_EditorPageMode] actually
/// changes (see the [BlocSelector] above) — the not-saved -> saving ->
/// saved churn triggered by every keystroke does not rebuild this subtree;
/// only the nested [SaveStatusIndicatorWidget] below reacts to that.
class _NoteEditorContentView extends StatelessWidget {
  const _NoteEditorContentView({
    required this.titleController,
    required this.bodyInitialText,
    required this.bodyFieldKey,
  });

  final TextEditingController titleController;
  final String bodyInitialText;
  final Key bodyFieldKey;

  @override
  Widget build(BuildContext context) {
    final NoteEditorBloc bloc = context.read<NoteEditorBloc>();

    return Scaffold(
      backgroundColor: KnowledgeHubColors.canvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(KnowledgeHubSpacing.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TertiaryTextButtonWidget(
                    label: 'Back',
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  BlocBuilder<NoteEditorBloc, NoteEditorState>(
                    builder: (BuildContext context, NoteEditorState state) =>
                        SaveStatusIndicatorWidget(state: state),
                  ),
                ],
              ),
              const SizedBox(height: KnowledgeHubSpacing.base),
              AppTextFieldWidget(
                controller: titleController,
                labelText: 'Title',
                hintText: 'Untitled note',
                onChanged: (String title) => bloc.add(NoteEditorEvent.titleChanged(title)),
              ),
              const SizedBox(height: KnowledgeHubSpacing.base),
              Expanded(
                child: CodeBlockHighlightedTextWidget(
                  key: bodyFieldKey,
                  initialText: bodyInitialText,
                  hintText: 'Start writing in Markdown…',
                  onChanged: (String body) => bloc.add(NoteEditorEvent.bodyChanged(body)),
                ),
              ),
              const SizedBox(height: KnowledgeHubSpacing.base),
              PrimaryButtonWidget(
                label: 'Save',
                onPressed: () => bloc.add(const NoteEditorEvent.manualSaveRequested()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
