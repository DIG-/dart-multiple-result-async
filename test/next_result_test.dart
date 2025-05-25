import 'package:multiple_result/multiple_result.dart';
import 'package:multiple_result_async/multiple_result_async.dart';
import 'package:test/test.dart';

import '_common.dart';

void main() {
  group('Result<T,E>.next<U>() sync', () {
    setUp(() {
      assert(
        kDefaultTestString != kAlternativeTestString,
        'kDefaultTestString and kAlternativeTestString must be different',
      );
    });

    test('Success with same type', () async {
      final resultFuture = alwaysResultString(kDefaultTestString).next<String>(
        onSuccess: (final value) =>
            Result.success(value.split('').reversed.join()),
      );
      final result = await resultFuture;
      expect(result, isA<Success<String, Exception>>());
      expect(
        (result as Success<String, Exception>).success,
        kDefaultTestString.split('').reversed.join(),
      );
    });

    test('Success with other type', () async {
      final resultFuture = alwaysResultString(kDefaultTestString).next<int>(
        onSuccess: (final value) => Result.success(value.length),
      );
      final result = await resultFuture;
      expect(result, isA<Success<int, Exception>>());
      expect(
        (result as Success<int, Exception>).success,
        kDefaultTestString.length,
      );
    });

    test('Success to Error with same type', () async {
      final resultFuture = alwaysResultString(kDefaultTestString).next<String>(
        onSuccess: (final _) => const Result.error(AlternativeTestException()),
      );
      final result = await resultFuture;
      expect(result, isA<Error<String, Exception>>());
      expect(
        (result as Error<String, Exception>).error,
        isA<AlternativeTestException>(),
      );
    });

    test('Success to Error with other type', () async {
      final resultFuture = alwaysResultString(kDefaultTestString).next<int>(
        onSuccess: (final _) => const Result.error(AlternativeTestException()),
      );
      final result = await resultFuture;
      expect(result, isA<Error<int, Exception>>());
      expect(
        (result as Error<int, Exception>).error,
        isA<AlternativeTestException>(),
      );
    });

    test('Error catching with same type', () async {
      final resultFuture = alwaysResultString(kDefaultTestString).next<String>(
        onSuccess: (final _) => throw const AlternativeTestException(),
      );
      final result = await resultFuture;
      expect(result, isA<Error<String, Exception>>());
      expect(
        (result as Error<String, Exception>).error,
        isA<AlternativeTestException>(),
      );
    });

    test('Error catching with other type', () async {
      final resultFuture = alwaysResultString(kDefaultTestString).next<int>(
        onSuccess: (final _) => throw const AlternativeTestException(),
      );
      final result = await resultFuture;
      expect(result, isA<Error<int, Exception>>());
      expect(
        (result as Error<int, Exception>).error,
        isA<AlternativeTestException>(),
      );
    });

    test('Error propagation with same type', () async {
      final resultFuture = alwaysResultException().next<String>(
        onSuccess: (final _) => fail('Should not be called'),
      );
      final result = await resultFuture;
      expect(result, isA<Error<String, Exception>>());
      expect(
        (result as Error<String, Exception>).error,
        isA<DefaultTestException>(),
      );
    });

    test('Error propagation with other type', () async {
      final resultFuture = alwaysResultException().next<int>(
        onSuccess: (final _) => fail('Should not be called'),
      );
      final result = await resultFuture;
      expect(result, isA<Error<int, Exception>>());
      expect(
        (result as Error<int, Exception>).error,
        isA<DefaultTestException>(),
      );
    });

    test('Error handling with same type', () async {
      final resultFuture = alwaysResultException().next<String>(
        onSuccess: (final _) => fail('Should not be called'),
        onError: (final _) => const Result.success(kDefaultTestString),
      );
      final result = await resultFuture;
      expect(result, isA<Success<String, Exception>>());
      expect(
        (result as Success<String, Exception>).success,
        kDefaultTestString,
      );
    });

    test('Error handling with other type', () async {
      final resultFuture = alwaysResultException().next<int>(
        onSuccess: (final _) => fail('Should not be called'),
        onError: (final _) => const Result.success(kDefaultTestString.length),
      );
      final result = await resultFuture;
      expect(result, isA<Success<int, Exception>>());
      expect(
        (result as Success<int, Exception>).success,
        kDefaultTestString.length,
      );
    });

    test('Error catching and handling with same type', () async {
      final resultFuture =
          alwaysResultString(kAlternativeTestString).next<String>(
        onSuccess: (final _) => throw const AlternativeTestException(),
        onError: (final _) => const Result.success(kDefaultTestString),
      );
      final result = await resultFuture;
      expect(result, isA<Success<String, Exception>>());
      expect(
        (result as Success<String, Exception>).success,
        kDefaultTestString,
      );
    });

    test('Error catching and handling with other type', () async {
      final resultFuture = alwaysResultString(kAlternativeTestString).next<int>(
        onSuccess: (final _) => throw const AlternativeTestException(),
        onError: (final _) => const Result.success(kDefaultTestString.length),
      );
      final result = await resultFuture;
      expect(result, isA<Success<int, Exception>>());
      expect(
        (result as Success<int, Exception>).success,
        kDefaultTestString.length,
      );
    });

    test('Error fallthrough with same type', () async {
      final resultFuture = alwaysResultString(kDefaultTestString).next<String>(
        onSuccess: (final _) => throw DefaultTestError(),
      );
      expect(() async => await resultFuture, throwsA(isA<DefaultTestError>()));
    });

    test('Error fallthrough with other type', () async {
      final resultFuture = alwaysResultString(kDefaultTestString).next<int>(
        onSuccess: (final _) => throw DefaultTestError(),
      );
      expect(() async => await resultFuture, throwsA(isA<DefaultTestError>()));
    });
  });

  group('Result<T,E>.next<U>() async', () {
    test('Success with same type', () async {
      final resultFuture = alwaysResultString(kDefaultTestString).next<String>(
        onSuccess: (final value) async =>
            Result.success(value.split('').reversed.join()),
      );
      final result = await resultFuture;
      expect(result, isA<Success<String, Exception>>());
      expect(
        (result as Success<String, Exception>).success,
        kDefaultTestString.split('').reversed.join(),
      );
    });

    test('Success with other type', () async {
      final resultFuture = alwaysResultString(kDefaultTestString).next<int>(
        onSuccess: (final value) async => Result.success(value.length),
      );
      final result = await resultFuture;
      expect(result, isA<Success<int, Exception>>());
      expect(
        (result as Success<int, Exception>).success,
        kDefaultTestString.length,
      );
    });

    test('Success to Error with same type', () async {
      final resultFuture = alwaysResultString(kDefaultTestString).next<String>(
        onSuccess: (final _) async =>
            const Result.error(AlternativeTestException()),
      );
      final result = await resultFuture;
      expect(result, isA<Error<String, Exception>>());
      expect(
        (result as Error<String, Exception>).error,
        isA<AlternativeTestException>(),
      );
    });

    test('Success to Error with other type', () async {
      final resultFuture = alwaysResultString(kDefaultTestString).next<int>(
        onSuccess: (final _) async =>
            const Result.error(AlternativeTestException()),
      );
      final result = await resultFuture;
      expect(result, isA<Error<int, Exception>>());
      expect(
        (result as Error<int, Exception>).error,
        isA<AlternativeTestException>(),
      );
    });

    test('Error catching with same type', () async {
      final resultFuture = alwaysResultString(kDefaultTestString).next<String>(
        onSuccess: (final _) async => throw const AlternativeTestException(),
      );
      final result = await resultFuture;
      expect(result, isA<Error<String, Exception>>());
      expect(
        (result as Error<String, Exception>).error,
        isA<AlternativeTestException>(),
      );
    });

    test('Error catching with other type', () async {
      final resultFuture = alwaysResultString(kDefaultTestString).next<int>(
        onSuccess: (final _) async => throw const AlternativeTestException(),
      );
      final result = await resultFuture;
      expect(result, isA<Error<int, Exception>>());
      expect(
        (result as Error<int, Exception>).error,
        isA<AlternativeTestException>(),
      );
    });

    test('Error propagation with same type', () async {
      final resultFuture = alwaysResultException().next<String>(
        onSuccess: (final _) async => fail('Should not be called'),
      );
      final result = await resultFuture;
      expect(result, isA<Error<String, Exception>>());
      expect(
        (result as Error<String, Exception>).error,
        isA<DefaultTestException>(),
      );
    });

    test('Error propagation with other type', () async {
      final resultFuture = alwaysResultException().next<int>(
        onSuccess: (final _) async => fail('Should not be called'),
      );
      final result = await resultFuture;
      expect(result, isA<Error<int, Exception>>());
      expect(
        (result as Error<int, Exception>).error,
        isA<DefaultTestException>(),
      );
    });

    test('Error handling with same type', () async {
      final resultFuture = alwaysResultException().next<String>(
        onSuccess: (final _) async => fail('Should not be called'),
        onError: (final _) async => const Result.success(kDefaultTestString),
      );
      final result = await resultFuture;
      expect(result, isA<Success<String, Exception>>());
      expect(
        (result as Success<String, Exception>).success,
        kDefaultTestString,
      );
    });

    test('Error handling with other type', () async {
      final resultFuture = alwaysResultException().next<int>(
        onSuccess: (final _) async => fail('Should not be called'),
        onError: (final _) async =>
            const Result.success(kDefaultTestString.length),
      );
      final result = await resultFuture;
      expect(result, isA<Success<int, Exception>>());
      expect(
        (result as Success<int, Exception>).success,
        kDefaultTestString.length,
      );
    });

    test('Error catching and handling with same type', () async {
      final resultFuture =
          alwaysResultString(kAlternativeTestString).next<String>(
        onSuccess: (final _) async => throw const AlternativeTestException(),
        onError: (final _) async => const Result.success(kDefaultTestString),
      );
      final result = await resultFuture;
      expect(result, isA<Success<String, Exception>>());
      expect(
        (result as Success<String, Exception>).success,
        kDefaultTestString,
      );
    });

    test('Error catching and handling with other type', () async {
      final resultFuture = alwaysResultString(kAlternativeTestString).next<int>(
        onSuccess: (final _) async => throw const AlternativeTestException(),
        onError: (final _) async =>
            const Result.success(kDefaultTestString.length),
      );
      final result = await resultFuture;
      expect(result, isA<Success<int, Exception>>());
      expect(
        (result as Success<int, Exception>).success,
        kDefaultTestString.length,
      );
    });

    test('Error fallthrough with same type', () async {
      final resultFuture = alwaysResultString(kDefaultTestString).next<String>(
        onSuccess: (final _) async => throw DefaultTestError(),
      );
      expect(() async => await resultFuture, throwsA(isA<DefaultTestError>()));
    });

    test('Error fallthrough with other type', () async {
      final resultFuture = alwaysResultString(kDefaultTestString).next<int>(
        onSuccess: (final _) async => throw DefaultTestError(),
      );
      expect(() async => await resultFuture, throwsA(isA<DefaultTestError>()));
    });
  });
}
