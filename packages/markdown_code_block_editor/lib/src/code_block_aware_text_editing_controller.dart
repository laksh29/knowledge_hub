import 'package:flutter/material.dart';
import 'package:highlight/highlight.dart' as highlight_engine;

/// A [TextEditingController] that detects ` ``` `-fenced Markdown code blocks
/// in its plain-text value via [RegExp] and renders only the text inside
/// those blocks with per-language syntax tokenization.
///
/// Text outside any fenced block is rendered as a single, unstyled
/// [TextSpan] carrying only the ambient style the caller passes into
/// [buildTextSpan] — no color, weight, or font is ever added by this
/// package. All code-block styling (the base monospace [TextStyle] and the
/// per-token color theme) is supplied by the caller; nothing is baked in.
class CodeBlockAwareTextEditingController extends TextEditingController {
  CodeBlockAwareTextEditingController({
    required this.codeBlockStyle,
    this.codeHighlightTheme = const <String, TextStyle>{},
    super.text,
  });

  /// Base style applied to every character inside a fenced code block,
  /// including its fence markers and language identifier line.
  final TextStyle codeBlockStyle;

  /// Per-token-class color/weight overrides layered on top of
  /// [codeBlockStyle], keyed by the `highlight` package's node class names
  /// (e.g. `keyword`, `comment`, `string`).
  final Map<String, TextStyle> codeHighlightTheme;

  static final RegExp _fencedCodeBlockPattern = RegExp(
    r'```(\w*)\n([\s\S]*?)```',
    multiLine: true,
  );

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final String sourceText = text;
    final List<TextSpan> spans = <TextSpan>[];
    int cursor = 0;

    for (final RegExpMatch match in _fencedCodeBlockPattern.allMatches(
      sourceText,
    )) {
      if (match.start > cursor) {
        spans.add(
          TextSpan(text: sourceText.substring(cursor, match.start), style: style),
        );
      }

      spans.addAll(_buildFencedBlockSpans(sourceText: sourceText, match: match));
      cursor = match.end;
    }

    if (cursor < sourceText.length) {
      spans.add(TextSpan(text: sourceText.substring(cursor), style: style));
    }

    if (spans.isEmpty) {
      return TextSpan(text: sourceText, style: style);
    }

    return TextSpan(style: style, children: spans);
  }

  List<TextSpan> _buildFencedBlockSpans({
    required String sourceText,
    required RegExpMatch match,
  }) {
    final int codeStart = match[1] == null
        ? match.start
        : match.start + '```${match[1]}\n'.length;
    final String openFenceText = sourceText.substring(match.start, codeStart);
    final String closeFenceText = sourceText.substring(match.end - 3, match.end);
    final String language = (match.group(1) ?? '').trim();
    final String codeText = match.group(2) ?? '';

    return <TextSpan>[
      TextSpan(text: openFenceText, style: codeBlockStyle),
      ..._buildCodeBlockSpans(codeText: codeText, language: language),
      TextSpan(text: closeFenceText, style: codeBlockStyle),
    ];
  }

  List<TextSpan> _buildCodeBlockSpans({
    required String codeText,
    required String language,
  }) {
    if (language.isEmpty) {
      return <TextSpan>[TextSpan(text: codeText, style: codeBlockStyle)];
    }

    final highlight_engine.Result parsedResult = highlight_engine.highlight
        .parse(codeText, language: language.toLowerCase());
    final List<highlight_engine.Node> nodes = parsedResult.nodes ?? <highlight_engine.Node>[];

    return _buildSpansFromNodes(nodes: nodes, ancestorStyle: codeBlockStyle);
  }

  List<TextSpan> _buildSpansFromNodes({
    required List<highlight_engine.Node> nodes,
    required TextStyle ancestorStyle,
  }) {
    return nodes.map((highlight_engine.Node node) {
      final TextStyle? tokenStyle = codeHighlightTheme[node.className];
      final TextStyle effectiveStyle =
          tokenStyle != null ? ancestorStyle.merge(tokenStyle) : ancestorStyle;
      final List<highlight_engine.Node>? children = node.children;

      if (children != null && children.isNotEmpty) {
        return TextSpan(
          style: effectiveStyle,
          children: _buildSpansFromNodes(
            nodes: children,
            ancestorStyle: effectiveStyle,
          ),
        );
      }

      return TextSpan(text: node.value ?? '', style: effectiveStyle);
    }).toList(growable: false);
  }
}
