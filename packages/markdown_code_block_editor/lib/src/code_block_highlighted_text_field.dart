import 'package:flutter/material.dart';

import 'code_block_aware_text_editing_controller.dart';

/// A thin [TextField] wrapper around [CodeBlockAwareTextEditingController].
///
/// Every visual value — the plain-prose text style, the fenced-code-block
/// style, the per-token highlight theme, and the field's [InputDecoration] —
/// is supplied by the caller. This widget carries no `design.md` token, no
/// hex color literal, and no dependency on any consuming application's
/// types; it is the generic composition point a consuming app styles at its
/// own call site.
class CodeBlockHighlightedTextField extends StatefulWidget {
  const CodeBlockHighlightedTextField({
    required this.codeBlockStyle,
    required this.plainTextStyle,
    this.codeHighlightTheme = const <String, TextStyle>{},
    this.initialText = '',
    this.onChanged,
    this.decoration,
    this.maxLines,
    super.key,
  });

  /// Base style applied to text inside a fenced code block.
  final TextStyle codeBlockStyle;

  /// Style applied to text outside any fenced code block.
  final TextStyle plainTextStyle;

  /// Per-token-class color/weight overrides for text inside a fenced block.
  final Map<String, TextStyle> codeHighlightTheme;

  final String initialText;
  final ValueChanged<String>? onChanged;
  final InputDecoration? decoration;
  final int? maxLines;

  @override
  State<CodeBlockHighlightedTextField> createState() =>
      _CodeBlockHighlightedTextFieldState();
}

class _CodeBlockHighlightedTextFieldState
    extends State<CodeBlockHighlightedTextField> {
  late final CodeBlockAwareTextEditingController _controller =
      CodeBlockAwareTextEditingController(
    codeBlockStyle: widget.codeBlockStyle,
    codeHighlightTheme: widget.codeHighlightTheme,
    text: widget.initialText,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      style: widget.plainTextStyle,
      onChanged: widget.onChanged,
      decoration: widget.decoration,
      maxLines: widget.maxLines,
    );
  }
}
