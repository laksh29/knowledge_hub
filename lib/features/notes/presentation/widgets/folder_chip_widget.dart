import 'package:flutter/material.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_colors.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_radii.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_spacing.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_text_styles.dart';

/// A single selectable folder pill (task 5.2, Requirements 4.4, 9.1) per
/// design.md's §"Presentation Layer — UI Components" resolved
/// `FolderChipWidget` spec: `KnowledgeHubRadii.full` pill, `caption` label;
/// unselected = `surfaceStrong` fill + ink text, selected = `primary` fill +
/// `onPrimary` text (a fill-flip, mirroring `button-primary`'s press-state
/// pattern).
class FolderChipWidget extends StatelessWidget {
  const FolderChipWidget({
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
