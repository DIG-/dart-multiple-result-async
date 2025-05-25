import 'package:multiple_result/multiple_result.dart';

extension FutureToResult<T> on Future<T> {
  /// Converts a [Future<T>] to a [Future<Result<T, E>>] without handling any errors from the [Future].
  @pragma('vm:prefer-inline')
  Future<Result<T, E>> toResult<U, E>() {
    assert(
      T == U,
      'The type of the Future must be the same as the type of the Result. T=$T, U=$U',
    );
    return then<Result<T, E>>(
      // It is faster to use a lambda here
      // ignore: unnecessary_lambdas
      (final value) => Success<T, E>(value),
    );
  }

  /// Converts a [Future<T>] to a [Future<Result<T, E>>].
  /// If the [Future] completes with an error of type [E], it will be wrapped with [Error<T, E>].
  @pragma('vm:prefer-inline')
  Future<Result<T, E>> toResultOrError<E>() {
    return then<Result<T, E>>(
      // It is faster to use a lambda here
      // ignore: unnecessary_lambdas
      (final value) => Success<T, E>(value),
    ).catchError(
      (final error) => Error<T, E>(error),
      test: (final error) => error is E,
    );
  }
}
