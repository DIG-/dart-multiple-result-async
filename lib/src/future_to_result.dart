import 'package:multiple_result/multiple_result.dart';

extension FutureToResult<T> on Future<T> {
  Future<Result<T, E>> _toResultWithoutTryCatch<U, E>() async {
    return Result.success(await this);
  }

  Future<Result<T, E>> _toResultWithTryCatch<U, E>() async {
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
  Future<Result<T, E>> toResult<U, E>({final bool useTryCatch = true}) {
    assert(
      T == U,
      'The type of the Future must be the same as the type of the Result. T=$T, U=$U',
    );
    return useTryCatch
        ? _toResultWithTryCatch<U, E>()
        : _toResultWithoutTryCatch<U, E>();
  }

  @pragma('vm:prefer-inline')
  Future<Result<T, E>> toResultOrError<E>() => _toResultWithTryCatch<T, E>();
}
