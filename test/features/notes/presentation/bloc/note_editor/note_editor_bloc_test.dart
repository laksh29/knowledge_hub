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
  });
}
