import 'dart:async';

import 'package:multiple_result/multiple_result.dart';

import 'next_future_result.dart';

extension NextResult<T, E> on Result<T, E> {
  Future<Result<U, E>> next<U>({
    required final FutureOr<Result<U, E>> Function(T value) onSuccess,
    final FutureOr<Result<U, E>> Function(E errror)? onError,
  }) =>
      Future.value(this).next(onSuccess: onSuccess, onError: onError);
}
