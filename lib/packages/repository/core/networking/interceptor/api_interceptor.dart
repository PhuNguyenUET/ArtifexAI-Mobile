import '../../../../index.dart';

class ApiInterceptor extends Interceptor {
  ApiInterceptor() : super();

  /// Paths that the backend permits without a JWT.
  /// Matches against [RequestOptions.path] using `contains`.
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

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers.addAll({
      'Accept-Language': Intl.getCurrentLocale(),
      'X-auth-token': 'ArtifexAI-API-Token',
      if (!_isPublic(options.path) && Config.accessToken.isNotEmpty)
        'Authorization': 'Bearer ${Config.accessToken}',
    });
    return handler.next(options);
  }
}
