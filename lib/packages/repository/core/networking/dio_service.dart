import '../../../index.dart';
import '../helper/index.dart';
import 'custom_exception.dart';

class DioService {
  final Dio _dio;

  final CacheOptions? globalCacheOptions;

  final CancelToken _cancelToken;

  DioService({
    required Dio dioClient,
    this.globalCacheOptions,
    Iterable<Interceptor>? interceptors,
    HttpClientAdapter? httpClientAdapter,
  })  : _dio = dioClient,
        _cancelToken = CancelToken() {
    if (interceptors != null) _dio.interceptors.addAll(interceptors);
    if (httpClientAdapter != null) _dio.httpClientAdapter = httpClientAdapter;
  }

  void cancelRequests({CancelToken? cancelToken}) {
    if (cancelToken == null) {
      _cancelToken.cancel('Cancelled');
    } else {
      cancelToken.cancel();
    }
  }

  Dio get dio => _dio;

  dynamic _unwrap(JSON? envelope) {
    if (envelope == null) {
      throw CustomException(message: 'Response data is null');
    }
    final code = envelope['code'] as int?;
    final message = envelope['message'] as String? ?? 'Unknown error';
    if (code == null || (code != 0 && code != 200 && code != 204)) {
      throw CustomException(
        message: message,
        statusCode: code,
        exceptionType: ExceptionType.badResponse,
      );
    }
    return envelope['results'];
  }

  Future<JSON> get({
    required String endpoint,
    JSON? queryParams,
    Options? options,
    CacheOptions? cacheOptions,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get<JSON>(
        endpoint,
        queryParameters: queryParams,
        options: _mergeDioAndCacheOptions(
          dioOptions: options,
          cacheOptions: cacheOptions,
        ),
        cancelToken: cancelToken ?? _cancelToken,
      );
      final results = _unwrap(response.data);
      return (results as JSON?) ?? {};
    } on DioException catch (e) {
      throw CustomException.fromDioException(e);
    }
  }

  Future<void> getRaw({
    required String endpoint,
    JSON? queryParams,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      await _dio.get<dynamic>(
        endpoint,
        queryParameters: queryParams,
        options: options,
        cancelToken: cancelToken ?? _cancelToken,
      );
    } on DioException catch (e) {
      throw CustomException.fromDioException(e);
    }
  }

  Future<List<T>> getList<T>({
    required String endpoint,
    JSON? queryParams,
    Options? options,
    CacheOptions? cacheOptions,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get<JSON>(
        endpoint,
        queryParameters: queryParams,
        options: _mergeDioAndCacheOptions(
          dioOptions: options,
          cacheOptions: cacheOptions,
        ),
        cancelToken: cancelToken ?? _cancelToken,
      );
      final results = _unwrap(response.data);
      if (results == null) return [];
      return List<T>.from(results as List);
    } on DioException catch (e) {
      throw CustomException.fromDioException(e);
    }
  }

  Future<T?> getT<T>({
    required String endpoint,
    JSON? queryParams,
    Options? options,
    CacheOptions? cacheOptions,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get<JSON>(
        endpoint,
        queryParameters: queryParams,
        options: _mergeDioAndCacheOptions(
          dioOptions: options,
          cacheOptions: cacheOptions,
        ),
        cancelToken: cancelToken ?? _cancelToken,
      );
      final results = _unwrap(response.data);
      return results as T?;
    } on DioException catch (e) {
      throw CustomException.fromDioException(e);
    }
  }

  Future<JSON> post({
    required String endpoint,
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post<JSON>(
        endpoint,
        data: data,
        options: options,
        cancelToken: cancelToken ?? _cancelToken,
      );
      final results = _unwrap(response.data);
      return (results as JSON?) ?? {};
    } on DioException catch (e) {
      throw CustomException.fromDioException(e);
    }
  }

