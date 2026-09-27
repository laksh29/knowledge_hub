import 'dart:async';

import 'package:app_lifecycle_service/app_lifecycle_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_colors.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_radii.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_spacing.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_text_styles.dart';
import 'package:knowledge_hub/core/design_system/widgets/circular_icon_button_widget.dart';
import 'package:knowledge_hub/core/di/injection.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note_list_filter.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/create_note_uc.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/move_note_to_trash_uc.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/permanently_delete_note_uc.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/restore_note_from_trash_uc.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/save_note_content_uc.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/watch_filtered_notes_uc.dart';
import 'package:knowledge_hub/features/notes/presentation/bloc/note_editor/note_editor_bloc.dart';
import 'package:knowledge_hub/features/notes/presentation/bloc/search/search_bloc.dart';
import 'package:knowledge_hub/features/notes/presentation/bloc/search/search_event.dart';
import 'package:knowledge_hub/features/notes/presentation/bloc/search/search_state.dart';
import 'package:knowledge_hub/features/notes/presentation/cubit/folder/folder_cubit.dart';
import 'package:knowledge_hub/features/notes/presentation/cubit/folder/folder_state.dart';
import 'package:knowledge_hub/features/notes/presentation/cubit/note_list/note_list_cubit.dart';
import 'package:knowledge_hub/features/notes/presentation/cubit/note_list/note_list_state.dart';
import 'package:knowledge_hub/features/notes/presentation/cubit/tag/tag_cubit.dart';
import 'package:knowledge_hub/features/notes/presentation/cubit/tag/tag_state.dart';
import 'package:knowledge_hub/features/notes/presentation/cubit/trash/trash_cubit.dart';
import 'package:knowledge_hub/features/notes/presentation/pages/note_editor_page.dart';
import 'package:knowledge_hub/features/notes/presentation/pages/trash_page.dart';
import 'package:knowledge_hub/features/notes/presentation/view_models/folder_view_model.dart';
import 'package:knowledge_hub/features/notes/presentation/view_models/note_list_item_view_model.dart';
import 'package:knowledge_hub/features/notes/presentation/view_models/note_search_result_view_model.dart';
import 'package:knowledge_hub/features/notes/presentation/view_models/tag_view_model.dart';
import 'package:knowledge_hub/features/notes/presentation/widgets/folder_chip_widget.dart';
import 'package:knowledge_hub/features/notes/presentation/widgets/folder_creation_dialog_widget.dart';
import 'package:knowledge_hub/features/notes/presentation/widgets/highlighted_snippet_text_widget.dart';
import 'package:knowledge_hub/features/notes/presentation/widgets/note_list_item_widget.dart';
import 'package:knowledge_hub/features/notes/presentation/widgets/search_bar_widget.dart';
import 'package:knowledge_hub/features/notes/presentation/widgets/tag_chip_widget.dart';
import 'package:knowledge_hub/features/notes/presentation/widgets/tag_creation_dialog_widget.dart';
import 'package:knowledge_hub/features/notes/presentation/widgets/tag_filter_mode_toggle_widget.dart';

/// Presents the note list, folder/tag filtering, and embedded search as a
/// single screen (task 5.2, Requirements 4.4, 5.2, 5.3, 5.4, 5.5, 6.1, 6.2,
/// 6.4, 6.5, 9.1, 9.2, 10.1). Assumes a [NoteListCubit], [SearchBloc],
/// [FolderCubit], and [TagCubit] are already provided above it in the
/// widget tree (`context.read`, never created here) — actual DI-graph
/// *assembly* (wiring the concrete `BlocProvider`s into `main.dart`/a
/// router) is a later task (6.1/6.2), same assumption `NoteEditorPage`
/// (task 5.1) makes for its own Bloc. `FolderCubit`/`TagCubit` are
/// themselves already fully implemented, tested, and approved (tasks
/// 4.5/4.6) — this page *consumes* them the same way it already consumes
/// `NoteListCubit`/`SearchBloc`, it does not need to *build* them.
///
/// **Folder-name gap on `NoteListItemWidget`'s meta line is unrelated to
/// this**: `NoteListItemViewModel` genuinely has no resolved folder-name
/// field (a ViewModel data gap, not a missing-but-available Cubit) — see
/// that widget's own doc comment.
///
/// **No localization infrastructure exists in this project** (confirmed
/// absent, same as task 5.1's `NoteEditorPage`) — hardcoded `String`
/// literals are the established, accepted pattern for all UI copy here.
///
/// **Navigation entry points (task 6.2)**: the header row's three
/// [CircularIconButtonWidget]s open the folder dialog, the tag dialog, and
/// `TrashPage` (pushed with its own page-scoped `BlocProvider<TrashCubit>`,
/// per the guide's "Blocs/Cubits constructed at navigation time" rule); the
/// [FloatingActionButton] pushes `NoteEditorPage` with its own page-scoped
/// `BlocProvider<NoteEditorBloc>` for fast capture (Requirement 1.1-1.3).
/// Each per-row delete-to-trash action resolves `MoveNoteToTrashUc` directly
/// via `getIt` (a plain use case, not a Bloc/Cubit, so `get_it` — not
/// `BlocProvider` — is the correct resolution point) rather than adding a
/// method to the already-approved `NoteListCubit`; that Cubit's live
/// subscription reflects the note leaving the list once the move lands, the
/// same "live subscription is the source of truth" pattern `TrashCubit`
/// already established for `restore`/`permanentlyDelete`.
class NoteListPage extends StatelessWidget {
  const NoteListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SearchBloc searchBloc = context.read<SearchBloc>();

