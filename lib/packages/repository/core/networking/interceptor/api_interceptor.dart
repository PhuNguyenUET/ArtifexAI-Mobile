import '../../../../index.dart';

class ApiInterceptor extends Interceptor {
  final String? accessToken;

  ApiInterceptor({this.accessToken}) : super();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers.addAll({
      'Accept-Language': Intl.getCurrentLocale(),
      'X-auth-token': 'ArtifexAI-API-Token',
      if (accessToken != null && accessToken!.isNotEmpty)
        'Authorization': 'Bearer ${accessToken!}',
    });
    return handler.next(options);
  }
}
