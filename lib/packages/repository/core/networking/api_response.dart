import 'package:freezed_annotation/freezed_annotation.dart';

import '../helper/index.dart';

part 'api_response.freezed.dart';

@freezed
sealed class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse.success({required T data}) = Success;

  const factory ApiResponse.error({required int code, required String message}) = Error;

  static ApiResponse<T> fromJson<T>(
    JSON json,
    T Function(JSON json) convert,
  ) {
    final code = json['code'] as int;
    final message = json['message'] as String? ?? '';
    if (code == 200 || code == 0) {
      final results = json['results'] as JSON;
      return ApiResponse.success(data: convert(results));
    }
    return ApiResponse.error(code: code, message: message);
  }
}

extension ApiResponseExt<T> on ApiResponse<T> {
  bool get isSuccess => this is Success;

  bool get isError => this is Error;
}
