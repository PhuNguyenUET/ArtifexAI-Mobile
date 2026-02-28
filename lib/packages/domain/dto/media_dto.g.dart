// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MediaDto _$MediaDtoFromJson(Map<String, dynamic> json) => _MediaDto(
      id: json['id'] as String?,
      mediaPath: json['mediaPath'] as String?,
      mediaUrl: json['mediaUrl'] as String?,
      createdDate: _dateFromJson(json['createdDate'] as String?),
    );

Map<String, dynamic> _$MediaDtoToJson(_MediaDto instance) => <String, dynamic>{
      'id': instance.id,
      'mediaPath': instance.mediaPath,
      'mediaUrl': instance.mediaUrl,
      'createdDate': _dateToJson(instance.createdDate),
    };
