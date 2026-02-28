// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserDto {
  @JsonKey(name: 'id')
  String? get id;
  @JsonKey(name: 'email')
  String? get email;
  @JsonKey(name: 'password')
  String? get password;
  @JsonKey(name: 'authProvider')
  String? get authProvider;
  @JsonKey(name: 'role')
  String? get role;
  @JsonKey(name: 'active')
  bool? get active;
  @JsonKey(name: 'firstName')
  String? get firstName;
  @JsonKey(name: 'lastName')
  String? get lastName;
  @JsonKey(name: 'dateOfBirth', fromJson: _dateFromJson, toJson: _dateToJson)
  DateTime? get dateOfBirth;
  @JsonKey(name: 'failedAttempt')
  int? get failedAttempt;
  @JsonKey(name: 'resetPasswordToken')
  String? get resetPasswordToken;
  @JsonKey(name: 'resetPasswordTokenExpire')
  int? get resetPasswordTokenExpire;
  @JsonKey(name: 'confirmEmailToken')
  String? get confirmEmailToken;
  @JsonKey(name: 'confirmEmailTokenExpire')
  int? get confirmEmailTokenExpire;
  @JsonKey(name: 'emailValidated')
  bool? get emailValidated;

  /// Create a copy of UserDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserDtoCopyWith<UserDto> get copyWith =>
      _$UserDtoCopyWithImpl<UserDto>(this as UserDto, _$identity);

  /// Serializes this UserDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.authProvider, authProvider) ||
                other.authProvider == authProvider) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.active, active) || other.active == active) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.failedAttempt, failedAttempt) ||
                other.failedAttempt == failedAttempt) &&
            (identical(other.resetPasswordToken, resetPasswordToken) ||
                other.resetPasswordToken == resetPasswordToken) &&
            (identical(
                    other.resetPasswordTokenExpire, resetPasswordTokenExpire) ||
                other.resetPasswordTokenExpire == resetPasswordTokenExpire) &&
            (identical(other.confirmEmailToken, confirmEmailToken) ||
                other.confirmEmailToken == confirmEmailToken) &&
            (identical(
                    other.confirmEmailTokenExpire, confirmEmailTokenExpire) ||
                other.confirmEmailTokenExpire == confirmEmailTokenExpire) &&
            (identical(other.emailValidated, emailValidated) ||
                other.emailValidated == emailValidated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      email,
      password,
      authProvider,
      role,
      active,
      firstName,
      lastName,
      dateOfBirth,
      failedAttempt,
      resetPasswordToken,
      resetPasswordTokenExpire,
      confirmEmailToken,
      confirmEmailTokenExpire,
      emailValidated);

  @override
  String toString() {
    return 'UserDto(id: $id, email: $email, password: $password, authProvider: $authProvider, role: $role, active: $active, firstName: $firstName, lastName: $lastName, dateOfBirth: $dateOfBirth, failedAttempt: $failedAttempt, resetPasswordToken: $resetPasswordToken, resetPasswordTokenExpire: $resetPasswordTokenExpire, confirmEmailToken: $confirmEmailToken, confirmEmailTokenExpire: $confirmEmailTokenExpire, emailValidated: $emailValidated)';
  }
}

/// @nodoc
abstract mixin class $UserDtoCopyWith<$Res> {
  factory $UserDtoCopyWith(UserDto value, $Res Function(UserDto) _then) =
      _$UserDtoCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String? id,
      @JsonKey(name: 'email') String? email,
      @JsonKey(name: 'password') String? password,
      @JsonKey(name: 'authProvider') String? authProvider,
      @JsonKey(name: 'role') String? role,
      @JsonKey(name: 'active') bool? active,
      @JsonKey(name: 'firstName') String? firstName,
      @JsonKey(name: 'lastName') String? lastName,
      @JsonKey(
          name: 'dateOfBirth', fromJson: _dateFromJson, toJson: _dateToJson)
      DateTime? dateOfBirth,
      @JsonKey(name: 'failedAttempt') int? failedAttempt,
      @JsonKey(name: 'resetPasswordToken') String? resetPasswordToken,
      @JsonKey(name: 'resetPasswordTokenExpire') int? resetPasswordTokenExpire,
      @JsonKey(name: 'confirmEmailToken') String? confirmEmailToken,
      @JsonKey(name: 'confirmEmailTokenExpire') int? confirmEmailTokenExpire,
      @JsonKey(name: 'emailValidated') bool? emailValidated});
}

