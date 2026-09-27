import 'package:flutter/material.dart';

class KnowledgeHubElevation {
  const KnowledgeHubElevation._();

  /// design.md's single documented shadow tier:
  /// `rgba(0,0,0,0.02) 0 0 0 1px, rgba(0,0,0,0.04) 0 2px 6px 0, rgba(0,0,0,0.1) 0 4px 8px 0`.
  /// Kept as a getter (not `const`) so the exact rgba opacity values can be expressed via
  /// `Color.fromRGBO` rather than rounded to a hex alpha byte, which isn't `const`-constructible.
  static List<BoxShadow> get cardHoverFloat => <BoxShadow>[
    const BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.02),
      spreadRadius: 1,
    ),
    const BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.04),
      offset: Offset(0, 2),
      blurRadius: 6,
    ),
    const BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.1),
      offset: Offset(0, 4),
      blurRadius: 8,
    ),
  ];
}
