import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/features/notes/domain/entities/folder.dart';

void main() {
  group('Folder', () {
    test('holds every constructed field with its explicit, concrete type', () {
      const Folder folder = Folder(id: 'folder-1', name: 'Work');

      expect(folder.id, isA<String>());
      expect(folder.id, 'folder-1');
      expect(folder.name, isA<String>());
      expect(folder.name, 'Work');
    });

    test('equality is value-based (freezed)', () {
      const Folder first = Folder(id: 'folder-1', name: 'Work');
      const Folder second = Folder(id: 'folder-1', name: 'Work');

      expect(first, second);
    });
  });
}
