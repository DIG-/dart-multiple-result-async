import 'dart:async';

import 'package:multiple_result/multiple_result.dart';

extension ErrorHandler on Never {
  static Future<Result<T, E>> handle<T, E>(
    final E error,
    final FutureOr<Result<T, E>> Function(E errror) onError,
  ) async {
    try {
      return await onError(error);
    } catch (error) {
      if (error case final E error) {
        return Error(error);
      }
      rethrow;
    }
  }
}
