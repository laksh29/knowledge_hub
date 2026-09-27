import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';
import 'package:knowledge_hub/core/usecase/usecase.dart';

class FakeSampleValuesSource {
  FakeSampleValuesSource(this._controller);
  final StreamController<Result<Failure, int>> _controller;

  Stream<Result<Failure, int>> watchValues(String sourceId) => _controller.stream;
}

class WatchSampleValuesUc implements StreamUseCase<int, String> {
  const WatchSampleValuesUc(this._source);
  final FakeSampleValuesSource _source;

  @override
  Stream<Result<Failure, int>> call(String params) => _source.watchValues(params);
}

class FakeSampleCurrentValueSource {
  FakeSampleCurrentValueSource(this._controller);
  final StreamController<Result<Failure, int>> _controller;

  Stream<Result<Failure, int>> watchCurrentValue() => _controller.stream;
}

class WatchSampleCurrentValueUc implements StreamUseCaseNoParams<int> {
  const WatchSampleCurrentValueUc(this._source);
  final FakeSampleCurrentValueSource _source;

  @override
  Stream<Result<Failure, int>> call() => _source.watchCurrentValue();
}

void main() {
  group('StreamUseCase', () {
    late StreamController<Result<Failure, int>> controller;
    late FakeSampleValuesSource source;
    late WatchSampleValuesUc useCase;

    setUp(() {
      controller = StreamController<Result<Failure, int>>();
      source = FakeSampleValuesSource(controller);
      useCase = WatchSampleValuesUc(source);
    });

    tearDown(() => controller.close());

    test('forwards a success stream unaltered', () async {
      final Stream<Result<Failure, int>> resultStream = useCase.call('sample-source');

      final Future<void> expectation = expectLater(
        resultStream,
        emitsInOrder(<Object>[
          const Ok<Failure, int>(1),
          const Ok<Failure, int>(2),
          emitsDone,
        ]),
      );

      controller.add(const Ok<Failure, int>(1));
      controller.add(const Ok<Failure, int>(2));
      await controller.close();

      await expectation;
    });

    test('forwards a failure mid-stream without dropping it or terminating the stream', () async {
      final Stream<Result<Failure, int>> resultStream = useCase.call('sample-source');

      final Future<void> expectation = expectLater(
        resultStream,
        emitsInOrder(<Object>[
          const Ok<Failure, int>(1),
          isA<Err<Failure, int>>().having(
            (Err<Failure, int> err) => err.failure_,
            'failure_',
            isA<ServerFailure>(),
          ),
          const Ok<Failure, int>(3),
          emitsDone,
        ]),
      );

      controller.add(const Ok<Failure, int>(1));
      controller.add(const Err<Failure, int>(ServerFailure()));
      controller.add(const Ok<Failure, int>(3));
      await controller.close();

      await expectation;
    });
  });

  group('StreamUseCaseNoParams', () {
    test('forwards a success stream unaltered with no params required', () async {
      final StreamController<Result<Failure, int>> controller = StreamController<Result<Failure, int>>();
      final FakeSampleCurrentValueSource source = FakeSampleCurrentValueSource(controller);
      final WatchSampleCurrentValueUc useCase = WatchSampleCurrentValueUc(source);

      final Future<void> expectation = expectLater(
        useCase.call(),
        emitsInOrder(<Object>[
          const Ok<Failure, int>(42),
          emitsDone,
        ]),
      );

      controller.add(const Ok<Failure, int>(42));
      await controller.close();

      await expectation;
    });
  });
}
