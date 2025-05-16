import 'package:multiple_result/multiple_result.dart';
import 'package:multiple_result_async/multiple_result_async.dart';
import 'package:test/test.dart';

import '_common.dart';

void main() {
  group('Future to Result', () {
    test('toResult with Success', () async {
      final futureResult =
          alwaysFutureString(kDefaultTestString).toResult<String, Exception>();
      final result = await futureResult;
      expect(result, isA<Success<String, Exception>>());
      expect(
        (result as Success<String, Exception>).success,
        kDefaultTestString,
      );
    });

    test('toResult with Exception and correct Type', () async {
      final futureResult =
          alwaysFutureThrowsException().toResult<String, Exception>();
      expect(
        () async => await futureResult,
        throwsA(isA<DefaultTestException>()),
      );
    });

    test('toResult with Exception and wrong Type', () async {
      final futureResult =
          alwaysFutureThrowsException().toResult<String, String>();
      expect(
        () async => await futureResult,
        throwsA(isA<DefaultTestException>()),
      );
    });

    test('toResult with unmatched input and output types', () async {
      expect(
        () => alwaysFutureString(kDefaultTestString).toResult<int, Exception>(),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('Future to Result or Error', () {
    test('toResult with Success', () async {
      final futureResult =
          alwaysFutureString(kDefaultTestString).toResultOrError<Exception>();
      final result = await futureResult;
      expect(result, isA<Success<String, Exception>>());
      expect(
        (result as Success<String, Exception>).success,
        kDefaultTestString,
      );
    });

    test('toResult with Exception and correct Type', () async {
      final futureResult =
          alwaysFutureThrowsException().toResultOrError<Exception>();
      final result = await futureResult;
      expect(result, isA<Error<String, Exception>>());
      expect(
        (result as Error<String, Exception>).error,
        isA<DefaultTestException>(),
      );
    });

    test('toResult with Exception and wrong Type', () async {
      final futureResult =
          alwaysFutureThrowsException().toResultOrError<String>();
      expect(
        () async => await futureResult,
        throwsA(isA<DefaultTestException>()),
      );
    });
  });
}
