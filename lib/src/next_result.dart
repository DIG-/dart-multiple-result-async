import 'dart:async';

import 'package:multiple_result/multiple_result.dart';

import 'util.dart';

extension NextResult<T, E> on Result<T, E> {
  Future<Result<U, E>> next<U>({
    required final FutureOr<Result<U, E>> Function(T value) onSuccess,
    final FutureOr<Result<U, E>> Function(E errror)? onError,
  }) async {
    switch (this) {
      case Success<T, E>(success: final T value):
        try {
          return await onSuccess(value);
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

      case Error<T, E>(error: final E error):
        if (onError != null) {
          return await ErrorHandler.handle(error, onError);
        }
        return Error(error);
    }
  }
}
