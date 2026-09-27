import 'package:flutter/material.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_colors.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_radii.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_spacing.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_text_styles.dart';

class PrimaryButtonWidget extends StatelessWidget {
  const PrimaryButtonWidget({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: KnowledgeHubSpacing.xxl,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: KnowledgeHubColors.primary,
          foregroundColor: KnowledgeHubColors.onPrimary,
          disabledBackgroundColor: KnowledgeHubColors.primaryDisabled,
          disabledForegroundColor: KnowledgeHubColors.onPrimary,
          elevation: 0,
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
            color: KnowledgeHubColors.onPrimary,
          ),
        ),
      ),
    );
  }
}
