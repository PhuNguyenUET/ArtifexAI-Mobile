import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

DateTime? _dateFromJson(String? date) =>
    date == null ? null : DateTime.parse(date);

String? _dateToJson(DateTime? date) => date?.toIso8601String();

@freezed
abstract class UserDto with _$UserDto {
  factory UserDto({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'authProvider') String? authProvider,
    @JsonKey(name: 'firstName') String? firstName,
    @JsonKey(name: 'lastName') String? lastName,
    @JsonKey(
      name: 'dateOfBirth',
      fromJson: _dateFromJson,
      toJson: _dateToJson,
    )
    DateTime? dateOfBirth,
    @JsonKey(name: 'emailValidated') bool? emailValidated,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}