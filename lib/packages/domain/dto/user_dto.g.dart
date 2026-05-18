// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// **************************************************************************

_UserDto _$UserDtoFromJson(Map<String, dynamic> json) => _UserDto(
      id: (json['id'] as num?)?.toInt(),
      email: json['email'] as String?,
      authProvider: json['authProvider'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      dateOfBirth: _dateFromJson(json['dateOfBirth'] as String?),
      emailValidated: json['emailValidated'] as bool?,
    );

Map<String, dynamic> _$UserDtoToJson(_UserDto instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'authProvider': instance.authProvider,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'dateOfBirth': _dateToJson(instance.dateOfBirth),
      'emailValidated': instance.emailValidated,
    };
