import 'package:flutter/material.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_colors.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_text_styles.dart';
import 'package:markdown_code_block_editor/markdown_code_block_editor.dart';

/// Thin design-system wrapper around `packages/markdown_code_block_editor`'s
/// [CodeBlockHighlightedTextField], used for the note body (Requirements
/// 2.2-2.4). The package itself carries zero dependency on this app's design
/// tokens by design — the citation obligation from the design-system
/// steering is satisfied here, at the call site, not inside the generic
/// package (design.md's `packages/markdown_code_block_editor` integration
/// note).
///
/// Font family/sizing for fenced code blocks is a resolved design.md gap
/// (2026-09-20): `fontFamily: 'Courier'` with `fontFamilyFallback:
/// ['monospace']`, sized at `{typography.body-md}`'s baseline (16px) —
/// platform system monospace, no bundled font asset.
///
/// The per-token-class [_codeHighlightTheme] syntax colors are NOT a
/// resolved design.md gap — design.md has no syntax-highlighting color token
/// category at all. These are a conservative placeholder derived from
/// existing text tokens (ink/body/muted with weight/italic variation)
/// instead of invented hex colors, flagged as a smaller, separate open
/// design gap in this task's status report.
class CodeBlockHighlightedTextWidget extends StatelessWidget {
  const CodeBlockHighlightedTextWidget({
    required this.onChanged,
    this.initialText = '',
    this.hintText,
    super.key,
  });

  final ValueChanged<String> onChanged;
  final String initialText;
  final String? hintText;

  static const Map<String, TextStyle> _codeHighlightTheme = <String, TextStyle>{
    'keyword': TextStyle(color: KnowledgeHubColors.ink, fontWeight: FontWeight.w600),
    'built_in': TextStyle(color: KnowledgeHubColors.ink, fontWeight: FontWeight.w600),
    'title': TextStyle(color: KnowledgeHubColors.ink, fontWeight: FontWeight.w600),
    'string': TextStyle(color: KnowledgeHubColors.body),
    'number': TextStyle(color: KnowledgeHubColors.body, fontWeight: FontWeight.w600),
    'literal': TextStyle(color: KnowledgeHubColors.body, fontWeight: FontWeight.w600),
    'comment': TextStyle(color: KnowledgeHubColors.muted, fontStyle: FontStyle.italic),
  };

  @override
  Widget build(BuildContext context) {
    final TextStyle codeBlockStyle = KnowledgeHubTextStyles.bodyMd.copyWith(
      fontFamily: 'Courier',
      fontFamilyFallback: const <String>['monospace'],
      color: KnowledgeHubColors.ink,
    );
    final TextStyle plainTextStyle = KnowledgeHubTextStyles.bodyMd.copyWith(
      color: KnowledgeHubColors.ink,
    );

    return CodeBlockHighlightedTextField(
      codeBlockStyle: codeBlockStyle,
      plainTextStyle: plainTextStyle,
      codeHighlightTheme: _codeHighlightTheme,
      initialText: initialText,
      onChanged: onChanged,
      maxLines: null,
      decoration: InputDecoration(
        isCollapsed: true,
        border: InputBorder.none,
        hintText: hintText,
        hintStyle: KnowledgeHubTextStyles.bodyMd.copyWith(color: KnowledgeHubColors.muted),
      ),
    );
  }
}
