// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reference_image.dart';

// **************************************************************************
// **************************************************************************

_ReferenceImage _$ReferenceImageFromJson(Map<String, dynamic> json) =>
    _ReferenceImage(
      imagePath: json['imagePath'] as String?,
      mimeType: $enumDecodeNullable(_$MimeTypeEnumMap, json['mimeType']),
    );

Map<String, dynamic> _$ReferenceImageToJson(_ReferenceImage instance) =>
    <String, dynamic>{
      'imagePath': instance.imagePath,
      'mimeType': _$MimeTypeEnumMap[instance.mimeType],
    };

const _$MimeTypeEnumMap = {
  MimeType.jpeg: 'JPEG',
  MimeType.png: 'PNG',
};
