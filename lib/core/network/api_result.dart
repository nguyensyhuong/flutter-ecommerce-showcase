sealed class ApiResult<T> {
  const ApiResult();

  R when<R>({
    required R Function(T data) success,
    required R Function(ApiFailure failure) failure,
  });
}

final class ApiSuccess<T> extends ApiResult<T> {
  const ApiSuccess(this.data);

  final T data;

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(ApiFailure failure) failure,
  }) {
    return success(data);
  }
}

final class ApiFailure<T> extends ApiResult<T> {
  const ApiFailure({required this.message, this.statusCode, this.stackTrace});

  final String message;
  final int? statusCode;
  final StackTrace? stackTrace;

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(ApiFailure failure) failure,
  }) {
    return failure(this);
  }
}
