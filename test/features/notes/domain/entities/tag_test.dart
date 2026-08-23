import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/features/notes/domain/entities/tag.dart';

void main() {
  group('Tag', () {
    test('holds every constructed field with its explicit, concrete type', () {
      const Tag tag = Tag(id: 'tag-1', name: 'exam');

      expect(tag.id, isA<String>());
      expect(tag.id, 'tag-1');
      expect(tag.name, isA<String>());
      expect(tag.name, 'exam');
    });

    test('equality is value-based (freezed)', () {
      const Tag first = Tag(id: 'tag-1', name: 'exam');
      const Tag second = Tag(id: 'tag-1', name: 'exam');

      expect(first, second);
    });
  });
}
