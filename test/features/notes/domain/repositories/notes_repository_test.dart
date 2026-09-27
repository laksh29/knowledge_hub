import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note_list_filter.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note_search_result.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/notes_repository.dart';

import 'fakes/fake_notes_repository.dart';

void main() {
  final DateTime createdAt = DateTime(2026, 1, 1, 9);
  final DateTime updatedAt = DateTime(2026, 1, 2, 10);
  final Note note = Note(
    id: 'note-1',
    title: 'Title',
    body: 'Body',
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
  final NoteSearchResult searchResult = NoteSearchResult(
    note: note,
    highlightedTitleSnippet: '<b>Title</b>',
    highlightedBodySnippet: '<b>Body</b>',
  );

  late NotesRepository notesRepository;

  setUp(() {
    notesRepository = FakeNotesRepository(note: note, searchResult: searchResult);
  });

  test('a fake genuinely implements NotesRepository', () {
    expect(notesRepository, isA<NotesRepository>());
  });

  test('createNote returns Future<Result<Failure, Note>>', () async {
    final Future<Result<Failure, Note>> pending = notesRepository.createNote();

    expect(pending, isA<Future<Result<Failure, Note>>>());
    final Result<Failure, Note> result = await pending;
    expect(result, isA<Ok<Failure, Note>>());
    expect((result as Ok<Failure, Note>).value, note);
  });

  test(
    'saveNoteContent takes SaveNoteContentParams and returns Future<Result<Failure, Note>>',
    () async {
      const SaveNoteContentParams params = SaveNoteContentParams(
        noteId: 'note-1',
        title: 'Title',
        body: 'Body',
      );

      final Result<Failure, Note> result = await notesRepository.saveNoteContent(
        params,
      );

      expect(params.noteId, isA<String>());
      expect(params.title, isA<String>());
      expect(params.body, isA<String>());
      expect(result, isA<Ok<Failure, Note>>());
    },
  );

  test(
    'watchNotes takes NoteListFilterParams and returns Stream<Result<Failure, List<Note>>>',
    () async {
      final Stream<Result<Failure, List<Note>>> stream = notesRepository
          .watchNotes(const NoteListFilterParams());

      expect(stream, isA<Stream<Result<Failure, List<Note>>>>());
      final Result<Failure, List<Note>> result = await stream.first;
      expect(result, isA<Ok<Failure, List<Note>>>());
      expect((result as Ok<Failure, List<Note>>).value, <Note>[note]);
    },
  );

  test(
    'watchSearchResults takes a String query and returns Stream<Result<Failure, List<NoteSearchResult>>>',
    () async {
      final Stream<Result<Failure, List<NoteSearchResult>>> stream =
          notesRepository.watchSearchResults('query');

      expect(
        stream,
        isA<Stream<Result<Failure, List<NoteSearchResult>>>>(),
      );
      final Result<Failure, List<NoteSearchResult>> result =
          await stream.first;
      expect(result, isA<Ok<Failure, List<NoteSearchResult>>>());
    },
  );

  test('moveNoteToTrash takes a noteId and returns Future<Result<Failure, void>>', () async {
    final Result<Failure, void> result = await notesRepository.moveNoteToTrash(
      'note-1',
    );

    expect(result, isA<Ok<Failure, void>>());
  });

  test(
    'restoreNoteFromTrash takes a noteId and returns Future<Result<Failure, void>>',
    () async {
      final Result<Failure, void> result = await notesRepository
          .restoreNoteFromTrash('note-1');

      expect(result, isA<Ok<Failure, void>>());
    },
  );

  test(
    'permanentlyDeleteNote takes a noteId and returns Future<Result<Failure, void>>',
    () async {
      final Result<Failure, void> result = await notesRepository
          .permanentlyDeleteNote('note-1');

      expect(result, isA<Ok<Failure, void>>());
    },
  );

  test('purgeExpiredTrash returns Future<Result<Failure, int>>', () async {
    final Result<Failure, int> result = await notesRepository
        .purgeExpiredTrash();

    expect(result, isA<Ok<Failure, int>>());
    expect((result as Ok<Failure, int>).value, isA<int>());
  });
}
