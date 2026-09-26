import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/data/datasources/notes_local_data_source_impl.dart';
import 'package:knowledge_hub/features/notes/data/local/notes_database.dart' hide Note;
import 'package:knowledge_hub/features/notes/data/repositories/notes_repository_impl.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/notes_repository.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/create_note_uc.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/save_note_content_uc.dart';

/// Task 7.4, Requirement 9.1/9.2. Verifies the capture/edit core flow
/// behaves identically whether or not a persona-specific affordance
/// (code-block syntax highlighting, for the developer persona) is
/// exercised — Requirement 9.2's "additive layer on top of the
/// persona-neutral core flow, not a fork of it".
///
/// The "course-style tags" affordance (student persona) and "search" are
/// deliberately excluded from this pass: tags cannot be exercised at all
/// today (task 7.1's separately-tracked finding — no write path exists
/// anywhere to assign a tag to a note), and search is blocked by the same
/// long-tracked `watchSearchResults` stub blocking 7.1/7.3. Verifying
/// either here would require building the very functionality this task is
/// meant to verify, not test it.
void main() {
  group('Static proof: no persona-conditional branching in the core flow', () {
    test(
      'the domain and data layers never reference persona identity at all',
      () {
        const List<String> forbiddenSubstrings = <String>[
          'persona',
          'Persona',
          'isDeveloper',
          'isStudent',
          'isProfessional',
        ];

        final List<Directory> coreLayerDirs = <Directory>[
          Directory('lib/features/notes/domain'),
          Directory('lib/features/notes/data'),
        ];

        final List<File> dartFiles = coreLayerDirs
            .expand(
              (Directory dir) =>
                  dir.listSync(recursive: true).whereType<File>().where((File f) => f.path.endsWith('.dart')),
            )
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
          reason:
              'Requirement 9.2 requires persona affordances to be an additive '
              'presentation-layer concern, never a fork of the core domain/data '
              'flow: $offendingFiles',
        );
      },
    );
  });

  group(
    'Functional proof: a note with a fenced code block follows the exact '
    'same create/save path as a plain-text note',
    () {
      late NotesDatabase database;
      late NotesRepository repository;
      late CreateNoteUc createNoteUc;
      late SaveNoteContentUc saveNoteContentUc;

      setUp(() {
        database = NotesDatabase(NativeDatabase.memory());
        repository = NotesRepositoryImpl(NotesLocalDataSourceImpl(database));
        createNoteUc = CreateNoteUc(repository);
        saveNoteContentUc = SaveNoteContentUc(repository);
      });

      tearDown(() async {
        await database.close();
      });

      test(
        'a plain-text body and a body containing a fenced Dart code block are '
        'persisted byte-for-byte identically, with no domain/data-layer parsing',
        () async {
          const String plainBody = 'Just a plain paragraph of notes, no code.';
          const String codeBlockBody =
              'Notes on the bug:\n```dart\nvoid main() => print("hi");\n```\nThat fixed it.';

          for (final String body in <String>[plainBody, codeBlockBody]) {
            final Result<Failure, Note> createResult = await createNoteUc();
            expect(createResult, isA<Ok<Failure, Note>>());
            final Note created = (createResult as Ok<Failure, Note>).value;

            final Result<Failure, Note> saveResult = await saveNoteContentUc(
              SaveNoteContentParams(noteId: created.id, title: 'Persona-neutral check', body: body),
            );

            expect(
              saveResult,
              isA<Ok<Failure, Note>>(),
              reason: 'both a plain-text and a code-fenced body must succeed via the identical call path',
            );
            final Note saved = (saveResult as Ok<Failure, Note>).value;
            expect(
              saved.body,
              body,
              reason:
                  'the core flow must never parse/strip/transform fenced code '
                  'syntax -- highlighting is a presentation-layer-only concern',
            );
          }
        },
      );
    },
  );
}
