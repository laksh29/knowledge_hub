import 'package:flutter/material.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_colors.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_radii.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_spacing.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_text_styles.dart';

/// A single selectable tag pill (task 5.2, Requirements 5.2-5.5, 9.2) per
/// design.md's §"Presentation Layer — UI Components" resolved
/// `TagChipWidget` spec: `KnowledgeHubRadii.full` pill, `caption` label;
/// unselected = `surfaceStrong` fill + ink text, selected = `primary` fill +
/// `onPrimary` text (a fill-flip, mirroring `button-primary`'s press-state
/// pattern). Near-identical to [FolderChipWidget] — kept as a distinct type
/// rather than a shared generic chip so folder/tag selection semantics stay
/// independently evolvable per design.md's File Structure Plan, which lists
/// them as two separate files.
class TagChipWidget extends StatelessWidget {
  const TagChipWidget({
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color fillColor = isSelected ? KnowledgeHubColors.primary : KnowledgeHubColors.surfaceStrong;
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
