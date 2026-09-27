import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/features/notes/domain/entities/folder.dart';
import 'package:knowledge_hub/features/notes/domain/repositories/folders_repository.dart';
import 'package:knowledge_hub/features/notes/domain/usecases/watch_folders_uc.dart';
import 'package:mocktail/mocktail.dart';

class MockFoldersRepository extends Mock implements FoldersRepository {}

void main() {
  late MockFoldersRepository foldersRepository;
  late WatchFoldersUc watchFoldersUc;

  const Folder tFolder = Folder(id: 'folder-1', name: 'Coursework');

  setUp(() {
    foldersRepository = MockFoldersRepository();
    watchFoldersUc = WatchFoldersUc(foldersRepository);
  });

  test(
    'calls the repository\'s watchFolders exactly once and emits its '
    'successful stream events unchanged',
    () async {
      when(() => foldersRepository.watchFolders()).thenAnswer(
        (_) => Stream<Result<Failure, List<Folder>>>.value(
          const Ok<Failure, List<Folder>>(<Folder>[tFolder]),
        ),
      );

      final Stream<Result<Failure, List<Folder>>> resultStream =
          watchFoldersUc.call();

      await expectLater(
        resultStream,
        emits(
          isA<Ok<Failure, List<Folder>>>().having(
            (Ok<Failure, List<Folder>> ok) => ok.value,
            'value',
            <Folder>[tFolder],
          ),
        ),
      );
      verify(() => foldersRepository.watchFolders()).called(1);
      verifyNoMoreInteractions(foldersRepository);
    },
  );

  test('propagates the repository\'s failure stream events untouched', () async {
    const ServerFailure tFailure = ServerFailure('boom');
    when(() => foldersRepository.watchFolders()).thenAnswer(
      (_) => Stream<Result<Failure, List<Folder>>>.value(
        const Err<Failure, List<Folder>>(tFailure),
      ),
    );

    final Stream<Result<Failure, List<Folder>>> resultStream =
        watchFoldersUc.call();

    await expectLater(
      resultStream,
      emits(
        isA<Err<Failure, List<Folder>>>().having(
          (Err<Failure, List<Folder>> err) => err.failure_,
          'failure_',
          same(tFailure),
        ),
      ),
    );
    verify(() => foldersRepository.watchFolders()).called(1);
    verifyNoMoreInteractions(foldersRepository);
  });
}
