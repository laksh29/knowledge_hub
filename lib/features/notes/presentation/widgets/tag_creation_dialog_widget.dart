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
import 'package:knowledge_hub/features/notes/presentation/cubit/tag/tag_cubit.dart';
import 'package:knowledge_hub/features/notes/presentation/cubit/tag/tag_state.dart';
import 'package:knowledge_hub/features/notes/presentation/view_models/tag_view_model.dart';

/// Tag-management dialog (task 5.4, Requirement 5.1) — `design.md`'s File
/// Structure Plan describes this exactly: `tag_creation_dialog_widget.dart`
/// "mirrors `folder_creation_dialog_widget.dart` for tags; opened from
/// `note_list_page.dart`".
///
/// Assumes a [TagCubit] is already provided above it in the widget tree
/// (`context.read`, never created here) and that it is shown via
/// `showDialog`/similar by a caller — this task's `_Boundary:` is
/// `TagCreationDialogWidget` only. **The "launched from the note list
/// screen" trigger (a button/menu item on `NoteListPage` calling
/// `showDialog(...)`) is deliberately NOT added here** — `NoteListPage` is
/// task 5.1's already-approved/committed file, and adding a call site there
/// is not unambiguously "trivial" (it would require deciding where in that
/// screen's already-dense layout a tag-management entry point belongs,
/// which is a layout decision, not a mechanical one-line wiring change). A
/// future caller can present this dialog with `showDialog` (generic type
/// param `void`, builder returning `const TagCreationDialogWidget()`)
/// once `TagCubit` is available via `context.read` at that call site.
///
/// `design.md`'s only modal-presentation guidance is the `{colors.scrim}`
/// token (§"Scrim"/§"Modal scrim"): "the global modal backdrop... used on
/// date pickers, login dialogs, language picker." `KnowledgeHubColors` has
/// no `scrim` getter (confirmed absent) — per this task's own instruction,
/// that is treated as an unimplemented token gap, not something to invent
/// a hex value for here, so this dialog is shown via a plain `Dialog`
/// (relying on `showDialog`'s standard Material barrier) rather than a
/// custom-colored barrier.
class TagCreationDialogWidget extends StatefulWidget {
  const TagCreationDialogWidget({super.key});

  @override
  State<TagCreationDialogWidget> createState() => _TagCreationDialogWidgetState();
}

class _TagCreationDialogWidgetState extends State<TagCreationDialogWidget> {
  /// Owned locally so the field survives the Cubit's Loading -> Loaded ->
  /// CreationFailed churn without losing whatever the user has typed —
  /// [AppTextFieldWidget] requires an externally-managed controller (same
  /// reason `FolderCreationDialogWidget` keeps its own `_nameController`).
  /// A tag name is purely user-typed input, `TagCubit` never pushes a name
  /// back into this widget, so only the controller's identity needs to
  /// survive rebuilds, not a value-sync listener.
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
    // empty/whitespace-only name reach `CreateTagUc`) is a deliberate,
    // documented choice: `PrimaryButtonWidget.onPressed` is a non-nullable
    // `VoidCallback` (no built-in disabled affordance without modifying the
    // already-approved `core/design_system` primitive, which is out of this
    // task's boundary), so the empty-name case is handled as a silent no-op
    // guard inside the handler instead of a disabled button state.
    if (name.isEmpty) {
      return;
    }
    context.read<TagCubit>().createTag(name);
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
                  'Tags',
                  style: KnowledgeHubTextStyles.titleMd.copyWith(color: KnowledgeHubColors.ink),
                ),
                CircularIconButtonWidget(
                  icon: Icons.close,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: KnowledgeHubSpacing.base),
            _TagNameField(controller: _nameController),
            const SizedBox(height: KnowledgeHubSpacing.sm),
            PrimaryButtonWidget(
              label: 'Create',
              onPressed: () => _handleCreatePressed(context),
            ),
            const SizedBox(height: KnowledgeHubSpacing.lg),
            const _TagListSection(),
          ],
        ),
      ),
    );
  }
}

/// The name text field, scoped with its own [BlocSelector] so it only
/// rebuilds when the field-level error message actually changes (not on
/// every tag-list emission) — [TagCreationFailed.errorMessage] is the
/// field-level message this task's Observable requires;
/// `null` for every other state.
class _TagNameField extends StatelessWidget {
  const _TagNameField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<TagCubit, TagState, String?>(
      selector: (TagState state) => switch (state) {
        TagCreationFailed(:final errorMessage) => errorMessage,
        TagListLoading() || TagListLoaded() || TagListLoadFailed() => null,
      },
      builder: (BuildContext context, String? creationErrorMessage) {
        return AppTextFieldWidget(
          controller: controller,
          labelText: 'New tag',
          hintText: 'Tag name',
          errorText: creationErrorMessage,
        );
      },
    );
  }
}

