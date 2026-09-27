import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_colors.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_elevation.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_radii.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_spacing.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_text_styles.dart';
import 'package:knowledge_hub/core/design_system/widgets/app_text_field_widget.dart';
import 'package:knowledge_hub/core/design_system/widgets/circular_icon_button_widget.dart';
import 'package:knowledge_hub/core/design_system/widgets/primary_button_widget.dart';
import 'package:knowledge_hub/features/notes/presentation/cubit/folder/folder_cubit.dart';
import 'package:knowledge_hub/features/notes/presentation/cubit/folder/folder_state.dart';
import 'package:knowledge_hub/features/notes/presentation/view_models/folder_view_model.dart';

/// Folder-management dialog (task 5.3, Requirements 4.1, 4.2, 4.3) —
/// `design.md`'s File Structure Plan describes this exactly:
/// `folder_creation_dialog_widget.dart` "uses `app_text_field_widget.dart`
/// for the name input, surfaces `FolderCreationFailed` inline; opened from
/// `note_list_page.dart`, not a standalone page".
///
/// Assumes a [FolderCubit] is already provided above it in the widget tree
/// (`context.read`, never created here) and that it is shown via
/// `showDialog`/similar by a caller — this task's `_Boundary:` is
/// `FolderCreationDialogWidget` only. **The "launched from the note list
/// screen" trigger (a button/menu item on `NoteListPage` calling
/// `showDialog(...)`) is deliberately NOT added here** — `NoteListPage` is
/// task 5.1's already-approved/committed file, and adding a call site there
/// is not unambiguously "trivial" (it would require deciding where in that
/// screen's already-dense layout a folder-management entry point belongs,
/// which is a layout decision, not a mechanical one-line wiring change). A
/// future caller can present this dialog with `showDialog` (generic type
/// param `void`, builder returning `const FolderCreationDialogWidget()`)
/// once `FolderCubit` is available via `context.read` at that call site.
///
/// `design.md`'s only modal-presentation guidance is the `{colors.scrim}`
/// token (§"Scrim"/§"Modal scrim"): "the global modal backdrop... used on
/// date pickers, login dialogs, language picker." `KnowledgeHubColors` has
/// no `scrim` getter (confirmed absent) — per this task's own instruction,
/// that is treated as an unimplemented token gap, not something to invent
/// a hex value for here, so this dialog is shown via a plain `Dialog`
/// (relying on `showDialog`'s standard Material barrier) rather than a
/// custom-colored barrier.
class FolderCreationDialogWidget extends StatefulWidget {
  const FolderCreationDialogWidget({super.key});

  @override
  State<FolderCreationDialogWidget> createState() => _FolderCreationDialogWidgetState();
}

class _FolderCreationDialogWidgetState extends State<FolderCreationDialogWidget> {
  /// Owned locally so the field survives the Cubit's Loading -> Loaded ->
  /// CreationFailed churn without losing whatever the user has typed —
  /// [AppTextFieldWidget] requires an externally-managed controller (same
  /// reason `NoteEditorPage`, task 5.1, keeps its own `_titleController`).
  /// Unlike that page's title field, nothing here ever needs to *resync*
  /// this controller's text from Cubit-owned data — a folder name is
  /// purely user-typed input, `FolderCubit` never pushes a name back into
  /// this widget — so only the controller's identity needs to survive
  /// rebuilds, not a value-sync listener.
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleCreatePressed(BuildContext context) {
    final String name = _nameController.text.trim();
    // No design.md/Cubit-level guidance on an empty name beyond
    // `DuplicateNameFailure` handling. Guarding here (rather than letting an
    // empty/whitespace-only name reach `CreateFolderUc`) is a deliberate,
    // documented choice: `PrimaryButtonWidget.onPressed` is a non-nullable
    // `VoidCallback` (no built-in disabled affordance without modifying the
    // already-approved `core/design_system` primitive, which is out of this
    // task's boundary), so the empty-name case is handled as a silent no-op
    // guard inside the handler instead of a disabled button state.
    if (name.isEmpty) {
      return;
    }
    context.read<FolderCubit>().createFolder(name);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 420),
        padding: const EdgeInsets.all(KnowledgeHubSpacing.base),
        decoration: BoxDecoration(
          color: KnowledgeHubColors.canvas,
          borderRadius: BorderRadius.circular(KnowledgeHubRadii.md),
          boxShadow: KnowledgeHubElevation.cardHoverFloat,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Folders',
                  style: KnowledgeHubTextStyles.titleMd.copyWith(color: KnowledgeHubColors.ink),
                ),
                CircularIconButtonWidget(
                  icon: Icons.close,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: KnowledgeHubSpacing.base),
            _FolderNameField(controller: _nameController),
            const SizedBox(height: KnowledgeHubSpacing.sm),
            PrimaryButtonWidget(
              label: 'Create',
              onPressed: () => _handleCreatePressed(context),
            ),
            const SizedBox(height: KnowledgeHubSpacing.lg),
            const _FolderListSection(),
          ],
        ),
      ),
    );
  }
}

/// The name text field, scoped with its own [BlocSelector] so it only
/// rebuilds when the field-level error message actually changes (not on
/// every folder-list emission) — [FolderCreationFailed.errorMessage] is the
/// field-level message this task's Observable requires;
/// `null` for every other state.
class _FolderNameField extends StatelessWidget {
  const _FolderNameField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<FolderCubit, FolderState, String?>(
      selector: (FolderState state) => switch (state) {
        FolderCreationFailed(:final errorMessage) => errorMessage,
        FolderListLoading() || FolderListLoaded() || FolderListLoadFailed() => null,
      },
      builder: (BuildContext context, String? creationErrorMessage) {
        return AppTextFieldWidget(
          controller: controller,
          labelText: 'New folder',
          hintText: 'Folder name',
          errorText: creationErrorMessage,
        );
      },
    );
  }
}

