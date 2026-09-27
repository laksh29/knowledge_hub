import 'package:flutter/material.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_colors.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_radii.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_spacing.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_text_styles.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note_list_filter.dart';

/// Two adjacent selectable segments ("Any" / "All") toggling
/// [NoteListCubit.setTagFilterMode] between [TagFilterMode.anyOf] and
/// [TagFilterMode.allOf] (task 5.2, Requirement 5.4). design.md has no
/// dedicated segmented-control component token, so this is composed
/// directly from the same pill/fill-flip primitives `FolderChipWidget`/
/// `TagChipWidget` already use — a single `KnowledgeHubRadii.full` pill
/// container with two inner segments, rather than inventing a new,
/// undocumented component shape.
class TagFilterModeToggleWidget extends StatelessWidget {
  const TagFilterModeToggleWidget({
    required this.mode,
    required this.onModeChanged,
    super.key,
  });

  final TagFilterMode mode;
  final ValueChanged<TagFilterMode> onModeChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(KnowledgeHubSpacing.xxs),
      decoration: BoxDecoration(
        color: KnowledgeHubColors.surfaceStrong,
        borderRadius: BorderRadius.circular(KnowledgeHubRadii.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _TagFilterModeSegment(
            label: 'Any',
            isSelected: mode == TagFilterMode.anyOf,
            onTap: () => onModeChanged(TagFilterMode.anyOf),
          ),
          _TagFilterModeSegment(
            label: 'All',
            isSelected: mode == TagFilterMode.allOf,
            onTap: () => onModeChanged(TagFilterMode.allOf),
          ),
        ],
      ),
    );
  }
}

class _TagFilterModeSegment extends StatelessWidget {
  const _TagFilterModeSegment({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color fillColor = isSelected ? KnowledgeHubColors.primary : Colors.transparent;
    final Color textColor = isSelected ? KnowledgeHubColors.onPrimary : KnowledgeHubColors.ink;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(KnowledgeHubRadii.full),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: KnowledgeHubSpacing.md,
            vertical: KnowledgeHubSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: fillColor,
            borderRadius: BorderRadius.circular(KnowledgeHubRadii.full),
          ),
          child: Text(
            label,
            style: KnowledgeHubTextStyles.caption.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}
