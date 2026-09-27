import 'package:flutter/material.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_colors.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_spacing.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_text_styles.dart';

class TertiaryTextButtonWidget extends StatelessWidget {
  const TertiaryTextButtonWidget({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: KnowledgeHubColors.ink,
        padding: const EdgeInsets.symmetric(
          horizontal: KnowledgeHubSpacing.sm,
          vertical: KnowledgeHubSpacing.xs,
        ),
      ),
      child: Text(
        label,
        style: KnowledgeHubTextStyles.buttonMd.copyWith(
          color: KnowledgeHubColors.ink,
        ),
      ),
    );
  }
}