enum _FolderListSectionMode { loading, loadFailed, loaded }

@immutable
class _FolderListSectionViewInfo {
  const _FolderListSectionViewInfo({
    required this.mode,
    required this.folders,
    this.loadFailedMessage,
  });

  final _FolderListSectionMode mode;
  final List<FolderViewModel> folders;
  final String? loadFailedMessage;

  @override
  bool operator ==(Object other) =>
      other is _FolderListSectionViewInfo &&
      other.mode == mode &&
      other.folders == folders &&
      other.loadFailedMessage == loadFailedMessage;

  @override
  int get hashCode => Object.hash(mode, folders, loadFailedMessage);
}

_FolderListSectionViewInfo _listSectionViewInfoFor(FolderState state) => switch (state) {
  FolderListLoading() => const _FolderListSectionViewInfo(
    mode: _FolderListSectionMode.loading,
    folders: <FolderViewModel>[],
  ),
  FolderListLoadFailed(:final errorMessage) => _FolderListSectionViewInfo(
    mode: _FolderListSectionMode.loadFailed,
    folders: const <FolderViewModel>[],
    loadFailedMessage: errorMessage,
  ),
  FolderListLoaded(:final folders) => _FolderListSectionViewInfo(
    mode: _FolderListSectionMode.loaded,
    folders: folders,
  ),
  FolderCreationFailed(:final currentFolders) => _FolderListSectionViewInfo(
    mode: _FolderListSectionMode.loaded,
    folders: currentFolders,
  ),
};

/// The existing-folder list plus per-row delete action, or the
/// loading/load-failed presentation in its place. `FolderListLoadFailed` (a
/// broken live-watch stream) gets its own distinct, visible error
/// presentation here — deliberately NOT the field-level [AppTextFieldWidget]
/// `errorText` treatment [_FolderNameField] uses for [FolderCreationFailed],
/// since a stream failure is not a `createFolder` action failure.
class _FolderListSection extends StatelessWidget {
  const _FolderListSection();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<FolderCubit, FolderState, _FolderListSectionViewInfo>(
      selector: _listSectionViewInfoFor,
      builder: (BuildContext context, _FolderListSectionViewInfo viewInfo) {
        return switch (viewInfo.mode) {
          _FolderListSectionMode.loading => const _FolderListLoadingView(),
          _FolderListSectionMode.loadFailed => _FolderListLoadFailedView(
            message: viewInfo.loadFailedMessage ?? '',
          ),
          _FolderListSectionMode.loaded => _FolderListView(folders: viewInfo.folders),
        };
      },
    );
  }
}

class _FolderListLoadingView extends StatelessWidget {
  const _FolderListLoadingView();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: KnowledgeHubSpacing.lg),
      child: Center(child: CircularProgressIndicator(color: KnowledgeHubColors.ink)),
    );
  }
}

class _FolderListLoadFailedView extends StatelessWidget {
  const _FolderListLoadFailedView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: KnowledgeHubSpacing.base),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.error_outline, color: KnowledgeHubColors.errorText, size: 32),
          const SizedBox(height: KnowledgeHubSpacing.sm),
          Text(
            message,
            textAlign: TextAlign.center,
            style: KnowledgeHubTextStyles.bodyMd.copyWith(color: KnowledgeHubColors.errorText),
          ),
        ],
      ),
    );
  }
}

/// Renders once [FolderListLoaded]/[FolderCreationFailed] has a (possibly
/// empty) folder list. `design.md` gives no bounded-height spec for this
/// dialog's list area — `_maxListHeight` is a documented, pragmatic choice
/// (not a design.md token) so the dialog doesn't grow unbounded with a long
/// folder list; the same kind of disclosed gap-filling `CircularIconButtonWidget`
/// already documents for its own diameter.
class _FolderListView extends StatelessWidget {
  const _FolderListView({required this.folders});

  final List<FolderViewModel> folders;

  static const double _maxListHeight = 240;

  @override
  Widget build(BuildContext context) {
    if (folders.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: KnowledgeHubSpacing.base),
        child: Center(
          child: Text(
            'No folders yet',
            style: KnowledgeHubTextStyles.bodyMd.copyWith(color: KnowledgeHubColors.muted),
          ),
        ),
      );
    }
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: _maxListHeight),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: folders.length,
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: KnowledgeHubSpacing.sm),
        itemBuilder: (BuildContext context, int index) =>
            _FolderListRow(folder: folders[index]),
      ),
    );
  }
}

class _FolderListRow extends StatelessWidget {
  const _FolderListRow({required this.folder});

  final FolderViewModel folder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: KnowledgeHubSpacing.base,
        vertical: KnowledgeHubSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: KnowledgeHubColors.surfaceSoft,
        borderRadius: BorderRadius.circular(KnowledgeHubRadii.sm),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              folder.name,
              style: KnowledgeHubTextStyles.bodyMd.copyWith(color: KnowledgeHubColors.ink),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: KnowledgeHubSpacing.sm),
          CircularIconButtonWidget(
            icon: Icons.delete_outline,
            onPressed: () => context.read<FolderCubit>().deleteFolder(folder.folderId),
          ),
        ],
      ),
    );
  }
}
