import 'package:flutter/material.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_colors.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_radii.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_spacing.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_text_styles.dart';

class SecondaryButtonWidget extends StatelessWidget {
  const SecondaryButtonWidget({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;

  /// design.md's `button-secondary` spec says "1px ink outline" as a literal component
  /// dimension. design.md has no dedicated border-width token category (only spacing, radius,
  /// color, elevation, and typography scales are defined), so this is kept as a named,
  /// documented local constant rather than inlined or force-mapped onto an unrelated token.
  static const double _outlineWidth = 1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: KnowledgeHubSpacing.xxl,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: KnowledgeHubColors.canvas,
          foregroundColor: KnowledgeHubColors.ink,
          side: const BorderSide(
            color: KnowledgeHubColors.ink,
            width: _outlineWidth,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: KnowledgeHubSpacing.lg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(KnowledgeHubRadii.sm),
          ),
        ),
        child: Text(
          label,
          style: KnowledgeHubTextStyles.buttonMd.copyWith(
            color: KnowledgeHubColors.ink,
          ),
        ),
      ),
    );
  }
}
