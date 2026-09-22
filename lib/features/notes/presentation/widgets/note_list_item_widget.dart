import 'package:flutter/material.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_colors.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_radii.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_spacing.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_text_styles.dart';
import 'package:knowledge_hub/features/notes/presentation/view_models/note_list_item_view_model.dart';

/// Renders a single row in the note list (task 5.2, Requirements 5.2, 5.3,
/// 10.1) per design.md's §"Presentation Layer — UI Components" resolved
/// `NoteListItemWidget` spec: `KnowledgeHubColors.surfaceSoft` fill,
/// `KnowledgeHubRadii.md`, `KnowledgeHubSpacing.base` internal padding,
/// `titleMd` title + `.bodySm`/muted meta line, deliberately no elevation.
///
/// **Known scope gap — folder name in the meta line**: design.md describes
/// the meta line as "folder · relative date", but [NoteListItemViewModel]
/// only carries a `folderId`, not a resolved folder name — this task's
/// boundary is `NoteListPage` and its own widgets only, not `FolderCubit`
/// (that Cubit's live folder-name list is wired into this page in a later
/// task, per task 6.1's DI wiring). Rather than fabricate a folder name or
/// leave a broken lookup, the meta line is scoped to the relative date only
/// for now; the "folder · " prefix can be added once a resolved folder name
/// is available to pass in.
class NoteListItemWidget extends StatelessWidget {
  const NoteListItemWidget({required this.viewModel, required this.onTap, super.key});

  final NoteListItemViewModel viewModel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: KnowledgeHubSpacing.sm),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
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
                Text(
                  viewModel.title.isEmpty ? 'Untitled note' : viewModel.title,
                  style: KnowledgeHubTextStyles.titleMd.copyWith(color: KnowledgeHubColors.ink),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: KnowledgeHubSpacing.xs),
                Text(
                  viewModel.bodyPreview,
                  style: KnowledgeHubTextStyles.bodySm.copyWith(color: KnowledgeHubColors.body),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: KnowledgeHubSpacing.xs),
                Text(
                  _relativeDateLabelFor(viewModel.updatedAt),
                  style: KnowledgeHubTextStyles.bodySm.copyWith(color: KnowledgeHubColors.muted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Calendar-date-based relative label ("Today" / "Yesterday" / "N days
/// ago" / a plain date), mirroring `TrashedNoteViewModel.daysRemainingLabel`'s
/// established hand-rolled date-math pattern in this codebase rather than
/// pulling in a new `intl`/`timeago` dependency for one label.
String _relativeDateLabelFor(DateTime updatedAt) {
  final DateTime now = DateTime.now();
  final DateTime updatedDate = DateTime(updatedAt.year, updatedAt.month, updatedAt.day);
  final DateTime todayDate = DateTime(now.year, now.month, now.day);
  final int daysAgo = todayDate.difference(updatedDate).inDays;

  if (daysAgo <= 0) {
    return 'Today';
  }
  if (daysAgo == 1) {
    return 'Yesterday';
  }
  if (daysAgo < 7) {
    return '$daysAgo days ago';
  }
  const List<String> monthNames = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${monthNames[updatedAt.month - 1]} ${updatedAt.day}, ${updatedAt.year}';
}
