import 'package:freezed_annotation/freezed_annotation.dart';

part 'image_response_dto.freezed.dart';
part 'image_response_dto.g.dart';

@freezed
abstract class ImageResponseDto with _$ImageResponseDto {
  factory ImageResponseDto({
    @JsonKey(name: 'imageUrls') List<String>? imageUrls,
    @JsonKey(name: 'updatedInstruction') String? updatedInstruction,
  }) = _ImageResponseDto;

  factory ImageResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ImageResponseDtoFromJson(json);
}

