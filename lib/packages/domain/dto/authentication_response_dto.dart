import 'package:freezed_annotation/freezed_annotation.dart';

part 'authentication_response_dto.freezed.dart';
part 'authentication_response_dto.g.dart';

@freezed
abstract class AuthenticationResponseDto with _$AuthenticationResponseDto {
  factory AuthenticationResponseDto({
    @JsonKey(name: 'jwtToken') String? jwtToken,
    @JsonKey(name: 'refreshToken') String? refreshToken,
  }) = _AuthenticationResponseDto;

  factory AuthenticationResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationResponseDtoFromJson(json);
}

