import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_response_dto.freezed.dart';
part 'video_response_dto.g.dart';

@freezed
abstract class VideoResponseDto with _$VideoResponseDto {
  factory VideoResponseDto({
    @JsonKey(name: 'videoUrl') String? videoUrl,
    @JsonKey(name: 'updatedInstruction') String? updatedInstruction,
  }) = _VideoResponseDto;

  factory VideoResponseDto.fromJson(Map<String, dynamic> json) =>
      _$VideoResponseDtoFromJson(json);
}

