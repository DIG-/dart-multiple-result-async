import 'dart:async';

import 'package:multiple_result/multiple_result.dart';

extension NextFutureResult<T, E> on Future<Result<T, E>> {
  /// Map a [Future<Result<T, E>>] to a [Future<Result<U, E>>].
  /// Arguments:
  /// - [onSuccess]: A function that takes a [T] and returns a [Result<U, E>], can be async.
  /// - [onError]: A function that takes an [E] and returns a [Result<U, E>], can be async.
  /// If the [onError] function is not provided, the [Result<T, E>] will be wrapped into an [Error<U, E>].
  /// 
  /// If the [Result<T, E>] is a [Success<T, E>], it will be mapped to a [Result<U, E>] using the [onSuccess] function.
  /// If [onSuccess] throws an error of type [E], it will be handled like an [Error<T, E>].
  /// If the [Result<T, E>] is an [Error<T, E>] (or if the [onSuccess] function had throwed error of type [E]):
  ///  - It will be mapped to a [Result<U, E>] using the [onError] function if provided.
  ///  - It will be wrapped into [Error<U, E>].
  /// If the [onError] function throws an error of type [E], it will be wrapped into [Error<U, E>] .
  Future<Result<U, E>> next<U>({
    required final FutureOr<Result<U, E>> Function(T success) onSuccess,
    final FutureOr<Result<U, E>> Function(E error)? onError,
  }) {
    // Avoiding expliciity try-catch and async-await is faster here, since Future has it own exception handling
    var skipOuterCatch = false;
    return then((final result) {
      switch (result) {
        case Success<T, E>(success: final T suuccess):
          return onSuccess(suuccess);
        case Error<T, E>(error: final E error):
          skipOuterCatch = true;
          if (onError != null) {
            return onError(error);
          }
          return Error<U, E>(error);
      }
    })
        .catchError(
          (final error) => onError!(error as E),
          test: (final error) =>
              !skipOuterCatch && onError != null && error is E,
        )
        .catchError(
          (final error) => Error<U, E>(error),
          test: (final error) => error is E,
        );
  }
}
