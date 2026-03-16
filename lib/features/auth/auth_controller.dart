import '../../init/index.dart';
import '../../packages/index.dart';
import 'auth_state.dart';

class AuthController extends Cubit<AuthState> {
  AuthController() : super(const AuthState());

  final _storage = sl.get<AccessTokenStorage>();

  // ─── Startup Auth Check ──────────────────────────────────────────────────────

  Future<void> checkAuthOnStartup({
    required VoidCallback onAuthenticated,
    required VoidCallback onUnauthenticated,
  }) async {
    emit(state.copyWith(loading: true));
    try {
      final repo = _storage.repository;

      // 1. Load stored access token — skip everything if none exists.
      final accessToken = await _storage.getAccessToken();
      if (accessToken.isEmpty) {
        onUnauthenticated();
        return;
      }

      // 2. Try JWT health check — succeeds if JWT is still active.
      try {
        await repo.jwtCheck();
        onAuthenticated();
        return;
      } on CustomException catch (e) {
        // Only attempt a refresh when the server explicitly rejects the token
        // (HTTP 401). For network errors, timeouts, etc. we fall through to
        // the outer catch which routes to unauthenticated.
        if (e.statusCode != 401) rethrow;
      }

      // 3. JWT is expired — try refreshing.
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken.isEmpty) {
        onUnauthenticated();
        return;
      }

      try {
        final newAccessToken = await repo.refreshJwt(refreshToken: refreshToken);
        await _storage.saveTokens(
          accessToken: newAccessToken,
          refreshToken: refreshToken,
        );
        onAuthenticated();
      } on CustomException catch (_) {
        // Refresh token is expired or rejected by the server.
        await _storage.clearTokens();
        onUnauthenticated();
      }
    } catch (_) {
      // Network error, timeout, or any unexpected failure — fall back to login.
      onUnauthenticated();
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  // ─── Tab ─────────────────────────────────────────────────────────────────────

  void switchTab(AuthTab tab) {
    emit(state.copyWith(activeTab: tab, errorMessage: null));
  }

  void toggleObscurePassword() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void toggleObscureConfirmPassword() {
    emit(state.copyWith(obscureConfirmPassword: !state.obscureConfirmPassword));
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  // ─── Email / Password Auth ────────────────────────────────────────────────────

  Future<void> signIn({
    required BuildContext context,
    required String email,
    required String password,
    required VoidCallback onSuccess,
  }) async {
    emit(state.copyWith(loading: true, errorMessage: null));
    try {
      final repo = _storage.repository;
      final response = await repo.authenticate(email: email, password: password);
      await _storage.saveTokens(
        accessToken: response.jwtToken ?? '',
        refreshToken: response.refreshToken ?? '',
      );
      onSuccess();
    } on CustomException catch (e) {
      emit(state.copyWith(errorMessage: e.message));
    } catch (_) {
      emit(state.copyWith(errorMessage: 'An unexpected error occurred.'));
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  Future<void> signUp({
    required BuildContext context,
    required String email,
    required String password,
    required VoidCallback onSuccess,
  }) async {
    emit(state.copyWith(loading: true, errorMessage: null));
    try {
      final repo = _storage.repository;
      await repo.register(email: email, password: password);
      onSuccess();
    } on CustomException catch (e) {
      emit(state.copyWith(errorMessage: e.message));
    } catch (_) {
      emit(state.copyWith(errorMessage: 'An unexpected error occurred.'));
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  // ─── OAuth ───────────────────────────────────────────────────────────────────

  Future<void> signInWithGoogle({
    required BuildContext context,
    required VoidCallback onSuccess,
  }) async {
    emit(state.copyWith(oauthLoading: true, errorMessage: null));
    try {
      final repo = _storage.repository;
      final response = await repo.authenticateOAuthGoogle();
      await _storage.saveTokens(
        accessToken: response.jwtToken ?? '',
        refreshToken: response.refreshToken ?? '',
      );
      onSuccess();
    } on CustomException catch (e) {
      emit(state.copyWith(errorMessage: e.message));
    } catch (_) {
      emit(state.copyWith(errorMessage: 'Google sign-in failed.'));
    } finally {
      emit(state.copyWith(oauthLoading: false));
    }
  }

  Future<void> signInWithGithub({
    required BuildContext context,
    required VoidCallback onSuccess,
  }) async {
    emit(state.copyWith(oauthLoading: true, errorMessage: null));
    try {
      final repo = _storage.repository;
      final response = await repo.authenticateOAuthGithub();
      await _storage.saveTokens(
        accessToken: response.jwtToken ?? '',
        refreshToken: response.refreshToken ?? '',
      );
      onSuccess();
    } on CustomException catch (e) {
      emit(state.copyWith(errorMessage: e.message));
    } catch (_) {
      emit(state.copyWith(errorMessage: 'GitHub sign-in failed.'));
    } finally {
      emit(state.copyWith(oauthLoading: false));
    }
  }
}