enum _TagListSectionMode { loading, loadFailed, loaded }

@immutable
class _TagListSectionViewInfo {
  const _TagListSectionViewInfo({
    required this.mode,
    required this.tags,
    this.loadFailedMessage,
  });

  final _TagListSectionMode mode;
  final List<TagViewModel> tags;
  final String? loadFailedMessage;

  @override
  bool operator ==(Object other) =>
      other is _TagListSectionViewInfo &&
      other.mode == mode &&
      other.tags == tags &&
      other.loadFailedMessage == loadFailedMessage;

  @override
  int get hashCode => Object.hash(mode, tags, loadFailedMessage);
}

_TagListSectionViewInfo _listSectionViewInfoFor(TagState state) => switch (state) {
  TagListLoading() => const _TagListSectionViewInfo(
    mode: _TagListSectionMode.loading,
    tags: <TagViewModel>[],
  ),
  TagListLoadFailed(:final errorMessage) => _TagListSectionViewInfo(
    mode: _TagListSectionMode.loadFailed,
    tags: const <TagViewModel>[],
    loadFailedMessage: errorMessage,
  ),
  TagListLoaded(:final tags) => _TagListSectionViewInfo(
    mode: _TagListSectionMode.loaded,
    tags: tags,
  ),
  TagCreationFailed(:final currentTags) => _TagListSectionViewInfo(
    mode: _TagListSectionMode.loaded,
    tags: currentTags,
  ),
};

/// The existing-tag list plus per-row delete action, or the
/// loading/load-failed presentation in its place. `TagListLoadFailed` (a
/// broken live-watch stream) gets its own distinct, visible error
/// presentation here — deliberately NOT the field-level [AppTextFieldWidget]
/// `errorText` treatment [_TagNameField] uses for [TagCreationFailed],
/// since a stream failure is not a `createTag` action failure.
class _TagListSection extends StatelessWidget {
  const _TagListSection();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<TagCubit, TagState, _TagListSectionViewInfo>(
      selector: _listSectionViewInfoFor,
      builder: (BuildContext context, _TagListSectionViewInfo viewInfo) {
        return switch (viewInfo.mode) {
          _TagListSectionMode.loading => const _TagListLoadingView(),
          _TagListSectionMode.loadFailed => _TagListLoadFailedView(
            message: viewInfo.loadFailedMessage ?? '',
          ),
          _TagListSectionMode.loaded => _TagListView(tags: viewInfo.tags),
        };
      },
    );
  }
}

class _TagListLoadingView extends StatelessWidget {
  const _TagListLoadingView();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: KnowledgeHubSpacing.lg),
      child: Center(child: CircularProgressIndicator(color: KnowledgeHubColors.ink)),
    );
  }
}

class _TagListLoadFailedView extends StatelessWidget {
  const _TagListLoadFailedView({required this.message});

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

/// Renders once [TagListLoaded]/[TagCreationFailed] has a (possibly
/// empty) tag list. `design.md` gives no bounded-height spec for this
/// dialog's list area — `_maxListHeight` is a documented, pragmatic choice
/// (not a design.md token) so the dialog doesn't grow unbounded with a long
/// tag list; the same kind of disclosed gap-filling `CircularIconButtonWidget`
/// already documents for its own diameter.
class _TagListView extends StatelessWidget {
  const _TagListView({required this.tags});

  final List<TagViewModel> tags;

  static const double _maxListHeight = 240;

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: KnowledgeHubSpacing.base),
        child: Center(
          child: Text(
            'No tags yet',
            style: KnowledgeHubTextStyles.bodyMd.copyWith(color: KnowledgeHubColors.muted),
          ),
        ),
      );
    }
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: _maxListHeight),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: tags.length,
        separatorBuilder: (BuildContext context, int index) =>
            const SizedBox(height: KnowledgeHubSpacing.sm),
        itemBuilder: (BuildContext context, int index) => _TagListRow(tag: tags[index]),
      ),
    );
  }
}

class _TagListRow extends StatelessWidget {
  const _TagListRow({required this.tag});

  final TagViewModel tag;

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
              tag.name,
              style: KnowledgeHubTextStyles.bodyMd.copyWith(color: KnowledgeHubColors.ink),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: KnowledgeHubSpacing.sm),
          CircularIconButtonWidget(
            icon: Icons.delete_outline,
            onPressed: () => context.read<TagCubit>().deleteTag(tag.tagId),
          ),
        ],
      ),
    );
  }
}
