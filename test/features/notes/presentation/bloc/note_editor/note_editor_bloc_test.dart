import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/notes_repository.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/create_note_uc.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/save_note_content_uc.dart';
import 'package:knowledge_hub/features/notes/presentation/bloc/note_editor/note_editor_bloc.dart';
import 'package:knowledge_hub/features/notes/presentation/bloc/note_editor/note_editor_event.dart';
import 'package:knowledge_hub/features/notes/presentation/bloc/note_editor/note_editor_state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app_lifecycle_service/app_lifecycle_service.dart';

class MockCreateNoteUc extends Mock implements CreateNoteUc {}

class MockSaveNoteContentUc extends Mock implements SaveNoteContentUc {}

class MockAppLifecycleService extends Mock implements AppLifecycleService {}

// USER-IMPLEMENT (notes-mvp task 4.2): these express the intended behavior
// of NoteEditorBloc's autosave state machine and currently fail because
// every event handler throws UnimplementedError. See note_editor_bloc.dart's
// class-level design note for the four-trigger orchestration this bloc must
// implement — bloc_test could not be added to this project (see design.md's
// 2026-08-30 tooling correction under "Testing Strategy"), so these tests
// drive the bloc directly and assert on its state stream with plain
// flutter_test.
void main() {
  late MockCreateNoteUc createNoteUc;
  late MockSaveNoteContentUc saveNoteContentUc;
  late MockAppLifecycleService appLifecycleService;

  final Note tNote = Note(
    id: 'note-1',
    title: '',
    body: '',
    createdAt: DateTime.utc(2026, 1, 1),
    updatedAt: DateTime.utc(2026, 1, 1),
  );

  setUpAll(() {
    registerFallbackValue(
      const SaveNoteContentParams(noteId: 'fallback', title: 'fallback', body: 'fallback'),
    );
  });

  setUp(() {
    createNoteUc = MockCreateNoteUc();
    saveNoteContentUc = MockSaveNoteContentUc();
    appLifecycleService = MockAppLifecycleService();
    when(() => appLifecycleService.lifecycleChanges).thenAnswer((_) => const Stream.empty());
  });

  NoteEditorBloc buildBloc() => NoteEditorBloc(
    createNoteUc: createNoteUc,
    saveNoteContentUc: saveNoteContentUc,
    appLifecycleService: appLifecycleService,
  );

  group('NoteEditorBloc (USER-IMPLEMENT)', () {
    test(
      'the manual-save trigger converges through notSaved -> saving -> saved, '
      'the same sequence every other trigger must also produce',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(() => createNoteUc.call()).thenAnswer((_) async => Ok(tNote));
        when(
          () => saveNoteContentUc.call(any()),
        ).thenAnswer((_) async => Ok(tNote.copyWith(title: 'Groceries')));

        final NoteEditorBloc bloc = buildBloc();
        addTearDown(bloc.close);

        bloc.add(const NoteEditorEvent.started());
        bloc.add(const NoteEditorEvent.titleChanged('Groceries'));
        bloc.add(const NoteEditorEvent.manualSaveRequested());

        await expectLater(
          bloc.stream,
          emitsInOrder(<Matcher>[
            isA<NoteEditorNotSaved>(),
            isA<NoteEditorSaving>(),
            isA<NoteEditorSaved>(),
          ]),
        );
      },
    );

    test(
      'a failed save emits NoteEditorSaveFailed carrying the in-progress draft, '
      'never discarding what the user typed',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(() => createNoteUc.call()).thenAnswer((_) async => Ok(tNote));
        when(
          () => saveNoteContentUc.call(any()),
        ).thenAnswer((_) async => const Err(CacheFailure('disk I/O error')));

        final NoteEditorBloc bloc = buildBloc();
        addTearDown(bloc.close);

        bloc.add(const NoteEditorEvent.started());
        bloc.add(const NoteEditorEvent.titleChanged('Unsaved draft title'));
        bloc.add(const NoteEditorEvent.manualSaveRequested());

        await expectLater(
          bloc.stream,
          emitsThrough(
            predicate<NoteEditorState>(
              (NoteEditorState state) =>
                  state is NoteEditorSaveFailed &&
                  state.viewModel.title == 'Unsaved draft title',
              'NoteEditorSaveFailed carrying the draft title the user typed',
            ),
          ),
        );
      },
    );

    test(
      'the idle-debounce trigger saves a short body once 300ms of no further '
      'input has passed, without a manual/threshold/lifecycle trigger',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(() => createNoteUc.call()).thenAnswer((_) async => Ok(tNote));
        when(
          () => saveNoteContentUc.call(any()),
        ).thenAnswer((_) async => Ok(tNote.copyWith(body: 'short body')));

        final NoteEditorBloc bloc = buildBloc();
        addTearDown(bloc.close);

        bloc.add(const NoteEditorEvent.started());
        bloc.add(const NoteEditorEvent.bodyChanged('short body'));

        await expectLater(
          bloc.stream,
          emitsThrough(
            predicate<NoteEditorState>(
              (NoteEditorState state) => state is NoteEditorSaved,
              'NoteEditorSaved reached purely via the idle debounce, no other trigger fired',
            ),
          ),
        );
        verify(() => saveNoteContentUc.call(any())).called(1);
      },
    );

    test(
      'the 100-character threshold trigger saves immediately, well before the '
      '300ms idle debounce would have settled',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(() => createNoteUc.call()).thenAnswer((_) async => Ok(tNote));
        final String longBody = 'x' * 120;
        when(
          () => saveNoteContentUc.call(any()),
        ).thenAnswer((_) async => Ok(tNote.copyWith(body: longBody)));

        final NoteEditorBloc bloc = buildBloc();
        addTearDown(bloc.close);

        bloc.add(const NoteEditorEvent.started());
        bloc.add(NoteEditorEvent.bodyChanged(longBody));
        await Future<void>.delayed(const Duration(milliseconds: 100));

        expect(
          bloc.state,
          isA<NoteEditorSaved>(),
          reason:
              'a 120-char body crosses the 100-char threshold and must force-save '
              'well before the 300ms debounce would otherwise settle',
        );
      },
    );

    test(
      'the app-lifecycle trigger saves immediately on paused/inactive/detached, '
      'not on resumed/hidden',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        final lifecycleController = StreamController<AppLifecycleState>();
        addTearDown(lifecycleController.close);
        when(
          () => appLifecycleService.lifecycleChanges,
        ).thenAnswer((_) => lifecycleController.stream);

        when(() => createNoteUc.call()).thenAnswer((_) async => Ok(tNote));
        when(
          () => saveNoteContentUc.call(any()),
        ).thenAnswer((_) async => Ok(tNote.copyWith(title: 'Lifecycle draft')));

        final NoteEditorBloc bloc = buildBloc();
        addTearDown(bloc.close);

        bloc.add(const NoteEditorEvent.started());
        bloc.add(const NoteEditorEvent.titleChanged('Lifecycle draft'));
        await pumpEventQueue();

        // resumed must NOT trigger a save.
        lifecycleController.add(AppLifecycleState.resumed);
        await pumpEventQueue();
        expect(bloc.state, isNot(isA<NoteEditorSaved>()));

        // paused must trigger an immediate save.
        lifecycleController.add(AppLifecycleState.paused);

        await expectLater(
          bloc.stream,
          emitsThrough(
            predicate<NoteEditorState>(
              (NoteEditorState state) =>
                  state is NoteEditorSaved && state.viewModel.title == 'Lifecycle draft',
              'NoteEditorSaved triggered by the paused lifecycle transition',
            ),
          ),
        );
      },
    );

    test(
      'a failing CreateNoteUc emits the retryable NoteEditorCreationFailed state, '
      'and re-dispatching started() recovers once CreateNoteUc succeeds',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(
          () => createNoteUc.call(),
        ).thenAnswer((_) async => const Err(CacheFailure('disk I/O error')));

        final NoteEditorBloc bloc = buildBloc();
        addTearDown(bloc.close);

        bloc.add(const NoteEditorEvent.started());

        await expectLater(
          bloc.stream,
          emitsThrough(isA<NoteEditorCreationFailed>()),
        );

        when(() => createNoteUc.call()).thenAnswer((_) async => Ok(tNote));
        bloc.add(const NoteEditorEvent.started());

        await expectLater(bloc.stream, emitsThrough(isA<NoteEditorNotSaved>()));
      },
    );

    test(
      'folderId/tagIds survive into NoteEditorSaving and NoteEditorSaveFailed, '
      'not just NoteEditorNotSaved -- every non-initializing state must carry '
      'the same viewModel forward, per the class-level design note',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        final Note filedAndTaggedNote = Note(
          id: 'note-1',
          title: '',
          body: '',
          folderId: 'folder-abc',
          tagIds: const <String>['tag-1', 'tag-2'],
          createdAt: DateTime.utc(2026, 1, 1),
          updatedAt: DateTime.utc(2026, 1, 1),
        );
        when(() => createNoteUc.call()).thenAnswer((_) async => Ok(filedAndTaggedNote));
        when(
          () => saveNoteContentUc.call(any()),
        ).thenAnswer((_) async => const Err(CacheFailure('disk I/O error')));

        final NoteEditorBloc bloc = buildBloc();
        addTearDown(bloc.close);

        bloc.add(const NoteEditorEvent.started());
        bloc.add(const NoteEditorEvent.manualSaveRequested());

        await expectLater(
          bloc.stream,
          emitsInOrder(<Matcher>[
            predicate<NoteEditorState>(
              (NoteEditorState state) =>
                  state is NoteEditorNotSaved && state.viewModel.folderId == 'folder-abc',
              'NoteEditorNotSaved carries folderId',
            ),
            predicate<NoteEditorState>(
              (NoteEditorState state) =>
                  state is NoteEditorSaving && state.viewModel.folderId == 'folder-abc',
              'NoteEditorSaving carries folderId',
            ),
            predicate<NoteEditorState>(
              (NoteEditorState state) =>
                  state is NoteEditorSaveFailed &&
                  state.viewModel.folderId == 'folder-abc' &&
                  state.viewModel.tagIds.length == 2,
              'NoteEditorSaveFailed carries folderId and tagIds',
            ),
          ]),
        );
      },
    );
  });
}
