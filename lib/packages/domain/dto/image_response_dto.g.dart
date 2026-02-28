// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ImageResponseDto _$ImageResponseDtoFromJson(Map<String, dynamic> json) =>
    _ImageResponseDto(
      imageUrls: (json['imageUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      updatedInstruction: json['updatedInstruction'] as String?,
    );

Map<String, dynamic> _$ImageResponseDtoToJson(_ImageResponseDto instance) =>
    <String, dynamic>{
      'imageUrls': instance.imageUrls,
      'updatedInstruction': instance.updatedInstruction,
    };
