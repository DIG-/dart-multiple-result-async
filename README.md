# multiple_result_async

Provide mapping methods for [multiple_result](https://pub.dev/packages/multiple_result)'s `Result<T, E>`
with asynchronous support/handling, and error (of type `E`) capture.

## Install

Just add `multiple_result_async` as dependency. This package does not replace `multiple_result`.

## Usage

### Wrapping a `Future<T>` to `Future<Result<T, E>>`
```dart
final result = Future((){...}).toResultOrError<Exception>();
```

### Mapping a `Future<Result<T, E>>` to `Future<Result<U, E>>`
```dart
return getDataResult().next(
    onSuccess: (T success) {
        ...
        return Success(processed_value);
    },
    onError: (E error) async {
        ...
        if (is_recoverable_error){
            ...
            return Success(recupered_error);
        }
        ...
        return Error(propagated_error);
    },
);
```

## License

`multiple_result_async` is available under the MIT license. See the LICENSE file for more info.
