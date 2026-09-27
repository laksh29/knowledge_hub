/// Fenced-code-block-aware `TextEditingController` and highlighting widget
/// for Markdown source text, styled entirely via caller-supplied parameters.
///
/// This package has zero dependency on any consuming application's domain
/// types or design tokens — fence detection is `RegExp`-based and per-token
/// coloring is delegated directly to `package:highlight`.
library;

export 'src/code_block_aware_text_editing_controller.dart';
export 'src/code_block_highlighted_text_field.dart';
