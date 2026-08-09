# markdown_code_block_editor

Fenced-code-block-aware `TextEditingController` and highlighting widget for
Markdown source text. All styling (fonts, colors) is caller-supplied — no
`design.md` token or hex value is baked into the package itself.

Zero dependency on any consuming application's domain types — copyable
verbatim into any Flutter project per `flutter-clean-architecture-guide.md`
§3.1's "zero project context" test.

Detects fenced (```` ``` ````) code blocks in plain text via `RegExp` and
delegates per-language tokenization to `package:highlight`, styling tokens
from a caller-supplied theme. Text outside a fence stays completely
unstyled. Supports at least Dart, JavaScript, Python, Swift, and Kotlin.
