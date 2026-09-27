import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/domain/entities/folder.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/create_folder_uc.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/delete_folder_uc.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/watch_folders_uc.dart';
import 'package:knowledge_hub/features/notes/presentation/cubit/folder/folder_cubit.dart';
import 'package:knowledge_hub/features/notes/presentation/cubit/folder/folder_state.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateFolderUc extends Mock implements CreateFolderUc {}

class MockWatchFoldersUc extends Mock implements WatchFoldersUc {}

class MockDeleteFolderUc extends Mock implements DeleteFolderUc {}

void main() {
  late MockCreateFolderUc createFolderUc;
  late MockWatchFoldersUc watchFoldersUc;
  late MockDeleteFolderUc deleteFolderUc;

  Folder buildFolder(String id, String name) => Folder(id: id, name: name);

  FolderCubit buildCubit() =>
      FolderCubit(
        createFolderUc: createFolderUc,
        watchFoldersUc: watchFoldersUc,
        deleteFolderUc: deleteFolderUc,
      );

  setUp(() {
    createFolderUc = MockCreateFolderUc();
    watchFoldersUc = MockWatchFoldersUc();
    deleteFolderUc = MockDeleteFolderUc();
    // The constructor immediately subscribes -- stub a default so every
    // test's setUp doesn't hit a MissingStubError before the test body
    // overrides it with a more specific stub.
    when(
      () => watchFoldersUc.call(),
    ).thenAnswer((_) => Stream<Result<Failure, List<Folder>>>.value(const Ok(<Folder>[])));
  });

  group('FolderCubit', () {
    test(
      'watchFolders live subscription maps Ok(folders) to FolderListLoaded '
      'with correctly converted FolderViewModels',
      () async {
        final List<Folder> folders = <Folder>[
          buildFolder('folder-1', 'Work'),
          buildFolder('folder-2', 'Personal'),
        ];
        when(
          () => watchFoldersUc.call(),
        ).thenAnswer((_) => Stream<Result<Failure, List<Folder>>>.value(Ok(folders)));

        final FolderCubit cubit = buildCubit();
        addTearDown(cubit.close);
        await pumpEventQueue();

        expect(cubit.state, isA<FolderListLoaded>());
        final FolderListLoaded loaded = cubit.state as FolderListLoaded;
        expect(loaded.folders.map((f) => f.folderId), <String>['folder-1', 'folder-2']);
        expect(loaded.folders.map((f) => f.name), <String>['Work', 'Personal']);
      },
    );

    test(
      'createFolder with a duplicate name emits FolderCreationFailed carrying '
      'the existing folder list forward plus a specific error message',
      () async {
        final List<Folder> existingFolders = <Folder>[buildFolder('folder-1', 'Work')];
        when(
          () => watchFoldersUc.call(),
        ).thenAnswer((_) => Stream<Result<Failure, List<Folder>>>.value(Ok(existingFolders)));
        when(() => createFolderUc.call('Work')).thenAnswer(
          (_) async =>
              const Err(DuplicateNameFailure('A folder named "Work" already exists')),
        );

        final FolderCubit cubit = buildCubit();
        addTearDown(cubit.close);
        await pumpEventQueue();
        expect(cubit.state, isA<FolderListLoaded>());

        await cubit.createFolder('Work');
        await pumpEventQueue();

        expect(cubit.state, isA<FolderCreationFailed>());
        final FolderCreationFailed failedState = cubit.state as FolderCreationFailed;
        expect(failedState.currentFolders.map((f) => f.folderId), <String>['folder-1']);
        expect(failedState.currentFolders.map((f) => f.name), <String>['Work']);
        expect(
          failedState.errorMessage,
          'A folder named "Work" already exists — choose a different name.',
        );
      },
    );

    test(
      'createFolder with a non-duplicate failure (CacheFailure) also emits '
      'FolderCreationFailed carrying the existing list forward',
      () async {
        final List<Folder> existingFolders = <Folder>[buildFolder('folder-1', 'Work')];
        when(
          () => watchFoldersUc.call(),
        ).thenAnswer((_) => Stream<Result<Failure, List<Folder>>>.value(Ok(existingFolders)));
        when(
          () => createFolderUc.call('New Folder'),
        ).thenAnswer((_) async => const Err(CacheFailure('disk I/O error')));

        final FolderCubit cubit = buildCubit();
        addTearDown(cubit.close);
        await pumpEventQueue();

        await cubit.createFolder('New Folder');
        await pumpEventQueue();

        expect(cubit.state, isA<FolderCreationFailed>());
        final FolderCreationFailed failedState = cubit.state as FolderCreationFailed;
        expect(failedState.currentFolders.map((f) => f.folderId), <String>['folder-1']);
        expect(failedState.errorMessage, isNotEmpty);
      },
    );

    test(
      'a WatchFoldersUc stream failure emits the dedicated FolderListLoadFailed '
      'state, never FolderCreationFailed -- no folder creation was attempted',
      () async {
        when(() => watchFoldersUc.call()).thenAnswer(
          (_) => Stream<Result<Failure, List<Folder>>>.value(
            const Err(CacheFailure('disk I/O error')),
          ),
        );

        final FolderCubit cubit = buildCubit();
        addTearDown(cubit.close);
        await pumpEventQueue();

        expect(cubit.state, isA<FolderListLoadFailed>());
        expect((cubit.state as FolderListLoadFailed).errorMessage, isNotEmpty);
      },
    );

    test('deleteFolder invokes DeleteFolderUc with the given folderId', () async {
      when(() => deleteFolderUc.call('folder-1')).thenAnswer((_) async => const Ok(null));

      final FolderCubit cubit = buildCubit();
      addTearDown(cubit.close);
      await pumpEventQueue();

      await cubit.deleteFolder('folder-1');
      await pumpEventQueue();

      verify(() => deleteFolderUc.call('folder-1')).called(1);
    });
  });
}
