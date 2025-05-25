import 'dart:async';

import 'package:multiple_result/multiple_result.dart';

extension NextFutureResult<T, E> on Future<Result<T, E>> {
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
