import 'package:artifex_ai_mobile/packages/index.dart';

class AccessTokenStorage implements TokenStorage {
  static const storageKey = 'artifex_ai_access_token';
  static const refreshTokenKey = 'artifex_ai_refresh_token';

  final _storage = const FlutterSecureStorage();
  late final NetworkSrc networkSrc;
  late Repository _repository;
  late TokenRefreshInterceptor _refreshInterceptor;

  Repository get repository => _repository;

  AccessTokenStorage() {
    final refreshInterceptor = TokenRefreshInterceptor(
      primaryDio: Dio(),
      storage: this,
      onSessionExpired: () {},
    );

    networkSrc = NetworkSrc(tokenRefreshInterceptor: refreshInterceptor);
    _refreshInterceptor = refreshInterceptor;

    _repository = RepositoryImpl(ApiServiceImpl(
      networkSrc.dioService,
      networkSrc.downloadDioService,
      networkSrc.commonDioService,
    ));
  }

  void init({required VoidCallback onSessionExpired}) {
    _refreshInterceptor = TokenRefreshInterceptor(
      primaryDio: networkSrc.dioService.dio,
      storage: this,
      onSessionExpired: onSessionExpired,
    );
    _replaceRefreshInterceptor(networkSrc.dioService.dio);
    _replaceRefreshInterceptor(networkSrc.commonDioService.dio);
  }

  void _replaceRefreshInterceptor(Dio dio) {
    dio.interceptors.removeWhere((i) => i is TokenRefreshInterceptor);
    dio.interceptors.add(_refreshInterceptor);
  }

  IOSOptions _getIOSOptions() => const IOSOptions();

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  Future<String> getAccessToken() async {
    String? accessToken = await _storage.read(
        key: storageKey,
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions());

    if (accessToken == null || accessToken.isEmpty) {
      Config.accessToken = '';
      return '';
    } else {
      Config.accessToken = accessToken;
      return accessToken;
    }
  }

  Future<String> getRefreshToken() async {
    String? refreshToken = await _storage.read(
        key: refreshTokenKey,
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions());
    return refreshToken ?? '';
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final cleanAccessToken = accessToken.replaceFirst('Bearer ', '');
    final cleanRefreshToken = refreshToken.replaceFirst('Bearer ', '');
    await _storage.write(
        key: storageKey,
        value: cleanAccessToken,
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions());
    await _storage.write(
        key: refreshTokenKey,
        value: cleanRefreshToken,
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions());
    Config.accessToken = cleanAccessToken;
    Config.refreshToken = cleanRefreshToken;
  }

  Future<void> clearTokens() async {
    await _storage.delete(
        key: storageKey,
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions());
    await _storage.delete(
        key: refreshTokenKey,
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions());
    Config.accessToken = '';
    Config.refreshToken = '';
  }

  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token.isNotEmpty;
  }
}
