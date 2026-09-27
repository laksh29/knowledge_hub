import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note_list_filter.dart';

void main() {
  group('NoteListFilterParams', () {
    test('defaults tagFilterMode to anyOf and lifecycleScope to active', () {
      const NoteListFilterParams params = NoteListFilterParams();

      expect(params.folderId, isNull);
      expect(params.tagIds, isA<List<String>>());
      expect(params.tagIds, isEmpty);
      expect(params.tagFilterMode, isA<TagFilterMode>());
      expect(params.tagFilterMode, TagFilterMode.anyOf);
      expect(params.lifecycleScope, isA<NoteLifecycleScope>());
      expect(params.lifecycleScope, NoteLifecycleScope.active);
    });

    test('holds every constructed field with its explicit, concrete type', () {
      const NoteListFilterParams params = NoteListFilterParams(
        folderId: 'folder-1',
        tagIds: <String>['tag-1', 'tag-2'],
        tagFilterMode: TagFilterMode.allOf,
        lifecycleScope: NoteLifecycleScope.trash,
      );

      expect(params.folderId, isA<String?>());
      expect(params.folderId, 'folder-1');
      expect(params.tagIds, <String>['tag-1', 'tag-2']);
      expect(params.tagFilterMode, TagFilterMode.allOf);
      expect(params.lifecycleScope, NoteLifecycleScope.trash);
    });

    test('TagFilterMode has exactly anyOf and allOf', () {
      expect(TagFilterMode.values, <TagFilterMode>[TagFilterMode.anyOf, TagFilterMode.allOf]);
    });

    test('NoteLifecycleScope has exactly active and trash', () {
      expect(NoteLifecycleScope.values, <NoteLifecycleScope>[
        NoteLifecycleScope.active,
        NoteLifecycleScope.trash,
      ]);
    });
  });
}
