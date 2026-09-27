import 'package:flutter/material.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_colors.dart';

/// Splits FTS5 `highlight()` output — plain text with matched terms wrapped
/// in literal `<mark>...</mark>` markers, e.g. `'<mark>Meeting</mark>
/// notes'` (confirmed via
/// `test/features/notes/presentation/bloc/search/search_bloc_test.dart`'s
/// fixtures) — into alternating unmatched/matched [TextSpan]s. FTS5's
/// `highlight()` never nests `<mark>` tags, so a single non-greedy
/// `RegExp` pass over the marker pairs is sufficient; no real HTML/markup
/// parser is needed.
final RegExp _highlightMarkerPattern = RegExp(r'<mark>(.*?)</mark>');

List<TextSpan> _spansForHighlightedText({
  required String markedUpText,
  required TextStyle unmatchedStyle,
  required TextStyle matchedStyle,
}) {
  final List<TextSpan> spans = <TextSpan>[];
  int previousMatchEnd = 0;

  for (final RegExpMatch match in _highlightMarkerPattern.allMatches(markedUpText)) {
    if (match.start > previousMatchEnd) {
      spans.add(
        TextSpan(text: markedUpText.substring(previousMatchEnd, match.start), style: unmatchedStyle),
      );
    }
    spans.add(TextSpan(text: match.group(1), style: matchedStyle));
    previousMatchEnd = match.end;
  }

  if (previousMatchEnd < markedUpText.length) {
    spans.add(TextSpan(text: markedUpText.substring(previousMatchEnd), style: unmatchedStyle));
  }

  return spans;
}

/// Renders one FTS5-highlighted search-result snippet (task 5.2,
/// Requirement 6.4). `.kiro/specs/notes-mvp/design.md` has no explicit
/// "highlighted search match" token — the same category of documented gap
/// as task 5.1's code-highlight-theme colors — so matched spans use
/// `KnowledgeHubColors.primary` (the system's one brand-accent color, per
/// `design.md`'s own "single accent color used scarcely" principle) plus
/// `FontWeight.bold`, layered on top of whatever [baseStyle] the caller
/// passes for the surrounding unmatched text (e.g. `titleMd` for a title
/// snippet, `bodySm`/muted for a body snippet), so the highlight reads
/// clearly against either context.
class HighlightedSnippetTextWidget extends StatelessWidget {
  const HighlightedSnippetTextWidget({
    required this.markedUpText,
    required this.baseStyle,
    this.maxLines,
    this.overflow,
    super.key,
  });

  final String markedUpText;
  final TextStyle baseStyle;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final TextStyle matchedStyle = baseStyle.copyWith(
      color: KnowledgeHubColors.primary,
      fontWeight: FontWeight.bold,
    );

    return Text.rich(
      TextSpan(
        children: _spansForHighlightedText(
          markedUpText: markedUpText,
          unmatchedStyle: baseStyle,
          matchedStyle: matchedStyle,
        ),
      ),
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
    );
  }
}
