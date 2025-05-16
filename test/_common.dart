import 'package:multiple_result/multiple_result.dart';
import 'package:multiple_result_async/multiple_result_async.dart';

export '_error.dart';

const String kDefaultTestString = 'Foo';
const String kAlternativeTestString = 'BarBar';

Future<String> alwaysFutureString(final String message) async => message;

Future<String> alwaysFutureThrowsException() async =>
    throw const DefaultTestException();

Future<Result<String, Exception>> alwaysResultString(
  final String message,
) async =>
    alwaysFutureString(message).toResultOrError();

Future<Result<String, Exception>> alwaysResultException() async =>
    alwaysFutureThrowsException().toResultOrError();

class DefaultTestException implements Exception {
  const DefaultTestException();
}

class AlternativeTestException implements Exception {
  const AlternativeTestException();
}
