import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_code_block_editor/markdown_code_block_editor.dart';

class LeafSpanInfo {
  LeafSpanInfo({
    required this.text,
    required this.style,
    required this.start,
  });

  final String text;
  final TextStyle? style;
  final int start;
}

List<LeafSpanInfo> flattenLeafSpans(TextSpan rootSpan) {
  final List<TextSpan> leaves = <TextSpan>[];

  void collect(TextSpan span) {
    final List<InlineSpan>? children = span.children;
    if (children == null || children.isEmpty) {
      leaves.add(span);
      return;
    }
    for (final InlineSpan child in children) {
      collect(child as TextSpan);
    }
  }

  collect(rootSpan);

  int offset = 0;
  final List<LeafSpanInfo> leafInfos = <LeafSpanInfo>[];
  for (final TextSpan leaf in leaves) {
    final String leafText = leaf.text ?? '';
    leafInfos.add(
      LeafSpanInfo(text: leafText, style: leaf.style, start: offset),
    );
    offset += leafText.length;
  }
  return leafInfos;
}

void main() {
  const TextStyle ambientStyle = TextStyle(fontSize: 14, color: Colors.black);
  const TextStyle codeBlockStyle = TextStyle(
    fontFamily: 'monospace',
    fontSize: 13,
  );
  const Color keywordColor = Color(0xFF0000FF);
  const Color commentColor = Color(0xFF008000);
  const Map<String, TextStyle> codeHighlightTheme = <String, TextStyle>{
    'keyword': TextStyle(color: keywordColor),
    'comment': TextStyle(color: commentColor),
  };

  group('CodeBlockAwareTextEditingController.buildTextSpan', () {
    testWidgets(
      'plain prose outside a fenced block stays unstyled while the '
      'Dart code inside it is tokenized per-language',
      (WidgetTester tester) async {
        const String plainBefore = 'Some plain prose before the block.\n';
        const String fencedDartBlock =
            '```dart\nfinal int answer = 42; // comment\n```';
        const String plainAfter = '\nMore plain prose after.';
        final String fullText = plainBefore + fencedDartBlock + plainAfter;

        final CodeBlockAwareTextEditingController controller =
            CodeBlockAwareTextEditingController(
          codeBlockStyle: codeBlockStyle,
          codeHighlightTheme: codeHighlightTheme,
          text: fullText,
        );
        addTearDown(controller.dispose);

        late BuildContext capturedContext;
        await tester.pumpWidget(
          Builder(
            builder: (BuildContext context) {
              capturedContext = context;
              return const SizedBox();
            },
          ),
        );

        final TextSpan rootSpan = controller.buildTextSpan(
          context: capturedContext,
          style: ambientStyle,
          withComposing: false,
        );

        expect(rootSpan.toPlainText(), fullText);

        final List<LeafSpanInfo> leaves = flattenLeafSpans(rootSpan);
        final int codeBlockStart = fullText.indexOf(fencedDartBlock);
        final int codeBlockEnd = codeBlockStart + fencedDartBlock.length;

        final List<LeafSpanInfo> plainLeaves = leaves
            .where(
              (LeafSpanInfo leaf) =>
                  leaf.start < codeBlockStart || leaf.start >= codeBlockEnd,
            )
            .toList();
        final List<LeafSpanInfo> codeLeaves = leaves
            .where(
              (LeafSpanInfo leaf) =>
                  leaf.start >= codeBlockStart && leaf.start < codeBlockEnd,
            )
            .toList();

        expect(plainLeaves, isNotEmpty);
        for (final LeafSpanInfo leaf in plainLeaves) {
          expect(
            leaf.style,
            ambientStyle,
            reason: 'Plain prose outside the fence must carry no styling '
                'beyond the caller-supplied ambient style.',
          );
        }

        expect(
          codeLeaves.length,
          greaterThan(1),
          reason: 'The fenced Dart block must be broken into multiple '
              'sub-spans by real tokenization, not one opaque span.',
        );
        final bool anyThemeColorApplied = codeLeaves.any(
          (LeafSpanInfo leaf) =>
              leaf.style?.color == keywordColor ||
              leaf.style?.color == commentColor,
        );
        expect(
          anyThemeColorApplied,
          isTrue,
          reason: 'At least one code token must carry a color from the '
              'caller-supplied highlight theme, proving real tokenization.',
        );
        for (final LeafSpanInfo leaf in codeLeaves) {
          expect(
            leaf.style?.fontFamily,
            codeBlockStyle.fontFamily,
            reason: 'Every span inside the fenced block must inherit the '
                'caller-supplied monospace code-block style.',
          );
        }
      },
    );

    final Map<String, String> codeSnippetByOtherRequiredLanguage =
        <String, String>{
      'javascript': 'const greeting = "hello"; // note',
      'python': 'def greet():\n    return "hi"  # note',
      'swift': 'let count = 42 // note',
      'kotlin': 'val count = 42 // note',
    };

    for (final MapEntry<String, String> languageAndSnippet
        in codeSnippetByOtherRequiredLanguage.entries) {
      final String language = languageAndSnippet.key;
      final String codeSnippet = languageAndSnippet.value;

      testWidgets(
        'fenced $language code block is tokenized per-language into '
        'multiple distinctly-styled sub-spans',
        (WidgetTester tester) async {
          final String fencedBlock = '```$language\n$codeSnippet\n```';

          final CodeBlockAwareTextEditingController controller =
              CodeBlockAwareTextEditingController(
            codeBlockStyle: codeBlockStyle,
            codeHighlightTheme: codeHighlightTheme,
            text: fencedBlock,
          );
          addTearDown(controller.dispose);

          late BuildContext capturedContext;
          await tester.pumpWidget(
            Builder(
              builder: (BuildContext context) {
                capturedContext = context;
                return const SizedBox();
              },
            ),
          );

          final TextSpan rootSpan = controller.buildTextSpan(
            context: capturedContext,
            style: ambientStyle,
            withComposing: false,
          );

          expect(rootSpan.toPlainText(), fencedBlock);

          final List<LeafSpanInfo> leaves = flattenLeafSpans(rootSpan);

          expect(
            leaves.length,
            greaterThan(1),
            reason: 'The fenced $language block must be broken into '
                'multiple sub-spans by real per-language tokenization, not '
                'one opaque span.',
          );

          final bool anyThemeColorApplied = leaves.any(
            (LeafSpanInfo leaf) =>
                leaf.style?.color == keywordColor ||
                leaf.style?.color == commentColor,
          );
          expect(
            anyThemeColorApplied,
            isTrue,
            reason: 'At least one $language token must carry a color from '
                'the caller-supplied highlight theme, proving real '
                'per-language tokenization rather than a single '
                'monospace-wrapped blob.',
          );
        },
      );
    }

    testWidgets(
      'a fenced block with no language identifier is not tokenized',
      (WidgetTester tester) async {
        const String fencedPlainBlock = '```\nno language here\n```';

        final CodeBlockAwareTextEditingController controller =
            CodeBlockAwareTextEditingController(
          codeBlockStyle: codeBlockStyle,
          codeHighlightTheme: codeHighlightTheme,
          text: fencedPlainBlock,
        );
        addTearDown(controller.dispose);

        late BuildContext capturedContext;
        await tester.pumpWidget(
          Builder(
            builder: (BuildContext context) {
              capturedContext = context;
              return const SizedBox();
            },
          ),
        );

        final TextSpan rootSpan = controller.buildTextSpan(
          context: capturedContext,
          style: ambientStyle,
          withComposing: false,
        );

        expect(rootSpan.toPlainText(), fencedPlainBlock);

        final List<LeafSpanInfo> leaves = flattenLeafSpans(rootSpan);
        final bool anyThemeColorApplied = leaves.any(
          (LeafSpanInfo leaf) =>
              leaf.style?.color == keywordColor ||
              leaf.style?.color == commentColor,
        );
        expect(
          anyThemeColorApplied,
          isFalse,
          reason: 'A fence with no declared language must not be run '
              'through per-language tokenization.',
        );
      },
    );
  });
}
