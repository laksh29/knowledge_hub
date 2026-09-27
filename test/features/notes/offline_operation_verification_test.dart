import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/data/datasources/notes_local_data_source_impl.dart';
import 'package:knowledge_hub/features/notes/data/local/notes_database.dart' hide Note;
import 'package:knowledge_hub/features/notes/data/repositories/notes_repository_impl.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note_list_filter.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/notes_repository.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/create_note_uc.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/move_note_to_trash_uc.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/save_note_content_uc.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/watch_filtered_notes_uc.dart';

/// Task 7.1, Requirements 8.1/8.2. Exercises create/edit/delete against the
/// REAL local stack (an in-memory drift `NotesDatabase`, not a mock or
/// fake) — the same stack `main.dart` wires through DI — with zero network
/// dependency anywhere in the call graph.
///
/// "Organize" (folder/tag assignment) and "search" are deliberately
/// excluded from this pass, not by this test's own scope choice: neither
/// has a working path to exercise today. `NotesRepository` has no
/// assign-folder/assign-tags method at all (`NotesDataSource.setNoteTags`
/// exists at the data-source layer but nothing above it ever calls it, and
/// there is no folder-assignment write path anywhere), and
/// `NotesLocalDataSourceImpl.watchSearchResults` is still an
/// `UnimplementedError` stub. Both are separately tracked, user-owned gaps
/// (see `tasks.md`'s 7.1 note) — verifying them here would require
/// building the very functionality this task is meant to verify, not test
/// it.
void main() {
  group('Static proof: no networking dependency anywhere in the notes feature', () {
    const List<String> forbiddenSubstrings = <String>[
      'package:http/',
      'package:dio/',
      'package:connectivity_plus/',
      'HttpClient(',
      'Socket.connect',
    ];

    test('no source file under lib/features/notes references a networking API', () {
      final Directory featureDir = Directory('lib/features/notes');
      expect(featureDir.existsSync(), isTrue, reason: 'sanity check — run from the repo root');

      final List<File> dartFiles = featureDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((File f) => f.path.endsWith('.dart'))
          .toList();
      expect(dartFiles, isNotEmpty);

      final List<String> offendingFiles = <String>[];
      for (final File file in dartFiles) {
        final String contents = file.readAsStringSync();
        for (final String forbidden in forbiddenSubstrings) {
          if (contents.contains(forbidden)) {
            offendingFiles.add('${file.path} references "$forbidden"');
          }
        }
      }

      expect(
        offendingFiles,
        isEmpty,
        reason: 'the notes feature must have zero network dependency: $offendingFiles',
      );
    });
  });

  group('Functional proof: create, autosave-edit, and delete-to-trash all work fully offline', () {
    late NotesDatabase database;
    late NotesRepository repository;
    late CreateNoteUc createNoteUc;
    late SaveNoteContentUc saveNoteContentUc;
    late MoveNoteToTrashUc moveNoteToTrashUc;
    late WatchFilteredNotesUc watchFilteredNotesUc;

    setUp(() {
      database = NotesDatabase(NativeDatabase.memory());
      repository = NotesRepositoryImpl(NotesLocalDataSourceImpl(database));
      createNoteUc = CreateNoteUc(repository);
      saveNoteContentUc = SaveNoteContentUc(repository);
      moveNoteToTrashUc = MoveNoteToTrashUc(repository);
      watchFilteredNotesUc = WatchFilteredNotesUc(repository);
    });

    tearDown(() async {
      await database.close();
    });

    Future<List<Note>> activeNotes() async {
      final Result<Failure, List<Note>> result = await watchFilteredNotesUc(
        const NoteListFilterParams(),
      ).first;
      expect(result, isA<Ok<Failure, List<Note>>>());
      return (result as Ok<Failure, List<Note>>).value;
    }

    test(
      'a full create -> edit -> delete pass succeeds with no network-shaped '
      'failure ever surfacing',
      () async {
        final Result<Failure, Note> createResult = await createNoteUc();
        expect(createResult, isA<Ok<Failure, Note>>());
        final Note created = (createResult as Ok<Failure, Note>).value;
        expect(created.title, isEmpty, reason: 'a freshly captured note starts empty');
        expect(created.isUnfiled, isTrue);

        final Result<Failure, Note> saveResult = await saveNoteContentUc(
          SaveNoteContentParams(
            noteId: created.id,
            title: 'Offline note',
            body: 'Written with connectivity disabled',
          ),
        );
        expect(saveResult, isA<Ok<Failure, Note>>());
        final Note saved = (saveResult as Ok<Failure, Note>).value;
        expect(saved.title, 'Offline note');

        final List<Note> beforeDelete = await activeNotes();
        expect(beforeDelete.map((Note n) => n.id), contains(saved.id));

        final Result<Failure, void> deleteResult = await moveNoteToTrashUc(saved.id);
        expect(deleteResult, isA<Ok<Failure, void>>());

        final List<Note> afterDelete = await activeNotes();
        expect(
          afterDelete.map((Note n) => n.id),
          isNot(contains(saved.id)),
          reason: 'a trashed note must leave the active note list',
        );
      },
    );
  });
}
