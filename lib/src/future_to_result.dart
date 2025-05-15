import 'package:multiple_result/multiple_result.dart';

extension FutureToResult<T> on Future<T> {
  Future<Result<T, E>> toResult<U, E>() async {
    assert(
      T == U,
      'The type of the Future must be the same as the type of the Result',
    );
    try {
      return Result.success(await this);
    } catch (error) {
      if (error case final E error) {
        return Error(error);
      }
      rethrow;
    }
  }

  @pragma('vm:prefer-inline')
  Future<Result<T, E>> toResultOrError<E>() {
    return toResult<T, E>();
  }
}
