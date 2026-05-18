import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

enum AuthTab { signIn, signUp }

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    @Default(false) bool loading,
    @Default(false) bool googleLoading,
    @Default(false) bool githubLoading,
    @Default(AuthTab.signIn) AuthTab activeTab,
    @Default(true) bool obscurePassword,
    @Default(true) bool obscureConfirmPassword,
    String? errorMessage,
  }) = _AuthState;
}