    return Scaffold(
      backgroundColor: KnowledgeHubColors.canvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(KnowledgeHubSpacing.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const _NoteListHeaderRow(),
              const SizedBox(height: KnowledgeHubSpacing.base),
              SearchBarWidget(
                onChanged: (String query) => searchBloc.add(SearchEvent.queryChanged(query)),
              ),
              const SizedBox(height: KnowledgeHubSpacing.base),
              const Expanded(child: _NoteListOrSearchResultsSwitcher()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: KnowledgeHubColors.primary,
        foregroundColor: KnowledgeHubColors.onPrimary,
        elevation: 0,
        onPressed: () => _openNoteEditorForNewNote(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// "Notes" title plus the folder-management / tag-management / trash
/// navigation entry points (Requirements 1.1-1.3, 7.1).
class _NoteListHeaderRow extends StatelessWidget {
  const _NoteListHeaderRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Notes',
          style: KnowledgeHubTextStyles.titleMd.copyWith(color: KnowledgeHubColors.ink),
        ),
        Row(
          children: <Widget>[
            CircularIconButtonWidget(
              icon: Icons.folder_outlined,
              onPressed: () => _openFolderManagementDialog(context),
            ),
            const SizedBox(width: KnowledgeHubSpacing.sm),
            CircularIconButtonWidget(
              icon: Icons.label_outline,
              onPressed: () => _openTagManagementDialog(context),
            ),
            const SizedBox(width: KnowledgeHubSpacing.sm),
            CircularIconButtonWidget(
              icon: Icons.delete_outline,
              onPressed: () => _openTrashPage(context),
            ),
          ],
        ),
      ],
    );
  }
}

void _openFolderManagementDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) => const FolderCreationDialogWidget(),
  );
}

void _openTagManagementDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) => const TagCreationDialogWidget(),
  );
}

void _openTrashPage(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (BuildContext routeContext) => BlocProvider<TrashCubit>(
        create: (_) => TrashCubit(
          watchFilteredNotesUc: getIt<WatchFilteredNotesUc>(),
          restoreNoteFromTrashUc: getIt<RestoreNoteFromTrashUc>(),
          permanentlyDeleteNoteUc: getIt<PermanentlyDeleteNoteUc>(),
        ),
        child: const TrashPage(),
      ),
    ),
  );
}

void _openNoteEditorForNewNote(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (BuildContext routeContext) => BlocProvider<NoteEditorBloc>(
        create: (_) => NoteEditorBloc(
          createNoteUc: getIt<CreateNoteUc>(),
          saveNoteContentUc: getIt<SaveNoteContentUc>(),
          appLifecycleService: getIt<AppLifecycleService>(),
        ),
        child: const NoteEditorPage(),
      ),
    ),
  );
}

/// Switches between the search-result presentation and the normal filtered
/// list based solely on [SearchState]'s status — "active" means the user
/// has typed enough to move [SearchBloc] out of [SearchInitial] (the Bloc
/// itself gates the 3-character threshold and 300ms debounce; this page
/// never re-implements that gating). Scoped with [BlocSelector] to a plain
/// `bool` so neither section rebuilds on every [SearchBloc] emission — only
/// on an initial/non-initial status flip — per this codebase's
/// Bloc-in-lists performance conventions.
class _NoteListOrSearchResultsSwitcher extends StatelessWidget {
  const _NoteListOrSearchResultsSwitcher();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SearchBloc, SearchState, bool>(
      selector: (SearchState state) => state is! SearchInitial,
      builder: (BuildContext context, bool isSearchActive) {
        return isSearchActive ? const _SearchResultsSection() : const _FilteredNoteListSection();
      },
    );
  }
}

/// The non-search presentation: the folder selector (an "All notes" reset
/// chip plus one chip per real folder from [FolderCubit]), the tag chips
/// and AND/OR mode toggle (from [TagCubit]), and the filtered note list
/// itself, switching on [NoteListState]'s three subclasses.
class _FilteredNoteListSection extends StatelessWidget {
  const _FilteredNoteListSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _FolderSelectorRow(),
        SizedBox(height: KnowledgeHubSpacing.sm),
        _TagFilterRow(),
        SizedBox(height: KnowledgeHubSpacing.base),
        Expanded(child: _NoteListBody()),
      ],
    );
  }
}

