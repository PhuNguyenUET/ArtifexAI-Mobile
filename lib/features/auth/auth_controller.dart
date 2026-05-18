import '../../init/index.dart';
import '../../packages/index.dart';
import 'auth_state.dart';

class AuthController extends Cubit<AuthState> {
  AuthController() : super(const AuthState());

  final _storage = sl.get<AccessTokenStorage>();

  Future<void> checkAuthOnStartup({
    required VoidCallback onAuthenticated,
    required VoidCallback onUnauthenticated,
  }) async {
    emit(state.copyWith(loading: true));
    try {
      final repo = _storage.repository;

      final accessToken = await _storage.getAccessToken();
      if (accessToken.isEmpty) {
        onUnauthenticated();
        return;
      }

      try {
        await repo.jwtCheck();
        onAuthenticated();
        return;
      } on CustomException catch (e) {
        if (e.statusCode != 401) rethrow;
      }

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
        await _storage.clearTokens();
        onUnauthenticated();
      }
    } catch (_) {
      onUnauthenticated();
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

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

  Future<void> signInWithGoogle({
    required BuildContext context,
    required VoidCallback onSuccess,
  }) async {
    emit(state.copyWith(googleLoading: true, errorMessage: null));
    try {
      final repo = _storage.repository;
      final response = await repo.authenticateOAuthGoogle();
      await _storage.saveTokens(
        accessToken: response.jwtToken ?? '',
        refreshToken: response.refreshToken ?? '',
      );
      onSuccess();
    } on CustomException catch (e) {
      if (e.exceptionType == ExceptionType.cancelException) return;
      emit(state.copyWith(errorMessage: e.message));
    } catch (_) {
      emit(state.copyWith(errorMessage: 'Google sign-in failed.'));
    } finally {
      emit(state.copyWith(googleLoading: false));
    }
  }

  Future<void> signInWithGithub({
    required BuildContext context,
    required VoidCallback onSuccess,
  }) async {
    emit(state.copyWith(githubLoading: true, errorMessage: null));
    try {
      final repo = _storage.repository;
      final response = await repo.authenticateOAuthGithub();
      await _storage.saveTokens(
        accessToken: response.jwtToken ?? '',
        refreshToken: response.refreshToken ?? '',
      );
      onSuccess();
    } on CustomException catch (e) {
      if (e.exceptionType == ExceptionType.cancelException) return;
      emit(state.copyWith(errorMessage: e.message));
    } catch (_) {
      emit(state.copyWith(errorMessage: 'GitHub sign-in failed.'));
    } finally {
      emit(state.copyWith(githubLoading: false));
    }
  }

  Future<bool> sendForgotPasswordEmail({
    required String email,
    void Function(String)? onError,
  }) async {
    try {
      await _storage.repository.forgotPassword(email: email);
      return true;
    } on CustomException catch (e) {
      onError?.call(e.message);
      return false;
    } catch (_) {
      onError?.call('Failed to send reset email. Please try again.');
      return false;
    }
  }

  Future<bool> submitNewPassword({
    required String token,
    required String newPassword,
    void Function(String)? onError,
  }) async {
    try {
      await _storage.repository
          .createNewPassword(token: token, password: newPassword);
      return true;
    } on CustomException catch (e) {
      onError?.call(e.message);
      return false;
    } catch (_) {
      onError?.call('Failed to reset password. Please try again.');
      return false;
    }
  }
}

