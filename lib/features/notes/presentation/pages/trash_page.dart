import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_colors.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_elevation.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_radii.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_spacing.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_text_styles.dart';
import 'package:knowledge_hub/core/design_system/widgets/primary_button_widget.dart';
import 'package:knowledge_hub/core/design_system/widgets/secondary_button_widget.dart';
import 'package:knowledge_hub/core/design_system/widgets/tertiary_text_button_widget.dart';
import 'package:knowledge_hub/features/notes/presentation/cubit/trash/trash_cubit.dart';
import 'package:knowledge_hub/features/notes/presentation/cubit/trash/trash_state.dart';
import 'package:knowledge_hub/features/notes/presentation/view_models/trashed_note_view_model.dart';

/// Presents trashed notes with per-item restore/permanent-delete actions
/// (task 5.5, Requirements 7.1-7.4). Assumes a [TrashCubit] is already
/// provided above it in the widget tree (`context.read`, never created
/// here) — actual DI/navigation wiring is a later task (6.1/6.2), the same
/// assumption `NoteListPage`/`NoteEditorPage` (tasks 5.1/5.2) make for their
/// own Blocs/Cubits.
///
/// `restore`/`permanentlyDelete` do not need to be followed by any
/// manual list mutation here — `TrashCubit`'s constructor already holds a
/// live `WatchFilteredNotesUc(lifecycleScope: trash)` subscription, so a
/// successful action is reflected the moment that subscription re-emits
/// (the note has left the trash-scoped result set). This page's job is only
/// to call the two Cubit methods and let the `BlocBuilder` below react.
///
/// **No localization infrastructure exists in this project** (confirmed
/// absent, same as tasks 5.1-5.4) — hardcoded `String` literals are the
/// established, accepted pattern for all UI copy here.
class TrashPage extends StatelessWidget {
  const TrashPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  Text(
                    'Trash',
                    style: KnowledgeHubTextStyles.titleMd.copyWith(color: KnowledgeHubColors.ink),
                  ),
                ],
              ),
              const SizedBox(height: KnowledgeHubSpacing.base),
              const Expanded(child: _TrashBody()),
            ],
          ),
        ),
      ),
    );
  }
}

/// Switches on all four [TrashState] subclasses. A single top-level
/// [BlocBuilder] is sufficient here (unlike `NoteListPage`'s more elaborate
/// `BlocSelector` scoping) — this page has exactly one Cubit and no sibling
/// widgets whose rebuilds would need to be shielded from a `TrashState`
/// emission.
class _TrashBody extends StatelessWidget {
  const _TrashBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrashCubit, TrashState>(
      builder: (BuildContext context, TrashState state) => switch (state) {
        TrashLoading() => const _CenteredLoadingIndicatorView(),
        TrashListLoadFailed(:final String errorMessage) => _ErrorMessageView(
          message: errorMessage,
        ),
        TrashLoaded(:final List<TrashedNoteViewModel> items) =>
          items.isEmpty ? const _EmptyTrashView() : _TrashListView(items: items),
        TrashActionFailed(
          :final List<TrashedNoteViewModel> currentItems,
          :final String errorMessage,
        ) =>
          _TrashActionFailedView(items: currentItems, errorMessage: errorMessage),
      },
    );
  }
}

class _CenteredLoadingIndicatorView extends StatelessWidget {
  const _CenteredLoadingIndicatorView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator(color: KnowledgeHubColors.ink));
  }
}

/// A plain, non-error empty-list presentation for a legitimately empty
/// trash — muted text only, no icon, deliberately distinct from
/// [_ErrorMessageView]'s `errorText`-colored treatment (mirrors
/// `NoteListPage`'s own `_EmptyNoteListView` convention).
class _EmptyTrashView extends StatelessWidget {
  const _EmptyTrashView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Trash is empty',
        style: KnowledgeHubTextStyles.bodyMd.copyWith(color: KnowledgeHubColors.muted),
      ),
    );
  }
}

/// A visible, `errorText`-colored error presentation for
/// [TrashListLoadFailed] — the live-watch stream itself failed, so no item
/// list is shown at all (mirrors `NoteListPage`'s own `_ErrorMessageView`
/// convention for `NoteListLoadFailed`).
class _ErrorMessageView extends StatelessWidget {
  const _ErrorMessageView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(KnowledgeHubSpacing.base),
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
      ),
    );
  }
}

/// [TrashActionFailed]'s presentation: a dismissible-looking, non-blocking
/// banner above the SAME item list [TrashLoaded] would render (using
/// [TrashState.currentItems]'s carried-forward list, per that state's own
/// contract) — the failed restore/delete must not blank an otherwise
/// perfectly usable trash list. The banner is not actually dismissible (no
/// design.md-documented dismiss affordance to build against) — it simply
/// stops being shown once the next `TrashState` emission moves the Cubit
/// out of `TrashActionFailed` (e.g. the live watch stream's next emission,
/// or a subsequent successful action).
class _TrashActionFailedView extends StatelessWidget {
  const _TrashActionFailedView({required this.items, required this.errorMessage});

  final List<TrashedNoteViewModel> items;
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _ActionFailedBanner(message: errorMessage),
        const SizedBox(height: KnowledgeHubSpacing.sm),
        Expanded(
          child: items.isEmpty ? const _EmptyTrashView() : _TrashListView(items: items),
        ),
      ],
    );
  }
}

class _ActionFailedBanner extends StatelessWidget {
  const _ActionFailedBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(KnowledgeHubSpacing.sm),
      decoration: BoxDecoration(
        color: KnowledgeHubColors.canvas,
        border: Border.all(color: KnowledgeHubColors.errorText),
        borderRadius: BorderRadius.circular(KnowledgeHubRadii.sm),
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.error_outline, color: KnowledgeHubColors.errorText, size: 20),
          const SizedBox(width: KnowledgeHubSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: KnowledgeHubTextStyles.bodySm.copyWith(color: KnowledgeHubColors.errorText),
            ),
          ),
        ],
      ),
    );
  }
}