/// The horizontally-scrolling folder selector: an "All notes" reset chip
/// (always present, calls `selectFolder(null)`) followed by one
/// [FolderChipWidget] per [FolderViewModel] in [FolderCubit]'s current
/// list (via [FolderStateCurrentFoldersX.currentFolders], which is `[]`
/// while `FolderCubit` is still loading — the row degrades to just the
/// "All notes" chip in that case, never a broken/empty gap).
class _FolderSelectorRow extends StatelessWidget {
  const _FolderSelectorRow();

  @override
  Widget build(BuildContext context) {
    final NoteListCubit noteListCubit = context.read<NoteListCubit>();

    return BlocSelector<NoteListCubit, NoteListState, String?>(
      selector: (NoteListState state) =>
          state is NoteListLoaded ? state.activeFilter.folderId : null,
      builder: (BuildContext context, String? selectedFolderId) {
        return BlocSelector<FolderCubit, FolderState, List<FolderViewModel>>(
          selector: (FolderState state) => state.currentFolders,
          builder: (BuildContext context, List<FolderViewModel> folders) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FolderChipWidget(
                    label: 'All notes',
                    isSelected: selectedFolderId == null,
                    onTap: () => noteListCubit.selectFolder(null),
                  ),
                  for (final FolderViewModel folder in folders) ...<Widget>[
                    const SizedBox(width: KnowledgeHubSpacing.sm),
                    FolderChipWidget(
                      label: folder.name,
                      isSelected: selectedFolderId == folder.folderId,
                      onTap: () => noteListCubit.selectFolder(folder.folderId),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }
}

/// The horizontally-scrolling tag chips (Requirements 5.2, 5.3, 9.2) plus
/// the AND/OR [TagFilterModeToggleWidget] (Requirement 5.4). Renders
/// nothing when [TagCubit] has no tags yet (an empty filter set has no
/// meaningful AND/OR distinction to show).
class _TagFilterRow extends StatelessWidget {
  const _TagFilterRow();

  @override
  Widget build(BuildContext context) {
    final NoteListCubit noteListCubit = context.read<NoteListCubit>();

    return BlocSelector<NoteListCubit, NoteListState, ({List<String> tagIds, TagFilterMode mode})>(
      selector: (NoteListState state) => state is NoteListLoaded
          ? (tagIds: state.activeFilter.tagIds, mode: state.activeFilter.tagFilterMode)
          : (tagIds: const <String>[], mode: TagFilterMode.anyOf),
      builder: (BuildContext context, ({List<String> tagIds, TagFilterMode mode}) filter) {
        return BlocSelector<TagCubit, TagState, List<TagViewModel>>(
          selector: (TagState state) => state.currentTags,
          builder: (BuildContext context, List<TagViewModel> tags) {
            if (tags.isEmpty) {
              return const SizedBox.shrink();
            }
            return IntrinsicHeight(
              child: Row(
                children: <Widget>[
                  TagFilterModeToggleWidget(
                    mode: filter.mode,
                    onModeChanged: noteListCubit.setTagFilterMode,
                  ),
                  const SizedBox(width: KnowledgeHubSpacing.sm),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          for (final TagViewModel tag in tags) ...<Widget>[
                            TagChipWidget(
                              label: tag.name,
                              isSelected: filter.tagIds.contains(tag.tagId),
                              onTap: () => noteListCubit.toggleTag(tag.tagId),
                            ),
                            const SizedBox(width: KnowledgeHubSpacing.sm),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

/// The filtered note list itself, switching on [NoteListState]'s three
/// subclasses. Split out from [_FilteredNoteListSection] so its
/// `BlocBuilder` doesn't also rebuild the folder/tag selector rows above it.
class _NoteListBody extends StatelessWidget {
  const _NoteListBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteListCubit, NoteListState>(
      builder: (BuildContext context, NoteListState state) => switch (state) {
        NoteListLoading() => const _CenteredLoadingIndicatorView(),
        NoteListLoadFailed(:final String errorMessage) => _ErrorMessageView(
          message: errorMessage,
        ),
        NoteListLoaded(:final List<NoteListItemViewModel> notes) =>
          notes.isEmpty ? const _EmptyNoteListView() : _NoteListView(notes: notes),
      },
    );
  }
}

/// Renders the filtered note list once [NoteListLoaded.notes] is
/// non-empty. Row taps are a documented no-op: opening a note in the
/// editor is navigation, which is this task's own boundary exclusion —
/// wiring it up is task 6.2's job.
class _NoteListView extends StatelessWidget {
  const _NoteListView({required this.notes});

  final List<NoteListItemViewModel> notes;

  @override
  Widget build(BuildContext context) {
    final MoveNoteToTrashUc moveNoteToTrashUc = getIt<MoveNoteToTrashUc>();

    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (BuildContext context, int index) => NoteListItemWidget(
        viewModel: notes[index],
        onTap: () {},
        onDeletePressed: () => unawaited(moveNoteToTrashUc(notes[index].noteId)),
      ),
    );
  }
}

/// The search presentation: switches on all five [SearchState] subclasses.
/// [SearchInitial] is unreachable in practice — [_NoteListOrSearchResultsSwitcher]
/// only mounts this section once the state has left [SearchInitial] — but a
/// sealed-class `switch` must stay exhaustive, so it maps to an empty
/// placeholder rather than an unreachable-case assertion.
class _SearchResultsSection extends StatelessWidget {
  const _SearchResultsSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (BuildContext context, SearchState state) => switch (state) {
        SearchInitial() => const SizedBox.shrink(),
        SearchSearching() => const _CenteredLoadingIndicatorView(),
        SearchResultsLoaded(:final List<NoteSearchResultViewModel> viewModels) =>
          _SearchResultListView(viewModels: viewModels),
        SearchNoResults() => const _SearchNoResultsView(),
        SearchFailed(:final String errorMessage) => _ErrorMessageView(message: errorMessage),
      },
    );
  }
}

/// Renders ranked search results with FTS5 match highlighting (Requirement
/// 6.4) via [HighlightedSnippetTextWidget]. Row taps are a documented
/// no-op for the same reason as [_NoteListView]'s — navigation is out of
/// this task's boundary.
class _SearchResultListView extends StatelessWidget {
  const _SearchResultListView({required this.viewModels});

  final List<NoteSearchResultViewModel> viewModels;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: viewModels.length,
      itemBuilder: (BuildContext context, int index) =>
          _SearchResultItemWidget(viewModel: viewModels[index]),
    );
  }
}

/// A single search-result row. Mirrors [NoteListItemWidget]'s visual shape
/// (`surfaceSoft` fill, `KnowledgeHubRadii.md`, `base` padding) for visual
/// continuity with the normal list, but has no relative-date meta line:
/// [NoteSearchResultViewModel] carries no `updatedAt` field (only
/// `NoteListItemViewModel` does), so there is nothing to render there —
/// the same documented "carry only what the ViewModel actually has, don't
/// fabricate" stance [NoteListItemWidget] already established for its own
/// folder-name gap.
class _SearchResultItemWidget extends StatelessWidget {
  const _SearchResultItemWidget({required this.viewModel});

  final NoteSearchResultViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: KnowledgeHubSpacing.sm),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(KnowledgeHubRadii.md),
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
                HighlightedSnippetTextWidget(
                  markedUpText: viewModel.highlightedTitleSnippet,
                  baseStyle: KnowledgeHubTextStyles.titleMd.copyWith(color: KnowledgeHubColors.ink),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: KnowledgeHubSpacing.xs),
                HighlightedSnippetTextWidget(
                  markedUpText: viewModel.highlightedBodySnippet,
                  baseStyle: KnowledgeHubTextStyles.bodySm.copyWith(color: KnowledgeHubColors.body),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
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
/// filtered result (Observable: "an empty filtered result shows a plain
/// empty-list presentation rather than an error") — muted text only, no
/// icon, deliberately distinct from [_SearchNoResultsView]'s icon-bearing
/// treatment and [_ErrorMessageView]'s `errorText`-colored treatment.
class _EmptyNoteListView extends StatelessWidget {
  const _EmptyNoteListView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No notes yet',
        style: KnowledgeHubTextStyles.bodyMd.copyWith(color: KnowledgeHubColors.muted),
      ),
    );
  }
}

/// The distinct no-results presentation for a settled search query that
/// matched nothing (Requirement 6.5; Observable: "the distinct no-results
/// presentation when nothing matches") — an icon plus muted text,
/// deliberately distinguishable from both [_EmptyNoteListView]'s plain
/// text-only treatment and [_ErrorMessageView]'s `errorText` treatment.
class _SearchNoResultsView extends StatelessWidget {
  const _SearchNoResultsView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.search_off, color: KnowledgeHubColors.muted, size: 32),
          const SizedBox(height: KnowledgeHubSpacing.sm),
          Text(
            'No notes match your search',
            style: KnowledgeHubTextStyles.bodyMd.copyWith(color: KnowledgeHubColors.muted),
          ),
        ],
      ),
    );
  }
}

/// A visible, `errorText`-colored error presentation shared by
/// [NoteListLoadFailed] and [SearchFailed] — clearly distinct from both
/// [_EmptyNoteListView] and [_SearchNoResultsView], neither of which use
/// this color.
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
