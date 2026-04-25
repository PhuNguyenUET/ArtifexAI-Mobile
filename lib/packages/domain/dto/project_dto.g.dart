// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectDto _$ProjectDtoFromJson(Map<String, dynamic> json) => _ProjectDto(
      id: (json['id'] as num?)?.toInt(),
      projectName: json['projectName'] as String?,
      instructions: (json['instructions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      artStyle: $enumDecodeNullable(_$ArtStyleEnumMap, json['artStyle']),
      createdDate: _dateFromJson(json['createdDate'] as String?),
      modifiedDate: _dateFromJson(json['modifiedDate'] as String?),
    );

Map<String, dynamic> _$ProjectDtoToJson(_ProjectDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'projectName': instance.projectName,
      'instructions': instance.instructions,
      'artStyle': _$ArtStyleEnumMap[instance.artStyle],
      'createdDate': _dateToJson(instance.createdDate),
      'modifiedDate': _dateToJson(instance.modifiedDate),
    };

const _$ArtStyleEnumMap = {
  ArtStyle.pixelated: 'PIXELATED',
  ArtStyle.handDrawn: 'HAND_DRAWN',
  ArtStyle.minimalist: 'MINIMALIST',
  ArtStyle.anime: 'ANIME',
  ArtStyle.cartoon: 'CARTOON',
  ArtStyle.realistic: 'REALISTIC',
  ArtStyle.hyperRealistic: 'HYPER_REALISTIC',
  ArtStyle.custom: 'CUSTOM',
};
