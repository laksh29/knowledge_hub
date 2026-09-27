import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note_list_filter.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/permanently_delete_note_uc.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/restore_note_from_trash_uc.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/watch_filtered_notes_uc.dart';
import 'package:knowledge_hub/features/notes/presentation/cubit/trash/trash_cubit.dart';
import 'package:knowledge_hub/features/notes/presentation/cubit/trash/trash_state.dart';
import 'package:mocktail/mocktail.dart';

class MockWatchFilteredNotesUc extends Mock implements WatchFilteredNotesUc {}

class MockRestoreNoteFromTrashUc extends Mock implements RestoreNoteFromTrashUc {}

class MockPermanentlyDeleteNoteUc extends Mock implements PermanentlyDeleteNoteUc {}

void main() {
  late MockWatchFilteredNotesUc watchFilteredNotesUc;
  late MockRestoreNoteFromTrashUc restoreNoteFromTrashUc;
  late MockPermanentlyDeleteNoteUc permanentlyDeleteNoteUc;

  const NoteListFilterParams trashFilter = NoteListFilterParams(
    lifecycleScope: NoteLifecycleScope.trash,
  );

  Note buildTrashedNote(String id, {required DateTime deletedAt}) => Note(
    id: id,
    title: 'Note $id',
    body: 'Body $id',
    createdAt: DateTime.utc(2026, 1, 1),
    updatedAt: DateTime.utc(2026, 1, 1),
    deletedAt: deletedAt,
  );

  TrashCubit buildCubit() => TrashCubit(
    watchFilteredNotesUc: watchFilteredNotesUc,
    restoreNoteFromTrashUc: restoreNoteFromTrashUc,
    permanentlyDeleteNoteUc: permanentlyDeleteNoteUc,
  );

  setUp(() {
    watchFilteredNotesUc = MockWatchFilteredNotesUc();
    restoreNoteFromTrashUc = MockRestoreNoteFromTrashUc();
    permanentlyDeleteNoteUc = MockPermanentlyDeleteNoteUc();
    // The constructor immediately subscribes with the trash-scoped filter --
    // stub a default so every test's setUp doesn't hit a MissingStubError
    // before the test body overrides it with a more specific stub.
    when(
      () => watchFilteredNotesUc.call(trashFilter),
    ).thenAnswer((_) => Stream<Result<Failure, List<Note>>>.value(const Ok(<Note>[])));
  });

  group('TrashCubit', () {
    test(
      'constructor subscribes with NoteListFilterParams(lifecycleScope: trash) and '
      'watch subscription Ok(notes) maps to TrashLoaded with correctly converted '
      'TrashedNoteViewModels, including a correct daysRemainingLabel',
      () async {
        final DateTime fiveDaysAgo = DateTime.now().subtract(const Duration(days: 5));
        final List<Note> trashedNotes = <Note>[
          buildTrashedNote('note-1', deletedAt: fiveDaysAgo),
        ];
        when(
          () => watchFilteredNotesUc.call(trashFilter),
        ).thenAnswer((_) => Stream<Result<Failure, List<Note>>>.value(Ok(trashedNotes)));

        final TrashCubit cubit = buildCubit();
        addTearDown(cubit.close);
        await pumpEventQueue();

        verify(() => watchFilteredNotesUc.call(trashFilter)).called(1);
        expect(cubit.state, isA<TrashLoaded>());
        final TrashLoaded loaded = cubit.state as TrashLoaded;
        expect(loaded.items.map((item) => item.noteId), <String>['note-1']);
        expect(loaded.items.single.deletedAt, fiveDaysAgo);
        // 30-day window minus 5 already-elapsed days == 25 days remaining.
        expect(loaded.items.single.daysRemainingLabel, '25 days remaining');
      },
    );

    test(
      'restore failure emits TrashActionFailed carrying the exact current list '
      'forward plus the exact error message',
      () async {
        final DateTime deletedAt = DateTime.now().subtract(const Duration(days: 2));
        final List<Note> trashedNotes = <Note>[buildTrashedNote('note-1', deletedAt: deletedAt)];
        when(
          () => watchFilteredNotesUc.call(trashFilter),
        ).thenAnswer((_) => Stream<Result<Failure, List<Note>>>.value(Ok(trashedNotes)));
        when(
          () => restoreNoteFromTrashUc.call('note-1'),
        ).thenAnswer((_) async => const Err(CacheFailure('disk I/O error')));

        final TrashCubit cubit = buildCubit();
        addTearDown(cubit.close);
        await pumpEventQueue();
        expect(cubit.state, isA<TrashLoaded>());

        await cubit.restore('note-1');
        await pumpEventQueue();

        expect(cubit.state, isA<TrashActionFailed>());
        final TrashActionFailed failedState = cubit.state as TrashActionFailed;
        expect(failedState.currentItems.map((item) => item.noteId), <String>['note-1']);
        expect(
          failedState.errorMessage,
          "We couldn't complete that action because of a local storage problem. "
          'Please try again in a moment — your notes are safe.',
        );
      },
    );

    test(
      'permanentlyDelete failure emits TrashActionFailed carrying the exact current '
      'list forward plus the exact error message',
      () async {
        final DateTime deletedAt = DateTime.now().subtract(const Duration(days: 2));
        final List<Note> trashedNotes = <Note>[buildTrashedNote('note-1', deletedAt: deletedAt)];
        when(
          () => watchFilteredNotesUc.call(trashFilter),
        ).thenAnswer((_) => Stream<Result<Failure, List<Note>>>.value(Ok(trashedNotes)));
        when(
          () => permanentlyDeleteNoteUc.call('note-1'),
        ).thenAnswer((_) async => const Err(ValidationFailure('Cannot delete this note')));

        final TrashCubit cubit = buildCubit();
        addTearDown(cubit.close);
        await pumpEventQueue();
        expect(cubit.state, isA<TrashLoaded>());

        await cubit.permanentlyDelete('note-1');
        await pumpEventQueue();

        expect(cubit.state, isA<TrashActionFailed>());
        final TrashActionFailed failedState = cubit.state as TrashActionFailed;
        expect(failedState.currentItems.map((item) => item.noteId), <String>['note-1']);
        expect(failedState.errorMessage, 'Cannot delete this note');
      },
    );

    test(
      'a WatchFilteredNotesUc stream failure emits the dedicated TrashListLoadFailed '
      'state, never TrashActionFailed -- no restore/permanentlyDelete was attempted',
      () async {
        when(() => watchFilteredNotesUc.call(trashFilter)).thenAnswer(
          (_) =>
              Stream<Result<Failure, List<Note>>>.value(const Err(CacheFailure('disk I/O error'))),
        );

        final TrashCubit cubit = buildCubit();
        addTearDown(cubit.close);
        await pumpEventQueue();

        expect(cubit.state, isA<TrashListLoadFailed>());
        expect((cubit.state as TrashListLoadFailed).errorMessage, isNotEmpty);
      },
    );

    test(
      'restoring an item successfully updates the exposed list once the underlying '
      'watch stream reflects the change -- the Cubit does not manually mutate the '
      'list itself',
      () async {
        final DateTime deletedAt = DateTime.now().subtract(const Duration(days: 2));
        final List<Note> beforeRestore = <Note>[
          buildTrashedNote('note-1', deletedAt: deletedAt),
          buildTrashedNote('note-2', deletedAt: deletedAt),
        ];
        final List<Note> afterRestore = <Note>[buildTrashedNote('note-2', deletedAt: deletedAt)];

        // A StreamController (rather than `Stream.fromIterable`) lets this
        // test control exactly *when* the underlying watch stream's second
        // value lands -- after `restore` has already been invoked --
        // instead of both values being delivered back-to-back before the
        // Cubit's `restore` method is ever called.
        final StreamController<Result<Failure, List<Note>>> trashStreamController =
            StreamController<Result<Failure, List<Note>>>();
        addTearDown(trashStreamController.close);
        when(
          () => watchFilteredNotesUc.call(trashFilter),
        ).thenAnswer((_) => trashStreamController.stream);
        when(() => restoreNoteFromTrashUc.call('note-1')).thenAnswer((_) async => const Ok(null));

        final TrashCubit cubit = buildCubit();
        addTearDown(cubit.close);
        trashStreamController.add(Ok(beforeRestore));
        await pumpEventQueue();

        expect(
          (cubit.state as TrashLoaded).items.map((item) => item.noteId),
          <String>['note-1', 'note-2'],
        );

        await cubit.restore('note-1');
        await pumpEventQueue();
        verify(() => restoreNoteFromTrashUc.call('note-1')).called(1);
        // No manual list mutation -- the state should still reflect the
        // pre-restore list until the underlying watch stream itself emits
        // the updated data.
        expect(
          (cubit.state as TrashLoaded).items.map((item) => item.noteId),
          <String>['note-1', 'note-2'],
        );

        trashStreamController.add(Ok(afterRestore));
        await pumpEventQueue();

        expect(cubit.state, isA<TrashLoaded>());
        expect(
          (cubit.state as TrashLoaded).items.map((item) => item.noteId),
          <String>['note-2'],
        );
      },
    );

    test(
      'permanently deleting an item successfully updates the exposed list once the '
      'underlying watch stream reflects the change',
      () async {
        final DateTime deletedAt = DateTime.now().subtract(const Duration(days: 2));
        final List<Note> beforeDelete = <Note>[buildTrashedNote('note-1', deletedAt: deletedAt)];
        final List<Note> afterDelete = <Note>[];

        final StreamController<Result<Failure, List<Note>>> trashStreamController =
            StreamController<Result<Failure, List<Note>>>();
        addTearDown(trashStreamController.close);
        when(
          () => watchFilteredNotesUc.call(trashFilter),
        ).thenAnswer((_) => trashStreamController.stream);
        when(
          () => permanentlyDeleteNoteUc.call('note-1'),
        ).thenAnswer((_) async => const Ok(null));

        final TrashCubit cubit = buildCubit();
        addTearDown(cubit.close);
        trashStreamController.add(Ok(beforeDelete));
        await pumpEventQueue();

        expect((cubit.state as TrashLoaded).items, hasLength(1));

        await cubit.permanentlyDelete('note-1');
        await pumpEventQueue();
        verify(() => permanentlyDeleteNoteUc.call('note-1')).called(1);
        expect((cubit.state as TrashLoaded).items, hasLength(1));

        trashStreamController.add(Ok(afterDelete));
        await pumpEventQueue();

        expect(cubit.state, isA<TrashLoaded>());
        expect((cubit.state as TrashLoaded).items, isEmpty);
      },
    );
  });
}