/// Renders the trashed-item list once it is known to be non-empty (either
/// [TrashLoaded] or [TrashActionFailed]'s carried-forward list). Each row is
/// a plain [_TrashListItemWidget] fed a [TrashedNoteViewModel] constructor
/// argument — no per-item `BlocBuilder`/`BlocSelector`, per this codebase's
/// Bloc-in-lists performance conventions (mirrors `NoteListPage`'s
/// `_NoteListView`).
class _TrashListView extends StatelessWidget {
  const _TrashListView({required this.items});

  final List<TrashedNoteViewModel> items;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) =>
          _TrashListItemWidget(viewModel: items[index]),
    );
  }
}

/// A single trashed-note row: title, [TrashedNoteViewModel.daysRemainingLabel]
/// as the meta line, and the two per-item actions (Requirements 7.2, 7.3).
/// Visually mirrors `NoteListItemWidget`'s row shape (`surfaceSoft` fill,
/// `KnowledgeHubRadii.md`, `base` padding) for consistency with the rest of
/// this feature's list rows.
///
/// **Action widget choice**: design.md's resolved gap table maps
/// "delete/restore actions" onto `PrimaryButtonWidget`/`SecondaryButtonWidget`/
/// `TertiaryTextButtonWidget` without pinning a specific one to each verb.
/// "Restore" (a constructive, primary-ish action for this screen) uses
/// [SecondaryButtonWidget] (outlined, medium prominence); "Delete
/// permanently" uses [TertiaryTextButtonWidget] (lowest prominence, plain
/// text) since it is placed behind a confirmation step below and shouldn't
/// visually compete with Restore for attention.
///
/// **Confirmation-before-destructive-action decision**: "Delete permanently"
/// is irreversible (Requirement 7.3 removes the note outright, unlike
/// "Restore" or a soft trash-delete), so tapping it opens
/// [_PermanentDeleteConfirmationDialog] rather than calling
/// `TrashCubit.permanentlyDelete` directly. "Restore" is reversible (the
/// note can always be trashed again) and has no such confirmation step.
class _TrashListItemWidget extends StatelessWidget {
  const _TrashListItemWidget({required this.viewModel});

  final TrashedNoteViewModel viewModel;

  Future<void> _handleDeletePermanentlyPressed(BuildContext context) async {
    final TrashCubit trashCubit = context.read<TrashCubit>();
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) =>
          _PermanentDeleteConfirmationDialog(noteTitle: viewModel.title),
    );
    if (confirmed ?? false) {
      unawaited(trashCubit.permanentlyDelete(viewModel.noteId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final TrashCubit trashCubit = context.read<TrashCubit>();

    return Padding(
      padding: const EdgeInsets.only(bottom: KnowledgeHubSpacing.sm),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(KnowledgeHubSpacing.base),
        decoration: BoxDecoration(
          color: KnowledgeHubColors.surfaceSoft,
          borderRadius: BorderRadius.circular(KnowledgeHubRadii.md),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              viewModel.title.isEmpty ? 'Untitled note' : viewModel.title,
              style: KnowledgeHubTextStyles.titleMd.copyWith(color: KnowledgeHubColors.ink),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: KnowledgeHubSpacing.xs),
            Text(
              viewModel.daysRemainingLabel,
              style: KnowledgeHubTextStyles.bodySm.copyWith(color: KnowledgeHubColors.muted),
            ),
            const SizedBox(height: KnowledgeHubSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TertiaryTextButtonWidget(
                  label: 'Delete permanently',
                  onPressed: () => unawaited(_handleDeletePermanentlyPressed(context)),
                ),
                const SizedBox(width: KnowledgeHubSpacing.sm),
                SecondaryButtonWidget(
                  label: 'Restore',
                  onPressed: () => unawaited(trashCubit.restore(viewModel.noteId)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// A confirmation dialog gating [TrashCubit.permanentlyDelete] — see
/// [_TrashListItemWidget]'s doc comment for why "Delete permanently" alone,
/// unlike "Restore", warrants this extra step. Styled the same way
/// `FolderCreationDialogWidget` (task 5.3) styles its own modal: a plain
/// `Dialog` (no `{colors.scrim}` token exists in `KnowledgeHubColors` today,
/// confirmed absent, so this relies on `showDialog`'s standard Material
/// barrier rather than inventing a scrim color) wrapping a `canvas`-filled,
/// `KnowledgeHubRadii.md`-rounded, `KnowledgeHubElevation.cardHoverFloat`
/// container.
class _PermanentDeleteConfirmationDialog extends StatelessWidget {
  const _PermanentDeleteConfirmationDialog({required this.noteTitle});

  final String noteTitle;

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
            Text(
              'Delete permanently?',
              style: KnowledgeHubTextStyles.titleMd.copyWith(color: KnowledgeHubColors.ink),
            ),
            const SizedBox(height: KnowledgeHubSpacing.sm),
            Text(
              '"${noteTitle.isEmpty ? 'Untitled note' : noteTitle}" will be permanently deleted '
              'and cannot be recovered.',
              style: KnowledgeHubTextStyles.bodyMd.copyWith(color: KnowledgeHubColors.body),
            ),
            const SizedBox(height: KnowledgeHubSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SecondaryButtonWidget(
                  label: 'Cancel',
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                const SizedBox(width: KnowledgeHubSpacing.sm),
                PrimaryButtonWidget(
                  label: 'Delete',
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
