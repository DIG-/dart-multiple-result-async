import 'dart:async';

import 'package:multiple_result/multiple_result.dart';

import 'next_future_result.dart';

extension NextResult<T, E> on Result<T, E> {
  Future<Result<U, E>> next<U>({
    required final FutureOr<Result<U, E>> Function(T success) onSuccess,
    final FutureOr<Result<U, E>> Function(E error)? onError,
  }) =>
      Future.value(this).next(onSuccess: onSuccess, onError: onError);
}
