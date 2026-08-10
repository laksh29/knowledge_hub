import 'package:flutter/material.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_colors.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_radii.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_spacing.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_text_styles.dart';

/// The single shared text-field component (`{component.text-input}`) — every text input in this
/// feature (note title, folder name, tag name) instantiates this directly rather than each
/// defining its own `TextField`.
///
/// `design.md`'s spec is a *stacked* label above the bordered box (in `{typography.caption}`
/// muted) plus separate in-box placeholder text (in `{typography.body-md}` muted) — two distinct
/// elements, neither of which is Flutter Material's default floating-label pattern. The label is
/// therefore rendered as a plain `Text` sibling above the `TextField`, not via
/// `InputDecoration.labelText`, and placeholder text is exposed via a dedicated [hintText]
/// parameter wired to `InputDecoration.hintText`.
class AppTextFieldWidget extends StatelessWidget {
  const AppTextFieldWidget({
    required this.controller,
    required this.labelText,
    this.onChanged,
    this.errorText,
    this.hintText,
    super.key,
  });

  final TextEditingController controller;
  final String labelText;
  final ValueChanged<String>? onChanged;
  final String? errorText;
  final String? hintText;

  /// design.md's `text-input` spec gives "14x12px padding", a 56px box height, and a 1px default
  /// / 2px focused ink border, but the literal 14px vertical padding and the literal 56px height
  /// cannot both hold exactly given `{typography.body-md}`'s line height and `isDense: true` —
  /// empirically, 14px vertical padding renders a 52px box, not 56px (verified via
  /// `tester.getSize` on the rendered `TextField` with no error text present; error text
  /// legitimately grows the widget beyond 56px, which is expected — design.md's 56px describes
  /// the box, not the error-message row below it). The 56px height is treated as the
  /// higher-priority, more load-bearing spec value, so vertical content padding is set to
  /// `KnowledgeHubSpacing.base` (16) instead of the descriptive "14" figure to hit exactly 56px.
  /// design.md has no border-width token category at all, so the two border widths below are
  /// kept as named, documented local constants rather than force-mapped onto an unrelated token.
  static const double _defaultBorderWidth = 1;
  static const double _focusedBorderWidth = 2;

  @override
  Widget build(BuildContext context) {
    final OutlineInputBorder defaultBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(KnowledgeHubRadii.sm),
      borderSide: const BorderSide(
        color: KnowledgeHubColors.hairline,
        width: _defaultBorderWidth,
      ),
    );
    final OutlineInputBorder focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(KnowledgeHubRadii.sm),
      borderSide: const BorderSide(
        color: KnowledgeHubColors.ink,
        width: _focusedBorderWidth,
      ),
    );
    final OutlineInputBorder errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(KnowledgeHubRadii.sm),
      borderSide: const BorderSide(
        color: KnowledgeHubColors.errorText,
        width: _defaultBorderWidth,
      ),
    );
    final OutlineInputBorder focusedErrorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(KnowledgeHubRadii.sm),
      borderSide: const BorderSide(
        color: KnowledgeHubColors.errorText,
        width: _focusedBorderWidth,
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          labelText,
          style: KnowledgeHubTextStyles.caption.copyWith(
            color: KnowledgeHubColors.muted,
          ),
        ),
        const SizedBox(height: KnowledgeHubSpacing.xs),
        TextField(
          controller: controller,
          onChanged: onChanged,
          style: KnowledgeHubTextStyles.bodyMd.copyWith(
            color: KnowledgeHubColors.ink,
          ),
          decoration: InputDecoration(
            isDense: true,
            hintText: hintText,
            hintStyle: KnowledgeHubTextStyles.bodyMd.copyWith(
              color: KnowledgeHubColors.muted,
            ),
            errorText: errorText,
            errorStyle: KnowledgeHubTextStyles.captionSm.copyWith(
              color: KnowledgeHubColors.errorText,
            ),
            filled: true,
            fillColor: KnowledgeHubColors.canvas,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: KnowledgeHubSpacing.md,
              vertical: KnowledgeHubSpacing.base,
            ),
            border: defaultBorder,
            enabledBorder: defaultBorder,
            focusedBorder: focusedBorder,
            errorBorder: errorBorder,
            focusedErrorBorder: focusedErrorBorder,
          ),
        ),
      ],
    );
  }
}
