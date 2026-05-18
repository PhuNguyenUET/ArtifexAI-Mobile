// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_state.dart';

// **************************************************************************
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

mixin _$AuthState {
  bool get loading;
  bool get googleLoading;
  bool get githubLoading;
  AuthTab get activeTab;
  bool get obscurePassword;
  bool get obscureConfirmPassword;
  String? get errorMessage;

  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthStateCopyWith<AuthState> get copyWith =>
      _$AuthStateCopyWithImpl<AuthState>(this as AuthState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthState &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.googleLoading, googleLoading) ||
                other.googleLoading == googleLoading) &&
            (identical(other.githubLoading, githubLoading) ||
                other.githubLoading == githubLoading) &&
            (identical(other.activeTab, activeTab) ||
                other.activeTab == activeTab) &&
            (identical(other.obscurePassword, obscurePassword) ||
                other.obscurePassword == obscurePassword) &&
            (identical(other.obscureConfirmPassword, obscureConfirmPassword) ||
                other.obscureConfirmPassword == obscureConfirmPassword) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      loading,
      googleLoading,
      githubLoading,
      activeTab,
      obscurePassword,
      obscureConfirmPassword,
      errorMessage);

  @override
  String toString() {
    return 'AuthState(loading: $loading, googleLoading: $googleLoading, githubLoading: $githubLoading, activeTab: $activeTab, obscurePassword: $obscurePassword, obscureConfirmPassword: $obscureConfirmPassword, errorMessage: $errorMessage)';
  }
}

abstract mixin class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) _then) =
      _$AuthStateCopyWithImpl;
  @useResult
  $Res call(
      {bool loading,
      bool googleLoading,
      bool githubLoading,
      AuthTab activeTab,
      bool obscurePassword,
      bool obscureConfirmPassword,
      String? errorMessage});
}

class _$AuthStateCopyWithImpl<$Res> implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._self, this._then);

  final AuthState _self;
  final $Res Function(AuthState) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loading = null,
    Object? googleLoading = null,
    Object? githubLoading = null,
    Object? activeTab = null,
    Object? obscurePassword = null,
    Object? obscureConfirmPassword = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_self.copyWith(
      loading: null == loading
          ? _self.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      googleLoading: null == googleLoading
          ? _self.googleLoading
          : googleLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      githubLoading: null == githubLoading
          ? _self.githubLoading
          : githubLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      activeTab: null == activeTab
          ? _self.activeTab
          : activeTab // ignore: cast_nullable_to_non_nullable
              as AuthTab,
      obscurePassword: null == obscurePassword
          ? _self.obscurePassword
          : obscurePassword // ignore: cast_nullable_to_non_nullable
              as bool,
      obscureConfirmPassword: null == obscureConfirmPassword
          ? _self.obscureConfirmPassword
          : obscureConfirmPassword // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

extension AuthStatePatterns on AuthState {

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AuthState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AuthState() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AuthState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthState():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AuthState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthState() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            bool loading,
            bool googleLoading,
            bool githubLoading,
            AuthTab activeTab,
            bool obscurePassword,
            bool obscureConfirmPassword,
            String? errorMessage)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AuthState() when $default != null:
        return $default(
            _that.loading,
            _that.googleLoading,
            _that.githubLoading,
            _that.activeTab,
            _that.obscurePassword,
            _that.obscureConfirmPassword,
            _that.errorMessage);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            bool loading,
            bool googleLoading,
            bool githubLoading,
            AuthTab activeTab,
            bool obscurePassword,
            bool obscureConfirmPassword,
            String? errorMessage)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthState():
        return $default(
            _that.loading,
            _that.googleLoading,
            _that.githubLoading,
            _that.activeTab,
            _that.obscurePassword,
            _that.obscureConfirmPassword,
            _that.errorMessage);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            bool loading,
            bool googleLoading,
            bool githubLoading,
            AuthTab activeTab,
            bool obscurePassword,
            bool obscureConfirmPassword,
            String? errorMessage)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthState() when $default != null:
        return $default(
            _that.loading,
            _that.googleLoading,
            _that.githubLoading,
            _that.activeTab,
            _that.obscurePassword,
            _that.obscureConfirmPassword,
            _that.errorMessage);
      case _:
        return null;
    }
  }
}

class _AuthState implements AuthState {
  const _AuthState(
      {this.loading = false,
      this.googleLoading = false,
      this.githubLoading = false,
      this.activeTab = AuthTab.signIn,
      this.obscurePassword = true,
      this.obscureConfirmPassword = true,
      this.errorMessage});

  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final bool googleLoading;
  @override
  @JsonKey()
  final bool githubLoading;
  @override
  @JsonKey()
  final AuthTab activeTab;
  @override
  @JsonKey()
  final bool obscurePassword;
  @override
  @JsonKey()
  final bool obscureConfirmPassword;
  @override
  final String? errorMessage;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AuthStateCopyWith<_AuthState> get copyWith =>
      __$AuthStateCopyWithImpl<_AuthState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AuthState &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.googleLoading, googleLoading) ||
                other.googleLoading == googleLoading) &&
            (identical(other.githubLoading, githubLoading) ||
                other.githubLoading == githubLoading) &&
            (identical(other.activeTab, activeTab) ||
                other.activeTab == activeTab) &&
            (identical(other.obscurePassword, obscurePassword) ||
                other.obscurePassword == obscurePassword) &&
            (identical(other.obscureConfirmPassword, obscureConfirmPassword) ||
                other.obscureConfirmPassword == obscureConfirmPassword) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      loading,
      googleLoading,
      githubLoading,
      activeTab,
      obscurePassword,
      obscureConfirmPassword,
      errorMessage);

  @override
  String toString() {
    return 'AuthState(loading: $loading, googleLoading: $googleLoading, githubLoading: $githubLoading, activeTab: $activeTab, obscurePassword: $obscurePassword, obscureConfirmPassword: $obscureConfirmPassword, errorMessage: $errorMessage)';
  }
}

abstract mixin class _$AuthStateCopyWith<$Res>
    implements $AuthStateCopyWith<$Res> {
  factory _$AuthStateCopyWith(
          _AuthState value, $Res Function(_AuthState) _then) =
      __$AuthStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {bool loading,
      bool googleLoading,
      bool githubLoading,
      AuthTab activeTab,
      bool obscurePassword,
      bool obscureConfirmPassword,
      String? errorMessage});
}

class __$AuthStateCopyWithImpl<$Res> implements _$AuthStateCopyWith<$Res> {
  __$AuthStateCopyWithImpl(this._self, this._then);

  final _AuthState _self;
  final $Res Function(_AuthState) _then;

  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? loading = null,
    Object? googleLoading = null,
    Object? githubLoading = null,
    Object? activeTab = null,
    Object? obscurePassword = null,
    Object? obscureConfirmPassword = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_AuthState(
      loading: null == loading
          ? _self.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      googleLoading: null == googleLoading
          ? _self.googleLoading
          : googleLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      githubLoading: null == githubLoading
          ? _self.githubLoading
          : githubLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      activeTab: null == activeTab
          ? _self.activeTab
          : activeTab // ignore: cast_nullable_to_non_nullable
              as AuthTab,
      obscurePassword: null == obscurePassword
          ? _self.obscurePassword
          : obscurePassword // ignore: cast_nullable_to_non_nullable
              as bool,
      obscureConfirmPassword: null == obscureConfirmPassword
          ? _self.obscureConfirmPassword
          : obscureConfirmPassword // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
