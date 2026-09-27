import 'dart:async';

import 'package:app_lifecycle_service/app_lifecycle_service.dart';
import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/features/notes/data/datasources/notes_local_data_source_impl.dart';
import 'package:knowledge_hub/features/notes/data/local/notes_database.dart';
import 'package:knowledge_hub/features/notes/data/repositories/notes_repository_impl.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/notes_repository.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/create_note_uc.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/save_note_content_uc.dart';
import 'package:knowledge_hub/features/notes/presentation/bloc/note_editor/note_editor_bloc.dart';
import 'package:knowledge_hub/features/notes/presentation/bloc/note_editor/note_editor_event.dart';
import 'package:knowledge_hub/features/notes/presentation/bloc/note_editor/note_editor_state.dart';
import 'package:mocktail/mocktail.dart';

class MockAppLifecycleService extends Mock implements AppLifecycleService {}

/// Task 7.2, Requirement 3.8. `note_editor_bloc_test.dart` already proves
/// (against a *mocked* `SaveNoteContentUc`) that each of the four save
/// triggers reaches `NoteEditorSaved`. What it cannot prove is durability:
/// whether the content is actually committed to storage by the moment that
/// state is reached, which is the whole point of the zero-data-loss
/// guarantee — a save that only lives in a mock's recorded call args proves
/// nothing about a real crash.
///
/// Each test here drives a REAL `NoteEditorBloc` wired to the REAL
/// persistence stack (`NotesDatabase(NativeDatabase.memory())` →
/// `NotesLocalDataSourceImpl` → `NotesRepositoryImpl`, no mocks except the
/// external OS-boundary `AppLifecycleService`, whose timing this test must
/// control). After each trigger reaches `NoteEditorSaved`, it reads the note
/// row directly off the database — bypassing the Bloc/repository entirely —
/// simulating exactly what a fresh app start after a crash would see: only
/// what was actually committed to disk survives.
void main() {
  late NotesDatabase database;
  late NotesRepository repository;
  late CreateNoteUc createNoteUc;
  late SaveNoteContentUc saveNoteContentUc;
  late MockAppLifecycleService appLifecycleService;
  late StreamController<AppLifecycleState> lifecycleController;

  setUp(() {
    database = NotesDatabase(NativeDatabase.memory());
    repository = NotesRepositoryImpl(NotesLocalDataSourceImpl(database));
    createNoteUc = CreateNoteUc(repository);
    saveNoteContentUc = SaveNoteContentUc(repository);
    lifecycleController = StreamController<AppLifecycleState>();
    appLifecycleService = MockAppLifecycleService();
    when(() => appLifecycleService.lifecycleChanges).thenAnswer((_) => lifecycleController.stream);
  });

  tearDown(() async {
    await lifecycleController.close();
    await database.close();
  });

  NoteEditorBloc buildBloc() => NoteEditorBloc(
    createNoteUc: createNoteUc,
    saveNoteContentUc: saveNoteContentUc,
    appLifecycleService: appLifecycleService,
  );

  Future<Note> readNoteDirectlyFromDatabase(String noteId) =>
      (database.select(database.notes)..where((n) => n.id.equals(noteId))).getSingle();

  group('Zero data loss across a simulated crash/force-quit, per save trigger', () {
    test(
      'idle-debounce trigger: content is durably committed once NoteEditorSaved is reached',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        final NoteEditorBloc bloc = buildBloc();
        addTearDown(bloc.close);

        bloc.add(const NoteEditorEvent.started());
        await expectLater(bloc.stream, emitsThrough(isA<NoteEditorNotSaved>()));
        final String noteId = (bloc.state as NoteEditorNotSaved).viewModel.noteId;

        bloc.add(const NoteEditorEvent.bodyChanged('idle debounce content'));
        await expectLater(bloc.stream, emitsThrough(isA<NoteEditorSaved>()));

        final Note persisted = await readNoteDirectlyFromDatabase(noteId);
        expect(
          persisted.body,
          'idle debounce content',
          reason: 'a real crash right after NoteEditorSaved must lose nothing',
        );
      },
    );

    test(
      '100-char-threshold trigger: content is durably committed well before the '
      '300ms idle debounce would have settled',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        final NoteEditorBloc bloc = buildBloc();
        addTearDown(bloc.close);

        bloc.add(const NoteEditorEvent.started());
        await expectLater(bloc.stream, emitsThrough(isA<NoteEditorNotSaved>()));
        final String noteId = (bloc.state as NoteEditorNotSaved).viewModel.noteId;

        final String longBody = 'x' * 120;
        bloc.add(NoteEditorEvent.bodyChanged(longBody));
        await Future<void>.delayed(const Duration(milliseconds: 100));

        expect(bloc.state, isA<NoteEditorSaved>());
        final Note persisted = await readNoteDirectlyFromDatabase(noteId);
        expect(persisted.body, longBody);
      },
    );

    test(
      'app-lifecycle trigger: a still-debouncing edit (neither idle-settled nor '
      'threshold-crossed) is durably committed the instant the app is backgrounded',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        final NoteEditorBloc bloc = buildBloc();
        addTearDown(bloc.close);

        bloc.add(const NoteEditorEvent.started());
        await expectLater(bloc.stream, emitsThrough(isA<NoteEditorNotSaved>()));
        final String noteId = (bloc.state as NoteEditorNotSaved).viewModel.noteId;

        // Short body: crosses neither the 100-char threshold nor the 300ms
        // idle window this test deliberately never waits out.
        bloc.add(const NoteEditorEvent.titleChanged('about to be killed'));
        await pumpEventQueue();
        expect(
          bloc.state,
          isNot(isA<NoteEditorSaved>()),
          reason: 'sanity check -- neither trigger has fired yet',
        );

        lifecycleController.add(AppLifecycleState.paused);
        // Bounded, well under the 300ms idle debounce still pending from the
        // titleChanged event above -- if the lifecycle trigger's own
        // immediate-save path were broken, that leftover debounce timer
        // would otherwise still fire and rescue this assertion, hiding a
        // real Requirement-3.3 regression.
        await Future<void>.delayed(const Duration(milliseconds: 100));

        expect(
          bloc.state,
          isA<NoteEditorSaved>(),
          reason: 'paused must save immediately, not wait out the idle debounce',
        );
        final Note persisted = await readNoteDirectlyFromDatabase(noteId);
        expect(
          persisted.title,
          'about to be killed',
          reason:
              'the OS pausing the app before killing it must flush whatever '
              'was mid-debounce, or that content would be lost forever',
        );
      },
    );

    test(
      'manual-save trigger: content is durably committed immediately, no debounce wait',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        final NoteEditorBloc bloc = buildBloc();
        addTearDown(bloc.close);

        bloc.add(const NoteEditorEvent.started());
        await expectLater(bloc.stream, emitsThrough(isA<NoteEditorNotSaved>()));
        final String noteId = (bloc.state as NoteEditorNotSaved).viewModel.noteId;

        bloc.add(const NoteEditorEvent.titleChanged('manually saved title'));
        bloc.add(const NoteEditorEvent.manualSaveRequested());
        // Bounded, well under the 300ms idle debounce still pending from the
        // titleChanged event above -- see the app-lifecycle test's comment
        // for why an unbounded wait here would hide a real regression.
        await Future<void>.delayed(const Duration(milliseconds: 100));

        expect(
          bloc.state,
          isA<NoteEditorSaved>(),
          reason: 'manual save must be immediate, not wait out the idle debounce',
        );
        final Note persisted = await readNoteDirectlyFromDatabase(noteId);
        expect(persisted.title, 'manually saved title');
      },
    );

    test(
      'worst case: title and body typed in the same burst, neither trigger given '
      'time to settle, are both still committed once the app is backgrounded',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        final NoteEditorBloc bloc = buildBloc();
        addTearDown(bloc.close);

        bloc.add(const NoteEditorEvent.started());
        await expectLater(bloc.stream, emitsThrough(isA<NoteEditorNotSaved>()));
        final String noteId = (bloc.state as NoteEditorNotSaved).viewModel.noteId;

        bloc.add(const NoteEditorEvent.titleChanged('burst title'));
        bloc.add(const NoteEditorEvent.bodyChanged('burst body'));
        lifecycleController.add(AppLifecycleState.detached);
        // Bounded, well under the 300ms idle debounce the titleChanged/
        // bodyChanged events above started -- see the app-lifecycle test's
        // comment for why an unbounded wait here would hide a real
        // regression in the lifecycle-triggered immediate save.
        await Future<void>.delayed(const Duration(milliseconds: 100));

        expect(bloc.state, isA<NoteEditorSaved>());
        final Note persisted = await readNoteDirectlyFromDatabase(noteId);
        expect(persisted.title, 'burst title');
        expect(persisted.body, 'burst body');
      },
    );
  });
}