/// @nodoc
class _$UserDtoCopyWithImpl<$Res> implements $UserDtoCopyWith<$Res> {
  _$UserDtoCopyWithImpl(this._self, this._then);

  final UserDto _self;
  final $Res Function(UserDto) _then;

  /// Create a copy of UserDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? email = freezed,
    Object? password = freezed,
    Object? authProvider = freezed,
    Object? role = freezed,
    Object? active = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? dateOfBirth = freezed,
    Object? failedAttempt = freezed,
    Object? resetPasswordToken = freezed,
    Object? resetPasswordTokenExpire = freezed,
    Object? confirmEmailToken = freezed,
    Object? confirmEmailTokenExpire = freezed,
    Object? emailValidated = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      authProvider: freezed == authProvider
          ? _self.authProvider
          : authProvider // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      active: freezed == active
          ? _self.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool?,
      firstName: freezed == firstName
          ? _self.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _self.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      dateOfBirth: freezed == dateOfBirth
          ? _self.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      failedAttempt: freezed == failedAttempt
          ? _self.failedAttempt
          : failedAttempt // ignore: cast_nullable_to_non_nullable
              as int?,
      resetPasswordToken: freezed == resetPasswordToken
          ? _self.resetPasswordToken
          : resetPasswordToken // ignore: cast_nullable_to_non_nullable
              as String?,
      resetPasswordTokenExpire: freezed == resetPasswordTokenExpire
          ? _self.resetPasswordTokenExpire
          : resetPasswordTokenExpire // ignore: cast_nullable_to_non_nullable
              as int?,
      confirmEmailToken: freezed == confirmEmailToken
          ? _self.confirmEmailToken
          : confirmEmailToken // ignore: cast_nullable_to_non_nullable
              as String?,
      confirmEmailTokenExpire: freezed == confirmEmailTokenExpire
          ? _self.confirmEmailTokenExpire
          : confirmEmailTokenExpire // ignore: cast_nullable_to_non_nullable
              as int?,
      emailValidated: freezed == emailValidated
          ? _self.emailValidated
          : emailValidated // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// Adds pattern-matching-related methods to [UserDto].
extension UserDtoPatterns on UserDto {
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
    TResult Function(_UserDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserDto() when $default != null:
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
    TResult Function(_UserDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserDto():
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
    TResult? Function(_UserDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserDto() when $default != null:
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
    TResult Function(
            @JsonKey(name: 'id') String? id,
            @JsonKey(name: 'email') String? email,
            @JsonKey(name: 'password') String? password,
            @JsonKey(name: 'authProvider') String? authProvider,
            @JsonKey(name: 'role') String? role,
            @JsonKey(name: 'active') bool? active,
            @JsonKey(name: 'firstName') String? firstName,
            @JsonKey(name: 'lastName') String? lastName,
            @JsonKey(
                name: 'dateOfBirth',
                fromJson: _dateFromJson,
                toJson: _dateToJson)
            DateTime? dateOfBirth,
            @JsonKey(name: 'failedAttempt') int? failedAttempt,
            @JsonKey(name: 'resetPasswordToken') String? resetPasswordToken,
            @JsonKey(name: 'resetPasswordTokenExpire')
            int? resetPasswordTokenExpire,
            @JsonKey(name: 'confirmEmailToken') String? confirmEmailToken,
            @JsonKey(name: 'confirmEmailTokenExpire')
            int? confirmEmailTokenExpire,
            @JsonKey(name: 'emailValidated') bool? emailValidated)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserDto() when $default != null:
        return $default(
            _that.id,
            _that.email,
            _that.password,
            _that.authProvider,
            _that.role,
            _that.active,
            _that.firstName,
            _that.lastName,
            _that.dateOfBirth,
            _that.failedAttempt,
            _that.resetPasswordToken,
            _that.resetPasswordTokenExpire,
            _that.confirmEmailToken,
            _that.confirmEmailTokenExpire,
            _that.emailValidated);
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
    TResult Function(
            @JsonKey(name: 'id') String? id,
            @JsonKey(name: 'email') String? email,
            @JsonKey(name: 'password') String? password,
            @JsonKey(name: 'authProvider') String? authProvider,
            @JsonKey(name: 'role') String? role,
            @JsonKey(name: 'active') bool? active,
            @JsonKey(name: 'firstName') String? firstName,
            @JsonKey(name: 'lastName') String? lastName,
            @JsonKey(
                name: 'dateOfBirth',
                fromJson: _dateFromJson,
                toJson: _dateToJson)
            DateTime? dateOfBirth,
            @JsonKey(name: 'failedAttempt') int? failedAttempt,
            @JsonKey(name: 'resetPasswordToken') String? resetPasswordToken,
            @JsonKey(name: 'resetPasswordTokenExpire')
            int? resetPasswordTokenExpire,
            @JsonKey(name: 'confirmEmailToken') String? confirmEmailToken,
            @JsonKey(name: 'confirmEmailTokenExpire')
            int? confirmEmailTokenExpire,
            @JsonKey(name: 'emailValidated') bool? emailValidated)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserDto():
        return $default(
            _that.id,
            _that.email,
            _that.password,
            _that.authProvider,
            _that.role,
            _that.active,
            _that.firstName,
            _that.lastName,
            _that.dateOfBirth,
            _that.failedAttempt,
            _that.resetPasswordToken,
            _that.resetPasswordTokenExpire,
            _that.confirmEmailToken,
            _that.confirmEmailTokenExpire,
            _that.emailValidated);
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
    TResult? Function(
            @JsonKey(name: 'id') String? id,
            @JsonKey(name: 'email') String? email,
            @JsonKey(name: 'password') String? password,
            @JsonKey(name: 'authProvider') String? authProvider,
            @JsonKey(name: 'role') String? role,
            @JsonKey(name: 'active') bool? active,
            @JsonKey(name: 'firstName') String? firstName,
            @JsonKey(name: 'lastName') String? lastName,
            @JsonKey(
                name: 'dateOfBirth',
                fromJson: _dateFromJson,
                toJson: _dateToJson)
            DateTime? dateOfBirth,
            @JsonKey(name: 'failedAttempt') int? failedAttempt,
            @JsonKey(name: 'resetPasswordToken') String? resetPasswordToken,
            @JsonKey(name: 'resetPasswordTokenExpire')
            int? resetPasswordTokenExpire,
            @JsonKey(name: 'confirmEmailToken') String? confirmEmailToken,
            @JsonKey(name: 'confirmEmailTokenExpire')
            int? confirmEmailTokenExpire,
            @JsonKey(name: 'emailValidated') bool? emailValidated)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserDto() when $default != null:
        return $default(
            _that.id,
            _that.email,
            _that.password,
            _that.authProvider,
            _that.role,
            _that.active,
            _that.firstName,
            _that.lastName,
            _that.dateOfBirth,
            _that.failedAttempt,
            _that.resetPasswordToken,
            _that.resetPasswordTokenExpire,
            _that.confirmEmailToken,
            _that.confirmEmailTokenExpire,
            _that.emailValidated);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _UserDto implements UserDto {
  _UserDto(
      {@JsonKey(name: 'id') this.id,
      @JsonKey(name: 'email') this.email,
      @JsonKey(name: 'password') this.password,
      @JsonKey(name: 'authProvider') this.authProvider,
      @JsonKey(name: 'role') this.role,
      @JsonKey(name: 'active') this.active,
      @JsonKey(name: 'firstName') this.firstName,
      @JsonKey(name: 'lastName') this.lastName,
      @JsonKey(
          name: 'dateOfBirth', fromJson: _dateFromJson, toJson: _dateToJson)
      this.dateOfBirth,
      @JsonKey(name: 'failedAttempt') this.failedAttempt,
      @JsonKey(name: 'resetPasswordToken') this.resetPasswordToken,
      @JsonKey(name: 'resetPasswordTokenExpire') this.resetPasswordTokenExpire,
      @JsonKey(name: 'confirmEmailToken') this.confirmEmailToken,
      @JsonKey(name: 'confirmEmailTokenExpire') this.confirmEmailTokenExpire,
      @JsonKey(name: 'emailValidated') this.emailValidated});
  factory _UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String? id;
  @override
  @JsonKey(name: 'email')
  final String? email;
  @override
  @JsonKey(name: 'password')
  final String? password;
  @override
  @JsonKey(name: 'authProvider')
  final String? authProvider;
  @override
  @JsonKey(name: 'role')
  final String? role;
  @override
  @JsonKey(name: 'active')
  final bool? active;
  @override
  @JsonKey(name: 'firstName')
  final String? firstName;
  @override
  @JsonKey(name: 'lastName')
  final String? lastName;
  @override
  @JsonKey(name: 'dateOfBirth', fromJson: _dateFromJson, toJson: _dateToJson)
  final DateTime? dateOfBirth;
  @override
  @JsonKey(name: 'failedAttempt')
  final int? failedAttempt;
  @override
  @JsonKey(name: 'resetPasswordToken')
  final String? resetPasswordToken;
  @override
  @JsonKey(name: 'resetPasswordTokenExpire')
  final int? resetPasswordTokenExpire;
  @override
  @JsonKey(name: 'confirmEmailToken')
  final String? confirmEmailToken;
  @override
  @JsonKey(name: 'confirmEmailTokenExpire')
  final int? confirmEmailTokenExpire;
  @override
  @JsonKey(name: 'emailValidated')
  final bool? emailValidated;

  /// Create a copy of UserDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserDtoCopyWith<_UserDto> get copyWith =>
      __$UserDtoCopyWithImpl<_UserDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.authProvider, authProvider) ||
                other.authProvider == authProvider) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.active, active) || other.active == active) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.failedAttempt, failedAttempt) ||
                other.failedAttempt == failedAttempt) &&
            (identical(other.resetPasswordToken, resetPasswordToken) ||
                other.resetPasswordToken == resetPasswordToken) &&
            (identical(
                    other.resetPasswordTokenExpire, resetPasswordTokenExpire) ||
                other.resetPasswordTokenExpire == resetPasswordTokenExpire) &&
            (identical(other.confirmEmailToken, confirmEmailToken) ||
                other.confirmEmailToken == confirmEmailToken) &&
            (identical(
                    other.confirmEmailTokenExpire, confirmEmailTokenExpire) ||
                other.confirmEmailTokenExpire == confirmEmailTokenExpire) &&
            (identical(other.emailValidated, emailValidated) ||
                other.emailValidated == emailValidated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      email,
      password,
      authProvider,
      role,
      active,
      firstName,
      lastName,
      dateOfBirth,
      failedAttempt,
      resetPasswordToken,
      resetPasswordTokenExpire,
      confirmEmailToken,
      confirmEmailTokenExpire,
      emailValidated);

  @override
  String toString() {
    return 'UserDto(id: $id, email: $email, password: $password, authProvider: $authProvider, role: $role, active: $active, firstName: $firstName, lastName: $lastName, dateOfBirth: $dateOfBirth, failedAttempt: $failedAttempt, resetPasswordToken: $resetPasswordToken, resetPasswordTokenExpire: $resetPasswordTokenExpire, confirmEmailToken: $confirmEmailToken, confirmEmailTokenExpire: $confirmEmailTokenExpire, emailValidated: $emailValidated)';
  }
}

