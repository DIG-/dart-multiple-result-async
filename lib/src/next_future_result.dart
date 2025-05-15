import 'dart:async';

import 'package:multiple_result/multiple_result.dart';

import 'next_result.dart';
import 'util.dart';

extension NextFutureResult<T, E> on Future<Result<T, E>> {
  Future<Result<U, E>> next<U>({
    required final FutureOr<Result<U, E>> Function(T value) onSuccess,
    final FutureOr<Result<U, E>> Function(E errror)? onError,
  }) async {
    final Result<T, E> result;
    try {
      result = await this;
    } catch (error) {
      if (error case final E error) {
        if (onError != null) {
          return await ErrorHandler.handle(
            error,
            onError,
          );
        }
        return Error(error);
      }
      rethrow;
    }
    return await result.next(
      onSuccess: onSuccess,
      onError: onError,
    );
  }
}
