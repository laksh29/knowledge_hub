import 'package:knowledge_hub/core/error/failure.dart';

sealed class Result<F extends Failure, S> {
  const Result();

  T when<T>({
    required T Function(F failure) failure,
    required T Function(S success) success,
  }) => switch (this) {
    Err(:final failure_) => failure(failure_),
    Ok(:final value) => success(value),
  };

  bool get isOk => this is Ok<F, S>;
  bool get isErr => this is Err<F, S>;
}

final class Ok<F extends Failure, S> extends Result<F, S> {
  const Ok(this.value);
  final S value;
}

final class Err<F extends Failure, S> extends Result<F, S> {
  const Err(this.failure_);
  final F failure_;
}
