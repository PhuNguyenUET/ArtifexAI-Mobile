// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthenticationResponseDto _$AuthenticationResponseDtoFromJson(
        Map<String, dynamic> json) =>
    _AuthenticationResponseDto(
      jwtToken: json['jwtToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
    );

Map<String, dynamic> _$AuthenticationResponseDtoToJson(
        _AuthenticationResponseDto instance) =>
    <String, dynamic>{
      'jwtToken': instance.jwtToken,
      'refreshToken': instance.refreshToken,
    };