  Future<List<T>> mPost<T>({
    required String endpoint,
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post<JSON>(
        endpoint,
        data: data,
        options: options,
        cancelToken: cancelToken ?? _cancelToken,
      );
      final results = _unwrap(response.data);
      if (results == null) return [];
      return List<T>.from(results as List);
    } on DioException catch (e) {
      throw CustomException.fromDioException(e);
    }
  }

  Future<T?> postT<T>({
    required String endpoint,
    Object? data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post<JSON>(
        endpoint,
        data: data,
        options: options,
        cancelToken: cancelToken ?? _cancelToken,
      );
      final results = _unwrap(response.data);
      return results as T?;
    } on DioException catch (e) {
      throw CustomException.fromDioException(e);
    }
  }

  Future<String> postGetMessage({
    required String endpoint,
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post<JSON>(
        endpoint,
        data: data,
        options: options,
        cancelToken: cancelToken ?? _cancelToken,
      );
      final envelope = response.data;
      if (envelope == null) throw CustomException(message: 'Response data is null');
      return (envelope['message'] as String?) ?? '';
    } on DioException catch (e) {
      throw CustomException.fromDioException(e);
    }
  }

  Future<String> postString({    required String endpoint,
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post<JSON>(
        endpoint,
        data: data,
        options: options,
        cancelToken: cancelToken ?? _cancelToken,
      );
      final results = _unwrap(response.data);
      return results?.toString() ?? '';
    } on DioException catch (e) {
      throw CustomException.fromDioException(e);
    }
  }

  Future<List<T>> postList<T>({
    required String endpoint,
    Object? data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post<JSON>(
        endpoint,
        data: data,
        options: options,
        cancelToken: cancelToken ?? _cancelToken,
      );
      final results = _unwrap(response.data);
      if (results == null) return [];
      return List<T>.from(results as List);
    } on DioException catch (e) {
      throw CustomException.fromDioException(e);
    }
  }

  Future<JSON> put({
    required String endpoint,
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put<JSON>(
        endpoint,
        data: data,
        options: options,
        cancelToken: cancelToken ?? _cancelToken,
      );
      final results = _unwrap(response.data);
      return (results as JSON?) ?? {};
    } on DioException catch (e) {
      throw CustomException.fromDioException(e);
    }
  }

  Future<JSON> patch<R>({
    required String endpoint,
    JSON? data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.patch<JSON>(
        endpoint,
        data: data,
        options: options,
        cancelToken: cancelToken ?? _cancelToken,
      );
      final results = _unwrap(response.data);
      return (results as JSON?) ?? {};
    } on DioException catch (e) {
      throw CustomException.fromDioException(e);
    }
  }

  Future<JSON> delete({
    required String endpoint,
    JSON? queryParams,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete<JSON>(
        endpoint,
        queryParameters: queryParams,
        options: options,
        cancelToken: cancelToken ?? _cancelToken,
      );
      final results = _unwrap(response.data);
      return (results as JSON?) ?? {};
    } on DioException catch (e) {
      throw CustomException.fromDioException(e);
    }
  }

  Future<Response> download(
    String urlPath,
    dynamic savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    String lengthHeader = Headers.contentLengthHeader,
    Object? data,
    Options? options,
  }) async {
    return await _dio.download(urlPath, savePath,
        options: Options(responseType: ResponseType.bytes));
  }

  Options? _mergeDioAndCacheOptions({
    Options? dioOptions,
    CacheOptions? cacheOptions,
  }) {
    if (dioOptions == null && cacheOptions == null) {
      return null;
    } else if (dioOptions == null && cacheOptions != null) {
      return cacheOptions.toOptions();
    } else if (dioOptions != null && cacheOptions == null) {
      return dioOptions;
    }

    final cacheOptionsMap = cacheOptions!.toExtra();
    final options = dioOptions!.copyWith(
      extra: <String, dynamic>{...dioOptions.extra!, ...cacheOptionsMap},
    );
    return options;
  }
}
