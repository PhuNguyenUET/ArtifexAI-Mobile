import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

DateTime? _dateFromJson(String? date) {
  if (date == null) return null;
  // Server returns dd/MM/yyyy format.
  final parts = date.split('/');
  if (parts.length == 3) {
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day != null && month != null && year != null) {
      return DateTime(year, month, day);
    }
  }
  // Fallback for ISO 8601.
  return DateTime.tryParse(date);
}

String? _dateToJson(DateTime? date) {
  if (date == null) return null;
  // Server expects dd/MM/yyyy format.
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

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
