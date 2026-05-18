// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_dto.dart';

// **************************************************************************
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

mixin _$UserDto {
  @JsonKey(name: 'id')
  int? get id;
  @JsonKey(name: 'email')
  String? get email;
  @JsonKey(name: 'authProvider')
  String? get authProvider;
  @JsonKey(name: 'firstName')
  String? get firstName;
  @JsonKey(name: 'lastName')
  String? get lastName;
  @JsonKey(name: 'dateOfBirth', fromJson: _dateFromJson, toJson: _dateToJson)
  DateTime? get dateOfBirth;
  @JsonKey(name: 'emailValidated')
  bool? get emailValidated;

  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserDtoCopyWith<UserDto> get copyWith =>
      _$UserDtoCopyWithImpl<UserDto>(this as UserDto, _$identity);

  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.authProvider, authProvider) ||
                other.authProvider == authProvider) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.emailValidated, emailValidated) ||
                other.emailValidated == emailValidated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, email, authProvider,
      firstName, lastName, dateOfBirth, emailValidated);

  @override
  String toString() {
    return 'UserDto(id: $id, email: $email, authProvider: $authProvider, firstName: $firstName, lastName: $lastName, dateOfBirth: $dateOfBirth, emailValidated: $emailValidated)';
  }
}

abstract mixin class $UserDtoCopyWith<$Res> {
  factory $UserDtoCopyWith(UserDto value, $Res Function(UserDto) _then) =
      _$UserDtoCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int? id,
      @JsonKey(name: 'email') String? email,
      @JsonKey(name: 'authProvider') String? authProvider,
      @JsonKey(name: 'firstName') String? firstName,
      @JsonKey(name: 'lastName') String? lastName,
      @JsonKey(
          name: 'dateOfBirth', fromJson: _dateFromJson, toJson: _dateToJson)
      DateTime? dateOfBirth,
      @JsonKey(name: 'emailValidated') bool? emailValidated});
}

class _$UserDtoCopyWithImpl<$Res> implements $UserDtoCopyWith<$Res> {
  _$UserDtoCopyWithImpl(this._self, this._then);

  final UserDto _self;
  final $Res Function(UserDto) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? email = freezed,
    Object? authProvider = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? dateOfBirth = freezed,
    Object? emailValidated = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      authProvider: freezed == authProvider
          ? _self.authProvider
          : authProvider // ignore: cast_nullable_to_non_nullable
              as String?,
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
      emailValidated: freezed == emailValidated
          ? _self.emailValidated
          : emailValidated // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

extension UserDtoPatterns on UserDto {

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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'id') int? id,
            @JsonKey(name: 'email') String? email,
            @JsonKey(name: 'authProvider') String? authProvider,
            @JsonKey(name: 'firstName') String? firstName,
            @JsonKey(name: 'lastName') String? lastName,
            @JsonKey(
                name: 'dateOfBirth',
                fromJson: _dateFromJson,
                toJson: _dateToJson)
            DateTime? dateOfBirth,
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
            _that.authProvider,
            _that.firstName,
            _that.lastName,
            _that.dateOfBirth,
            _that.emailValidated);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'id') int? id,
            @JsonKey(name: 'email') String? email,
            @JsonKey(name: 'authProvider') String? authProvider,
            @JsonKey(name: 'firstName') String? firstName,
            @JsonKey(name: 'lastName') String? lastName,
            @JsonKey(
                name: 'dateOfBirth',
                fromJson: _dateFromJson,
                toJson: _dateToJson)
            DateTime? dateOfBirth,
            @JsonKey(name: 'emailValidated') bool? emailValidated)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserDto():
        return $default(
            _that.id,
            _that.email,
            _that.authProvider,
            _that.firstName,
            _that.lastName,
            _that.dateOfBirth,
            _that.emailValidated);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            @JsonKey(name: 'id') int? id,
            @JsonKey(name: 'email') String? email,
            @JsonKey(name: 'authProvider') String? authProvider,
            @JsonKey(name: 'firstName') String? firstName,
            @JsonKey(name: 'lastName') String? lastName,
            @JsonKey(
                name: 'dateOfBirth',
                fromJson: _dateFromJson,
                toJson: _dateToJson)
            DateTime? dateOfBirth,
            @JsonKey(name: 'emailValidated') bool? emailValidated)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserDto() when $default != null:
        return $default(
            _that.id,
            _that.email,
            _that.authProvider,
            _that.firstName,
            _that.lastName,
            _that.dateOfBirth,
            _that.emailValidated);
      case _:
        return null;
    }
  }
}

@JsonSerializable()
class _UserDto implements UserDto {
  _UserDto(
      {@JsonKey(name: 'id') this.id,
      @JsonKey(name: 'email') this.email,
      @JsonKey(name: 'authProvider') this.authProvider,
      @JsonKey(name: 'firstName') this.firstName,
      @JsonKey(name: 'lastName') this.lastName,
      @JsonKey(
          name: 'dateOfBirth', fromJson: _dateFromJson, toJson: _dateToJson)
      this.dateOfBirth,
      @JsonKey(name: 'emailValidated') this.emailValidated});
  factory _UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int? id;
  @override
  @JsonKey(name: 'email')
  final String? email;
  @override
  @JsonKey(name: 'authProvider')
  final String? authProvider;
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
  @JsonKey(name: 'emailValidated')
  final bool? emailValidated;

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
            (identical(other.authProvider, authProvider) ||
                other.authProvider == authProvider) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.emailValidated, emailValidated) ||
                other.emailValidated == emailValidated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, email, authProvider,
      firstName, lastName, dateOfBirth, emailValidated);

  @override
  String toString() {
    return 'UserDto(id: $id, email: $email, authProvider: $authProvider, firstName: $firstName, lastName: $lastName, dateOfBirth: $dateOfBirth, emailValidated: $emailValidated)';
  }
}

abstract mixin class _$UserDtoCopyWith<$Res> implements $UserDtoCopyWith<$Res> {
  factory _$UserDtoCopyWith(_UserDto value, $Res Function(_UserDto) _then) =
      __$UserDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int? id,
      @JsonKey(name: 'email') String? email,
      @JsonKey(name: 'authProvider') String? authProvider,
      @JsonKey(name: 'firstName') String? firstName,
      @JsonKey(name: 'lastName') String? lastName,
      @JsonKey(
          name: 'dateOfBirth', fromJson: _dateFromJson, toJson: _dateToJson)
      DateTime? dateOfBirth,
      @JsonKey(name: 'emailValidated') bool? emailValidated});
}

class __$UserDtoCopyWithImpl<$Res> implements _$UserDtoCopyWith<$Res> {
  __$UserDtoCopyWithImpl(this._self, this._then);

  final _UserDto _self;
  final $Res Function(_UserDto) _then;

  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? email = freezed,
    Object? authProvider = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? dateOfBirth = freezed,
    Object? emailValidated = freezed,
  }) {
    return _then(_UserDto(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      email: freezed == email
          ? _self.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      authProvider: freezed == authProvider
          ? _self.authProvider
          : authProvider // ignore: cast_nullable_to_non_nullable
              as String?,
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
      emailValidated: freezed == emailValidated
          ? _self.emailValidated
          : emailValidated // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

// dart format on
