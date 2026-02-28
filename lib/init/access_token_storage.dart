import 'package:artifex_ai_mobile/packages/index.dart';


class AccessTokenStorage {
  static const storageKey = 'artifex_ai_access_token';
  static const refreshTokenKey = 'artifex_ai_refresh_token';

  final _storage = const FlutterSecureStorage();
  NetworkSrc networkSrc = NetworkSrc();
  late Repository _repository;

  Repository get repository => _repository;

  AccessTokenStorage() {
    _repository = RepositoryImpl(ApiServiceImpl(networkSrc.dioService, networkSrc.downloadDioService, networkSrc.commonDioService));
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
      return '';
    } else {
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
    await _storage.write(
        key: storageKey,
        value: accessToken,
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions());
    await _storage.write(
        key: refreshTokenKey,
        value: refreshToken,
        iOptions: _getIOSOptions(),
        aOptions: _getAndroidOptions());
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
  }

  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token.isNotEmpty;
  }
}
