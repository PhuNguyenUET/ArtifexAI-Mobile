import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:artifex_ai_mobile/packages/domain/dto/media_dto.dart';

part 'album_dto.freezed.dart';
part 'album_dto.g.dart';

DateTime? _dateFromJson(String? date) =>
    date == null ? null : DateTime.parse(date);

String? _dateToJson(DateTime? date) => date?.toIso8601String();

@freezed
abstract class AlbumDto with _$AlbumDto {
  factory AlbumDto({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'mediaList') List<MediaDto>? mediaList,
    @JsonKey(
      name: 'createdDate',
      fromJson: _dateFromJson,
      toJson: _dateToJson,
    )
    DateTime? createdDate,
    @JsonKey(
      name: 'modifiedDate',
      fromJson: _dateFromJson,
      toJson: _dateToJson,
    )
    DateTime? modifiedDate,
  }) = _AlbumDto;

  factory AlbumDto.fromJson(Map<String, dynamic> json) =>
      _$AlbumDtoFromJson(json);
}

