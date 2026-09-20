import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note.dart';
import 'package:knowledge_hub/features/notes/domain/entities/note_list_filter.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/watch_filtered_notes_uc.dart';
import 'package:knowledge_hub/features/notes/presentation/cubit/note_list/note_list_cubit.dart';
import 'package:knowledge_hub/features/notes/presentation/cubit/note_list/note_list_state.dart';
import 'package:mocktail/mocktail.dart';

class MockWatchFilteredNotesUc extends Mock implements WatchFilteredNotesUc {}

void main() {
  late MockWatchFilteredNotesUc watchFilteredNotesUc;

  Note buildNote(String id) => Note(
    id: id,
    title: 'Note $id',
    body: 'Body $id',
    createdAt: DateTime.utc(2026, 1, 1),
    updatedAt: DateTime.utc(2026, 1, 1),
  );

  setUpAll(() {
    registerFallbackValue(const NoteListFilterParams());
  });

  setUp(() {
    watchFilteredNotesUc = MockWatchFilteredNotesUc();
    // The constructor immediately subscribes with the default filter --
    // stub it so every test's setUp doesn't hit a MissingStubError before
    // the test body overrides it with a more specific stub.
    when(
      () => watchFilteredNotesUc.call(any()),
    ).thenAnswer((_) => Stream<Result<Failure, List<Note>>>.value(const Ok(<Note>[])));
  });

  group('NoteListCubit', () {
    test(
      'selectFolder(id) re-invokes WatchFilteredNotesUc with that folderId and '
      'the resulting state reflects the correctly filtered list',
      () async {
        const NoteListFilterParams paramsForFolder = NoteListFilterParams(folderId: 'folder-1');
        final List<Note> notesInFolder = <Note>[buildNote('note-1')];
        when(
          () => watchFilteredNotesUc.call(paramsForFolder),
        ).thenAnswer((_) => Stream<Result<Failure, List<Note>>>.value(Ok(notesInFolder)));

        final NoteListCubit cubit = NoteListCubit(watchFilteredNotesUc: watchFilteredNotesUc);
        addTearDown(cubit.close);

        cubit.selectFolder('folder-1');
        await pumpEventQueue();

        verify(() => watchFilteredNotesUc.call(paramsForFolder)).called(1);
        final NoteListState state = cubit.state;
        expect(state, isA<NoteListLoaded>());
        expect((state as NoteListLoaded).notes.map((n) => n.noteId), <String>['note-1']);
        expect(state.activeFilter.folderId, 'folder-1');
      },
    );

    test('toggleTag(id) adds the tag, then toggling the same id again removes it', () async {
      const NoteListFilterParams paramsWithTag = NoteListFilterParams(
        tagIds: <String>['tag-urgent'],
      );
      const NoteListFilterParams paramsWithoutTag = NoteListFilterParams();
      when(
        () => watchFilteredNotesUc.call(paramsWithTag),
      ).thenAnswer((_) => Stream<Result<Failure, List<Note>>>.value(const Ok(<Note>[])));

      final NoteListCubit cubit = NoteListCubit(watchFilteredNotesUc: watchFilteredNotesUc);
      addTearDown(cubit.close);
      await pumpEventQueue();

      cubit.toggleTag('tag-urgent');
      await pumpEventQueue();
      expect((cubit.state as NoteListLoaded).activeFilter.tagIds, <String>['tag-urgent']);
      verify(() => watchFilteredNotesUc.call(paramsWithTag)).called(1);

      cubit.toggleTag('tag-urgent');
      await pumpEventQueue();
      expect((cubit.state as NoteListLoaded).activeFilter.tagIds, isEmpty);
      // paramsWithoutTag matches the constructor's own initial subscription
      // plus this second re-toggle -- called twice in total.
      verify(() => watchFilteredNotesUc.call(paramsWithoutTag)).called(2);
    });

    test(
      'setTagFilterMode(mode) forwards the updated mode to WatchFilteredNotesUc '
      'without reimplementing AND/OR matching logic here',
      () async {
        const NoteListFilterParams paramsAllOf = NoteListFilterParams(
          tagFilterMode: TagFilterMode.allOf,
        );
        when(
          () => watchFilteredNotesUc.call(paramsAllOf),
        ).thenAnswer((_) => Stream<Result<Failure, List<Note>>>.value(const Ok(<Note>[])));

        final NoteListCubit cubit = NoteListCubit(watchFilteredNotesUc: watchFilteredNotesUc);
        addTearDown(cubit.close);

        cubit.setTagFilterMode(TagFilterMode.allOf);
        await pumpEventQueue();

        verify(() => watchFilteredNotesUc.call(paramsAllOf)).called(1);
        expect((cubit.state as NoteListLoaded).activeFilter.tagFilterMode, TagFilterMode.allOf);
      },
    );

    test('NoteListLoaded carries an empty list when the stream emits Ok([])', () async {
      final NoteListCubit cubit = NoteListCubit(watchFilteredNotesUc: watchFilteredNotesUc);
      addTearDown(cubit.close);
      await pumpEventQueue();

      expect(cubit.state, isA<NoteListLoaded>());
      expect((cubit.state as NoteListLoaded).notes, isEmpty);
    });

    test('a stream failure emits NoteListLoadFailed with a specific message', () async {
      when(() => watchFilteredNotesUc.call(any())).thenAnswer(
        (_) => Stream<Result<Failure, List<Note>>>.value(
          const Err(CacheFailure('disk I/O error')),
        ),
      );

      final NoteListCubit cubit = NoteListCubit(watchFilteredNotesUc: watchFilteredNotesUc);
      addTearDown(cubit.close);
      await pumpEventQueue();

      expect(cubit.state, isA<NoteListLoadFailed>());
      expect((cubit.state as NoteListLoadFailed).errorMessage, isNotEmpty);
    });
  });
}
