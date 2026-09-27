import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note_search_result.dart';

void main() {
  group('NoteSearchResult', () {
    final Note note = Note(
      id: 'note-1',
      title: 'Dart Notes',
      body: 'About futures',
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    );

    test('wraps a Note plus highlighted snippets with explicit types', () {
      final NoteSearchResult result = NoteSearchResult(
        note: note,
        highlightedTitleSnippet: '<b>Dart</b> Notes',
        highlightedBodySnippet: 'About <b>futures</b>',
      );

      expect(result.note, isA<Note>());
      expect(result.note, note);
      expect(result.highlightedTitleSnippet, isA<String>());
      expect(result.highlightedTitleSnippet, '<b>Dart</b> Notes');
      expect(result.highlightedBodySnippet, isA<String>());
      expect(result.highlightedBodySnippet, 'About <b>futures</b>');
    });

    test('equality is value-based (freezed)', () {
      final NoteSearchResult first = NoteSearchResult(
        note: note,
        highlightedTitleSnippet: '<b>Dart</b> Notes',
        highlightedBodySnippet: 'About <b>futures</b>',
      );
      final NoteSearchResult second = NoteSearchResult(
        note: note,
        highlightedTitleSnippet: '<b>Dart</b> Notes',
        highlightedBodySnippet: 'About <b>futures</b>',
      );

      expect(first, second);
    });
  });
}
