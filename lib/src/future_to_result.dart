import 'package:multiple_result/multiple_result.dart';

extension FutureToResult<T> on Future<T> {
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
