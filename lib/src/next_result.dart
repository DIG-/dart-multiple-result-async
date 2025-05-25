import 'dart:async';

import 'package:multiple_result/multiple_result.dart';

import 'next_future_result.dart';

extension NextResult<T, E> on Result<T, E> {
  /// Converts a [Result<T, E>] to a [Future<Result<T, E>>] and map it to a [Result<U, E>].
  /// See [Future<Result<T, E>>.next()] for more details.
  Future<Result<U, E>> next<U>({
    required final FutureOr<Result<U, E>> Function(T success) onSuccess,
    final FutureOr<Result<U, E>> Function(E error)? onError,
  }) =>
      Future.value(this).next(onSuccess: onSuccess, onError: onError);
}