/// @nodoc
abstract mixin class _$UserDtoCopyWith<$Res> implements $UserDtoCopyWith<$Res> {
  factory _$UserDtoCopyWith(_UserDto value, $Res Function(_UserDto) _then) =
      __$UserDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String? id,
      @JsonKey(name: 'email') String? email,
      @JsonKey(name: 'password') String? password,
      @JsonKey(name: 'authProvider') String? authProvider,
      @JsonKey(name: 'role') String? role,
      @JsonKey(name: 'active') bool? active,
      @JsonKey(name: 'firstName') String? firstName,
      @JsonKey(name: 'lastName') String? lastName,
      @JsonKey(
          name: 'dateOfBirth', fromJson: _dateFromJson, toJson: _dateToJson)
      DateTime? dateOfBirth,
      @JsonKey(name: 'failedAttempt') int? failedAttempt,
      @JsonKey(name: 'resetPasswordToken') String? resetPasswordToken,
      @JsonKey(name: 'resetPasswordTokenExpire') int? resetPasswordTokenExpire,
      @JsonKey(name: 'confirmEmailToken') String? confirmEmailToken,
      @JsonKey(name: 'confirmEmailTokenExpire') int? confirmEmailTokenExpire,
      @JsonKey(name: 'emailValidated') bool? emailValidated});
}

