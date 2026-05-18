// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_dto.dart';

// **************************************************************************
// **************************************************************************

_AlbumDto _$AlbumDtoFromJson(Map<String, dynamic> json) => _AlbumDto(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      mediaList: (json['mediaList'] as List<dynamic>?)
          ?.map((e) => MediaDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdDate: _dateFromJson(json['createdDate'] as String?),
      modifiedDate: _dateFromJson(json['modifiedDate'] as String?),
    );

Map<String, dynamic> _$AlbumDtoToJson(_AlbumDto instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'mediaList': instance.mediaList,
      'createdDate': _dateToJson(instance.createdDate),
      'modifiedDate': _dateToJson(instance.modifiedDate),
    };
