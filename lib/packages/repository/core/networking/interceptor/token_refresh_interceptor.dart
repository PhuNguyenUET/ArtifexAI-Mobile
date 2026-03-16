import 'dart:async';
import 'dart:convert';

import '../../../../index.dart';
import 'token_storage.dart';

/// Intercepts every 401 response.
///
/// • If the body message contains "JWT expired", it tries to get a new access
///   token via [POST /api/user/v1/refresh_jwt].
///   - On success  → updates [Config] + [AccessTokenStorage], retries the
///                   original request with the new token.
///   - On failure  → clears stored tokens and calls [onSessionExpired].
///
/// • Any other 401 (e.g. wrong password) is passed through untouched.
///
/// A dedicated [Dio] instance is used for the refresh call so it never
/// re-enters this interceptor and cannot cause an infinite loop.
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

  /// Paths that the backend permits without a JWT – mirrors the Spring Security
  /// `.permitAll()` list so we never try to refresh on a public endpoint.
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

  /// Guards against concurrent refresh attempts: if multiple requests 401 at
  /// the same time only one refresh call is made.
  bool _isRefreshing = false;
  final List<_PendingRequest> _queue = [];

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final response = err.response;

    // Only handle 401s that look like an expired JWT.
    if (response?.statusCode != 401 || !_isJwtExpired(response)) {
      return handler.next(err);
    }

    // Never attempt a token refresh for public endpoints — they issue tokens
    // themselves and must never be retried via a refresh flow.
    if (_isPublic(err.requestOptions.path)) {
      return handler.next(err);
    }

    final requestOptions = err.requestOptions;

    // If a refresh is already in progress, queue this request.
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

      // Use a standalone Dio so this call bypasses this interceptor entirely.
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

      // Persist and update the in-memory token.
      await _storage.saveTokens(
        accessToken: newToken,
        refreshToken: refreshToken,
      );

      // Retry all queued requests with the new token.
      for (final pending in _queue) {
        pending.options.headers['Authorization'] = 'Bearer $newToken';
        try {
          final r = await _primaryDio.fetch<dynamic>(pending.options);
          pending.complete(r);
        } catch (e) {
          pending.reject(e as Exception);
        }
      }
      _queue.clear();

      // Retry the original failed request.
      requestOptions.headers['Authorization'] = 'Bearer $newToken';
      final retryResponse = await _primaryDio.fetch<dynamic>(requestOptions);
      return handler.resolve(retryResponse);
    } on DioException catch (_) {
      await _onRefreshFailed(err, handler);
    } finally {
      _isRefreshing = false;
    }
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────────

  /// Returns true when the 401 body says the JWT is expired.
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

  /// Extracts the new access token from the refresh endpoint envelope.
  String? _extractToken(Map<String, dynamic>? data) {
    if (data == null) return null;
    // Envelope: { code, message, results: "<token>" }
    final results = data['results'];
    if (results is String && results.isNotEmpty) return results;
    // Fallback: flat { jwtToken: "..." }
    return results?['jwtToken'] as String?;
  }

  /// Clears tokens, rejects pending queue, and fires the session-expired callback.
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

/// Holds a queued request and its completer while a token refresh is in flight.
class _PendingRequest {
  _PendingRequest(this.options);

  final RequestOptions options;
  final _completer = Completer<Response<dynamic>>();

  Future<Response<dynamic>> get future => _completer.future;

  void complete(Response<dynamic> response) => _completer.complete(response);
  void reject(Exception error) => _completer.completeError(error);
}
