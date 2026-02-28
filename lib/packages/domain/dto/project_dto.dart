import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:artifex_ai_mobile/packages/domain/enum/index.dart';

part 'project_dto.freezed.dart';
part 'project_dto.g.dart';

DateTime? _dateFromJson(String? date) =>
    date == null ? null : DateTime.parse(date);

String? _dateToJson(DateTime? date) => date?.toIso8601String();


@freezed
abstract class ProjectDto with _$ProjectDto {
  factory ProjectDto({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'projectName') String? projectName,
    @JsonKey(name: 'instructions') List<String>? instructions,
    @JsonKey(name: 'artStyle') ArtStyle? artStyle,
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
  }) = _ProjectDto;

  factory ProjectDto.fromJson(Map<String, dynamic> json) =>
      _$ProjectDtoFromJson(json);
}

