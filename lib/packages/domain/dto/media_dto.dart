import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_dto.freezed.dart';
part 'media_dto.g.dart';

DateTime? _dateFromJson(String? date) =>
    date == null ? null : DateTime.parse(date);

String? _dateToJson(DateTime? date) => date?.toIso8601String();

@freezed
abstract class MediaDto with _$MediaDto {
  factory MediaDto({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'mediaPath') String? mediaPath,
    @JsonKey(name: 'mediaUrl') String? mediaUrl,
    @JsonKey(
      name: 'createdDate',
      fromJson: _dateFromJson,
      toJson: _dateToJson,
    )
    DateTime? createdDate,
  }) = _MediaDto;

  factory MediaDto.fromJson(Map<String, dynamic> json) =>
      _$MediaDtoFromJson(json);
}