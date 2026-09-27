import 'package:knowledge_hub/core/error/failure.dart';
import 'package:knowledge_hub/core/error/result.dart';

/// Async, takes params — the common case: hits a repository/data source.
abstract class UseCase<S, P> {
  Future<Result<Failure, S>> call(P params);
}

/// Async, no params — e.g. "refresh the cached list", "get the current user".
abstract class UseCaseNoParams<S> {
  Future<Result<Failure, S>> call();
}

/// Sync, takes params — pure computation on already-available data, no I/O.
abstract class SyncUseCase<S, P> {
  Result<Failure, S> call(P params);
}

/// Sync, no params — pure computation needing no input.
abstract class SyncUseCaseNoParams<S> {
  Result<Failure, S> call();
}

/// Reactive, takes params — watches a live local data source (e.g. a Drift
/// `.watch()` query) and re-emits on every change. Not for remote polling.
abstract class StreamUseCase<S, P> {
  Stream<Result<Failure, S>> call(P params);
}

/// Reactive, no params — e.g. "watch the current folder list".
abstract class StreamUseCaseNoParams<S> {
  Stream<Result<Failure, S>> call();
}
