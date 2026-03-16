/// Minimal contract the [TokenRefreshInterceptor] needs for token storage.
/// Implemented by [AccessTokenStorage] in lib/init/.
abstract class TokenStorage {
  Future<String> getRefreshToken();
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  });
  Future<void> clearTokens();
}

