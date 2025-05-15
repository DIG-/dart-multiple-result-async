import 'package:multiple_result/multiple_result.dart';
import 'package:multiple_result_async/multiple_result_async.dart';

Future<Result<String, Exception>> getSomething() async {
  await Future.delayed(const Duration(seconds: 1));
  return const Success('Foo');
}

Future<String> getSomeString() async {
  return 'Bar';
}

Future<Result<String, Exception>> getSomeStringResult() async {
  return await getSomeString().toResultOrError<Exception>();
}

Future<Result<int, Exception>> getSomeStringLengthResult() async {
  return await getSomeStringResult().next(onSuccess: (final value) async {
    return Success(value.length);
  }, onError: (final error) async {
    return Error(error);
  },);
}

void main() async {
  // Sample 1
  final result = await getSomething().next(
    onSuccess: (final value) {
      print('onSuccess: $value');
      return Success(value);
    },
    onError: (final error) {
      print('onError: $error');
      return Error(error);
    },
  );
  print('Result: $result');

  // Sample 2
  final resultStringLength = await getSomeStringLengthResult().next(
    onSuccess: (final value) {
      print('onSuccess: $value');
      return Success(value);
    },
    onError: (final error) {
      print('onError: $error');
      return Error(error);
    },
  );
  print('Result String Length: $resultStringLength');

  // Sample 3
  final resultStringLength2 = await getSomeString()
      .toResultOrError<Exception>()
      .next(onSuccess: (final value) {
    return Success(value.length);
  },).next(onSuccess: (final value) {
    print('onSuccess: $value');
    return Success(value);
  }, onError: (final error) {
    print('onError: $error');
    return Error(error);
  },);
  print('Result String Length 2: $resultStringLength2');
}
