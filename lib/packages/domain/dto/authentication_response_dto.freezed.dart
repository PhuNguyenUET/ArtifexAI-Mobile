// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'authentication_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthenticationResponseDto {
  @JsonKey(name: 'jwtToken')
  String? get jwtToken;
  @JsonKey(name: 'refreshToken')
  String? get refreshToken;

  /// Create a copy of AuthenticationResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthenticationResponseDtoCopyWith<AuthenticationResponseDto> get copyWith =>
      _$AuthenticationResponseDtoCopyWithImpl<AuthenticationResponseDto>(
          this as AuthenticationResponseDto, _$identity);

  /// Serializes this AuthenticationResponseDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthenticationResponseDto &&
            (identical(other.jwtToken, jwtToken) ||
                other.jwtToken == jwtToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, jwtToken, refreshToken);

  @override
  String toString() {
    return 'AuthenticationResponseDto(jwtToken: $jwtToken, refreshToken: $refreshToken)';
  }
}

/// @nodoc
abstract mixin class $AuthenticationResponseDtoCopyWith<$Res> {
  factory $AuthenticationResponseDtoCopyWith(AuthenticationResponseDto value,
          $Res Function(AuthenticationResponseDto) _then) =
      _$AuthenticationResponseDtoCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'jwtToken') String? jwtToken,
      @JsonKey(name: 'refreshToken') String? refreshToken});
}

/// @nodoc
class _$AuthenticationResponseDtoCopyWithImpl<$Res>
    implements $AuthenticationResponseDtoCopyWith<$Res> {
  _$AuthenticationResponseDtoCopyWithImpl(this._self, this._then);

  final AuthenticationResponseDto _self;
  final $Res Function(AuthenticationResponseDto) _then;

  /// Create a copy of AuthenticationResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? jwtToken = freezed,
    Object? refreshToken = freezed,
  }) {
    return _then(_self.copyWith(
      jwtToken: freezed == jwtToken
          ? _self.jwtToken
          : jwtToken // ignore: cast_nullable_to_non_nullable
              as String?,
      refreshToken: freezed == refreshToken
          ? _self.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [AuthenticationResponseDto].
extension AuthenticationResponseDtoPatterns on AuthenticationResponseDto {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_AuthenticationResponseDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AuthenticationResponseDto() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_AuthenticationResponseDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthenticationResponseDto():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_AuthenticationResponseDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthenticationResponseDto() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(@JsonKey(name: 'jwtToken') String? jwtToken,
            @JsonKey(name: 'refreshToken') String? refreshToken)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AuthenticationResponseDto() when $default != null:
        return $default(_that.jwtToken, _that.refreshToken);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(@JsonKey(name: 'jwtToken') String? jwtToken,
            @JsonKey(name: 'refreshToken') String? refreshToken)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthenticationResponseDto():
        return $default(_that.jwtToken, _that.refreshToken);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(@JsonKey(name: 'jwtToken') String? jwtToken,
            @JsonKey(name: 'refreshToken') String? refreshToken)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AuthenticationResponseDto() when $default != null:
        return $default(_that.jwtToken, _that.refreshToken);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AuthenticationResponseDto implements AuthenticationResponseDto {
  _AuthenticationResponseDto(
      {@JsonKey(name: 'jwtToken') this.jwtToken,
      @JsonKey(name: 'refreshToken') this.refreshToken});
  factory _AuthenticationResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationResponseDtoFromJson(json);

  @override
  @JsonKey(name: 'jwtToken')
  final String? jwtToken;
  @override
  @JsonKey(name: 'refreshToken')
  final String? refreshToken;

  /// Create a copy of AuthenticationResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AuthenticationResponseDtoCopyWith<_AuthenticationResponseDto>
      get copyWith =>
          __$AuthenticationResponseDtoCopyWithImpl<_AuthenticationResponseDto>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AuthenticationResponseDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AuthenticationResponseDto &&
            (identical(other.jwtToken, jwtToken) ||
                other.jwtToken == jwtToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, jwtToken, refreshToken);

  @override
  String toString() {
    return 'AuthenticationResponseDto(jwtToken: $jwtToken, refreshToken: $refreshToken)';
  }
}

/// @nodoc
abstract mixin class _$AuthenticationResponseDtoCopyWith<$Res>
    implements $AuthenticationResponseDtoCopyWith<$Res> {
  factory _$AuthenticationResponseDtoCopyWith(_AuthenticationResponseDto value,
          $Res Function(_AuthenticationResponseDto) _then) =
      __$AuthenticationResponseDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'jwtToken') String? jwtToken,
      @JsonKey(name: 'refreshToken') String? refreshToken});
}

/// @nodoc
class __$AuthenticationResponseDtoCopyWithImpl<$Res>
    implements _$AuthenticationResponseDtoCopyWith<$Res> {
  __$AuthenticationResponseDtoCopyWithImpl(this._self, this._then);

  final _AuthenticationResponseDto _self;
  final $Res Function(_AuthenticationResponseDto) _then;

  /// Create a copy of AuthenticationResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? jwtToken = freezed,
    Object? refreshToken = freezed,
  }) {
    return _then(_AuthenticationResponseDto(
      jwtToken: freezed == jwtToken
          ? _self.jwtToken
          : jwtToken // ignore: cast_nullable_to_non_nullable
              as String?,
      refreshToken: freezed == refreshToken
          ? _self.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