/// @nodoc
class __$UserDtoCopyWithImpl<$Res> implements _$UserDtoCopyWith<$Res> {
  __$UserDtoCopyWithImpl(this._self, this._then);

  final _UserDto _self;
  final $Res Function(_UserDto) _then;

  /// Create a copy of UserDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? email = freezed,
    Object? password = freezed,
    Object? authProvider = freezed,
    Object? role = freezed,
    Object? active = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? dateOfBirth = freezed,
    Object? failedAttempt = freezed,
    Object? resetPasswordToken = freezed,
    Object? resetPasswordTokenExpire = freezed,
    Object? confirmEmailToken = freezed,
    Object? confirmEmailTokenExpire = freezed,
    Object? emailValidated = freezed,
  }) {
    return _then(_UserDto(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      password: freezed == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      authProvider: freezed == authProvider
          ? _self.authProvider
          : authProvider // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _self.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      active: freezed == active
          ? _self.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool?,
      firstName: freezed == firstName
          ? _self.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _self.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      dateOfBirth: freezed == dateOfBirth
          ? _self.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      failedAttempt: freezed == failedAttempt
          ? _self.failedAttempt
          : failedAttempt // ignore: cast_nullable_to_non_nullable
              as int?,
      resetPasswordToken: freezed == resetPasswordToken
          ? _self.resetPasswordToken
          : resetPasswordToken // ignore: cast_nullable_to_non_nullable
              as String?,
      resetPasswordTokenExpire: freezed == resetPasswordTokenExpire
          ? _self.resetPasswordTokenExpire
          : resetPasswordTokenExpire // ignore: cast_nullable_to_non_nullable
              as int?,
      confirmEmailToken: freezed == confirmEmailToken
          ? _self.confirmEmailToken
          : confirmEmailToken // ignore: cast_nullable_to_non_nullable
              as String?,
      confirmEmailTokenExpire: freezed == confirmEmailTokenExpire
          ? _self.confirmEmailTokenExpire
          : confirmEmailTokenExpire // ignore: cast_nullable_to_non_nullable
              as int?,
      emailValidated: freezed == emailValidated
          ? _self.emailValidated
          : emailValidated // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

// dart format on
