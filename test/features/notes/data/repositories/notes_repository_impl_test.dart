import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/data/models/note_model.dart';
import 'package:knowledge_hub/features/notes/data/repositories/notes_repository_impl.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note.dart';

import 'fakes/fake_notes_data_source.dart';

// USER-IMPLEMENT (notes-mvp task 2.6): these express the intended behavior
// of NotesRepositoryImpl and currently fail because every method throws
// UnimplementedError.
void main() {
  late FakeNotesDataSource dataSource;
  late NotesRepositoryImpl repository;

  setUp(() {
    dataSource = FakeNotesDataSource();
    repository = NotesRepositoryImpl(dataSource);
  });

  group('restoreNoteFromTrash (USER-IMPLEMENT)', () {
    test('returns the note to its original folder and tags unchanged', () async {
      final NoteModel note = NoteModel(
        id: 'note-1',
        title: 'Grocery list',
        body: 'Buy milk',
        folderId: 'folder-errands',
        createdAt: DateTime.utc(2026, 1, 1),
        updatedAt: DateTime.utc(2026, 1, 1),
      );
      dataSource.seed(note, tagIds: const <String>['tag-urgent', 'tag-home']);

      await dataSource.moveNoteToTrash('note-1');
      expect(dataSource.peek('note-1')!.deletedAt, isNotNull);

      final Result<dynamic, void> restoreResult = await repository.restoreNoteFromTrash('note-1');
      expect(restoreResult, isA<Ok<dynamic, void>>());

      final NoteModel restored = dataSource.peek('note-1')!;
      expect(restored.deletedAt, isNull, reason: 'restored note must be active again');
      expect(restored.folderId, 'folder-errands', reason: 'folder assignment must be unchanged');
      expect(
        await dataSource.getNoteTagIds('note-1'),
        containsAll(<String>['tag-urgent', 'tag-home']),
        reason: 'tag assignments must be unchanged',
      );
    });
  });

  group('purgeExpiredTrash (USER-IMPLEMENT)', () {
    test('purges only notes trashed more than 30 days ago, at the exact boundary', () async {
      // Uses the real clock (not a fixed date) since NotesRepositoryImpl's
      // purgeExpiredTrash() computes its cutoff from the real DateTime.now()
      // — the NotesRepository contract takes no parameters, so there is no
      // way to inject a fake clock here.
      final DateTime now = DateTime.now();

      final NoteModel justOverThreshold = NoteModel(
        id: 'note-old',
        title: 'Old trashed note',
        body: '...',
        createdAt: now,
        updatedAt: now,
        deletedAt: now.subtract(const Duration(days: 30, seconds: 1)),
      );
      final NoteModel justUnderThreshold = NoteModel(
        id: 'note-recent',
        title: 'Recently trashed note',
        body: '...',
        createdAt: now,
        updatedAt: now,
        deletedAt: now.subtract(const Duration(days: 30, seconds: -1)),
      );
      dataSource.seed(justOverThreshold);
      dataSource.seed(justUnderThreshold);

      final Result<dynamic, int> result = await repository.purgeExpiredTrash();

      expect(result, isA<Ok<dynamic, int>>());
      expect((result as Ok<dynamic, int>).value, 1, reason: 'only the >30-day-old note is purged');
      expect(dataSource.peek('note-old'), isNull, reason: 'note past the boundary must be gone');
      expect(
        dataSource.peek('note-recent'),
        isNotNull,
        reason: 'note within the boundary must survive',
      );
    });
  });

  group('watchNotes default sort (USER-IMPLEMENT)', () {
    test('applies most-recently-modified-first ordering unconditionally', () async {
      // This test documents the requirement; the real assertion (once
      // implemented) should watch the stream and confirm descending
      // updatedAt order regardless of insertion order.
      expect(() => repository, returnsNormally);
    }, skip: 'placeholder — extend once watchNotes is implemented');
  });

  group('createNote (USER-IMPLEMENT)', () {
    test('creates a new note with a generated id and no folder/tags', () async {
      final Result<dynamic, Note> result = await repository.createNote();
      expect(result, isA<Ok<dynamic, Note>>());
      final Note note = (result as Ok<dynamic, Note>).value;
      expect(note.id, isNotEmpty);
      expect(note.folderId, isNull);
      expect(note.tagIds, isEmpty);
    });
  });
}
