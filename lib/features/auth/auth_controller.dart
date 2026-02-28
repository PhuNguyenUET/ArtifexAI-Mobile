import '../../init/index.dart';
import '../../packages/index.dart';
import 'auth_state.dart';

class AuthController extends Cubit<AuthState> {
  AuthController() : super(const AuthState());

  final _storage = sl.get<AccessTokenStorage>();

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

