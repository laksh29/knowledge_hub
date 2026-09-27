import 'package:flutter/material.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_colors.dart';

/// design.md documents a "circular icon-button surface" only in passing, under the Surface
/// Strong color description — there is no fully-specced `icon-button-circle` component block
/// with exact pixel dimensions (per `design-system.md`'s Known Gaps policy, this is an open gap,
/// not a value design.md defines). [_diameter] is a deliberate, documented choice — 40x40,
/// matching `{component.date-picker-day}`, the closest documented circular element in the
/// system — not a guessed pixel-perfect value for this specific component.
class CircularIconButtonWidget extends StatelessWidget {
  const CircularIconButtonWidget({
    required this.icon,
    required this.onPressed,
    super.key,
  });

  final IconData icon;
  final VoidCallback onPressed;

  static const double _diameter = 40;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _diameter,
      height: _diameter,
      child: Material(
        color: KnowledgeHubColors.surfaceStrong,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Icon(icon, color: KnowledgeHubColors.ink),
        ),
      ),
    );
  }
}
