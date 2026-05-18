import 'dart:async';
import 'dart:convert';

import '../../../../index.dart';
import 'token_storage.dart';

class TokenRefreshInterceptor extends Interceptor {
  TokenRefreshInterceptor({
    required Dio primaryDio,
    required TokenStorage storage,
    required VoidCallback onSessionExpired,
  })  : _primaryDio = primaryDio,
        _storage = storage,
        _onSessionExpired = onSessionExpired;

  final Dio _primaryDio;
  final TokenStorage _storage;
  final VoidCallback _onSessionExpired;

  static const _publicPaths = [
    '/authenticate',
    '/refresh_jwt',
    '/forgot_password',
    '/create_new_password',
    '/register',
    '/oauth2/',
    '/authenticate_oauth2',
    '/swagger-ui',
    '/v3/api-docs',
    '/health',
  ];

  static bool _isPublic(String path) =>
      _publicPaths.any((p) => path.contains(p));

  bool _isRefreshing = false;
  final List<_PendingRequest> _queue = [];

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final response = err.response;

    if (response?.statusCode != 401 || !_isJwtExpired(response)) {
      return handler.next(err);
    }

    if (_isPublic(err.requestOptions.path)) {
      return handler.next(err);
    }

    final requestOptions = err.requestOptions;

    if (_isRefreshing) {
      final pending = _PendingRequest(requestOptions);
      _queue.add(pending);
      try {
        final retryResponse = await pending.future;
        return handler.resolve(retryResponse);
      } catch (_) {
        return handler.next(err);
      }
    }

    _isRefreshing = true;

    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken.isEmpty) {
        await _onRefreshFailed(err, handler);
        return;
      }

      final refreshDio = Dio(BaseOptions(
        baseUrl: _primaryDio.options.baseUrl,
        contentType: 'application/json',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ));

      final refreshResponse = await refreshDio.post<Map<String, dynamic>>(
        '/api/user/v1/refresh_jwt',
        data: {'refreshToken': refreshToken},
        options: Options(headers: {'X-auth-token': 'ArtifexAI-API-Token'}),
      );

      final newToken = _extractToken(refreshResponse.data);
      if (newToken == null || newToken.isEmpty) {
        await _onRefreshFailed(err, handler);
        return;
      }

      await _storage.saveTokens(
        accessToken: newToken,
        refreshToken: refreshToken,
      );

      for (final pending in _queue) {
        pending.options.headers['Authorization'] = 'Bearer $newToken';
        try {
          final r = await _primaryDio.fetch<dynamic>(pending.options);
          pending.complete(r);
        } catch (e) {
          pending.reject(e is Exception ? e : Exception(e.toString()));
        }
      }
      _queue.clear();

      requestOptions.headers['Authorization'] = 'Bearer $newToken';
      final retryResponse = await _primaryDio.fetch<dynamic>(requestOptions);
      return handler.resolve(retryResponse);
    } catch (_) {
      await _onRefreshFailed(err, handler);
    } finally {
      _isRefreshing = false;
    }
  }

  bool _isJwtExpired(Response? response) {
    if (response == null) return false;
    try {
      Map<String, dynamic> body;
      if (response.data is String) {
        body = jsonDecode(response.data as String) as Map<String, dynamic>;
      } else if (response.data is Map<String, dynamic>) {
        body = response.data as Map<String, dynamic>;
      } else {
        return false;
      }
      final message = (body['message'] as String? ?? '').toLowerCase();
      return message.contains('jwt expired') ||
          message.contains('expired at') ||
          message.contains('jwtexpired');
    } catch (_) {
      return false;
    }
  }

  String? _extractToken(Map<String, dynamic>? data) {
    if (data == null) return null;
    final results = data['results'];
    if (results is String && results.isNotEmpty) return results;
    return results?['jwtToken'] as String?;
  }

  Future<void> _onRefreshFailed(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    for (final pending in _queue) {
      pending.reject(Exception('Session expired'));
    }
    _queue.clear();

    await _storage.clearTokens();
    _onSessionExpired();

    return handler.next(err);
  }
}

class _PendingRequest {
  _PendingRequest(this.options);

  final RequestOptions options;
  final _completer = Completer<Response<dynamic>>();

  Future<Response<dynamic>> get future => _completer.future;

  void complete(Response<dynamic> response) => _completer.complete(response);
  void reject(Exception error) => _completer.completeError(error);
}
