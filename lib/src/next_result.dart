import 'dart:async';

import 'package:multiple_result/multiple_result.dart';

import 'util.dart';

extension NextResult<T, E> on Result<T, E> {
  Future<Result<U, E>> _nextWithoutTryCatch<U>({
    required final FutureOr<Result<U, E>> Function(T value) onSuccess,
    final FutureOr<Result<U, E>> Function(E errror)? onError,
  }) async {
    return switch (this) {
      Success<T, E>(success: final T value) => await onSuccess(value),
      Error<T, E>(error: final E error) =>
        onError == null ? Error(error) : await onError(error),
    };
  }

  Future<Result<U, E>> _nextWithTryCatch<U>({
    required final FutureOr<Result<U, E>> Function(T value) onSuccess,
    final FutureOr<Result<U, E>> Function(E errror)? onError,
  }) async {
    try {
      return await _nextWithoutTryCatch(
        onSuccess: onSuccess,
        onError: onError,
      );
    } catch (error) {
      if (error case final E error) {
        if (onError != null) {
          return await ErrorHandler.handle(error, onError);
        } else {
          return Error(error);
        }
      }
      rethrow;
    }
  }

  @pragma('vm:prefer-inline')
  Future<Result<U, E>> next<U>({
    required final FutureOr<Result<U, E>> Function(T value) onSuccess,
    final FutureOr<Result<U, E>> Function(E errror)? onError,
    final bool useTryCatch = true,
  }) =>
      useTryCatch
          ? _nextWithTryCatch(
              onSuccess: onSuccess,
              onError: onError,
            )
          : _nextWithoutTryCatch(
              onSuccess: onSuccess,
              onError: onError,
            );
}
