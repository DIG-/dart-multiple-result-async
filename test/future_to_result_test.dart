import 'package:multiple_result/multiple_result.dart';
import 'package:multiple_result_async/multiple_result_async.dart';
import 'package:test/test.dart';

const String kTestString = 'Foo';

Future<String> alwaysReturnString(final String message) async {
  return message;
}

Future<String> alwaysThrowsException() async {
  throw const FormatException('Stub');
}

void main() {
  group('Future to Result with try-catch', () {
    test('toResult with Success', () async {
      final futureResult = alwaysReturnString(kTestString)
          .toResult<String, Exception>(useTryCatch: true);
      final result = await futureResult;
      expect(result, isA<Success<String, Exception>>());
      expect((result as Success<String, Exception>).success, kTestString);
    });

    test('toResult with Exception and correct Type', () async {
      final futureResult = alwaysThrowsException()
          .toResult<String, Exception>(useTryCatch: true);
      final result = await futureResult;
      expect(result, isA<Error<String, Exception>>());
      expect(
        (result as Error<String, Exception>).error,
        isA<FormatException>(),
      );
    });

    test('toResult with Exception and wrong Type', () async {
      final futureResult =
          alwaysThrowsException().toResult<String, String>(useTryCatch: true);
      expect(() async => await futureResult, throwsA(isA<FormatException>()));
    });

    test('toResult with unmatched input and output types', () async {
      expect(
        () => alwaysReturnString(kTestString)
            .toResult<int, Exception>(useTryCatch: true),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('Future to Result without try-catch', () {
    test('toResult with Success', () async {
      final futureResult = alwaysReturnString(kTestString)
          .toResult<String, Exception>(useTryCatch: false);
      final result = await futureResult;
      expect(result, isA<Success<String, Exception>>());
      expect((result as Success<String, Exception>).success, kTestString);
    });

    test('toResult with Exception and correct Type', () async {
      final futureResult = alwaysThrowsException()
          .toResult<String, Exception>(useTryCatch: false);
      expect(() async => await futureResult, throwsA(isA<FormatException>()));
    });

    test('toResult with Exception and wrong Type', () async {
      final futureResult =
          alwaysThrowsException().toResult<String, String>(useTryCatch: false);
      expect(() async => await futureResult, throwsA(isA<FormatException>()));
    });

    test('toResult with unmatched input and output types', () async {
      expect(
        () => alwaysReturnString(kTestString)
            .toResult<int, Exception>(useTryCatch: false),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('Future to Result or Error', () {
    // Same as toResult with try-catch

    test('toResult with Success', () async {
      final futureResult =
          alwaysReturnString(kTestString).toResultOrError<Exception>();
      final result = await futureResult;
      expect(result, isA<Success<String, Exception>>());
      expect((result as Success<String, Exception>).success, kTestString);
    });

    test('toResult with Exception and correct Type', () async {
      final futureResult = alwaysThrowsException().toResultOrError<Exception>();
      final result = await futureResult;
      expect(result, isA<Error<String, Exception>>());
      expect(
        (result as Error<String, Exception>).error,
        isA<FormatException>(),
      );
    });

    test('toResult with Exception and wrong Type', () async {
      final futureResult = alwaysThrowsException().toResultOrError<String>();
      expect(() async => await futureResult, throwsA(isA<FormatException>()));
    });
  });
}
