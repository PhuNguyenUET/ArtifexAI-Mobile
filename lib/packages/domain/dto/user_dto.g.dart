// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserDto _$UserDtoFromJson(Map<String, dynamic> json) => _UserDto(
      id: json['id'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      authProvider: json['authProvider'] as String?,
      role: json['role'] as String?,
      active: json['active'] as bool?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      dateOfBirth: _dateFromJson(json['dateOfBirth'] as String?),
      failedAttempt: (json['failedAttempt'] as num?)?.toInt(),
      resetPasswordToken: json['resetPasswordToken'] as String?,
      resetPasswordTokenExpire:
          (json['resetPasswordTokenExpire'] as num?)?.toInt(),
      confirmEmailToken: json['confirmEmailToken'] as String?,
      confirmEmailTokenExpire:
          (json['confirmEmailTokenExpire'] as num?)?.toInt(),
      emailValidated: json['emailValidated'] as bool?,
    );

Map<String, dynamic> _$UserDtoToJson(_UserDto instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'password': instance.password,
      'authProvider': instance.authProvider,
      'role': instance.role,
      'active': instance.active,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'dateOfBirth': _dateToJson(instance.dateOfBirth),
      'failedAttempt': instance.failedAttempt,
      'resetPasswordToken': instance.resetPasswordToken,
      'resetPasswordTokenExpire': instance.resetPasswordTokenExpire,
      'confirmEmailToken': instance.confirmEmailToken,
      'confirmEmailTokenExpire': instance.confirmEmailTokenExpire,
      'emailValidated': instance.emailValidated,
    };
