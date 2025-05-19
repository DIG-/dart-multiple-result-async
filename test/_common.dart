import 'package:multiple_result/multiple_result.dart';
import 'package:multiple_result_async/multiple_result_async.dart';

export '_error.dart';

const String kDefaultTestString = 'Foo';
const String kAlternativeTestString = 'BarBar';

Future<String> alwaysFutureString(final String message) async => message;

Future<String> alwaysFutureThrowsException() async =>
    throw const DefaultTestException();

Future<Result<String, Exception>> alwaysFutureResultString(
  final String message,
) async =>
    await alwaysFutureString(message).toResultOrError();

Future<Result<String, Exception>> alwaysFutureResultException() async =>
    await alwaysFutureThrowsException().toResultOrError();

Result<String, Exception> alwaysResultString(final String message) =>
    Success<String, Exception>(message);

Result<String, Exception> alwaysResultException() =>
    const Error<String, Exception>(DefaultTestException());

class DefaultTestException implements Exception {
  const DefaultTestException();
}

class AlternativeTestException implements Exception {
  const AlternativeTestException();
}
