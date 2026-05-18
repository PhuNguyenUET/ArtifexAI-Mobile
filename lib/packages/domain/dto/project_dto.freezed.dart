// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_dto.dart';

// **************************************************************************
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

mixin _$ProjectDto {
  @JsonKey(name: 'id')
  int? get id;
  @JsonKey(name: 'projectName')
  String? get projectName;
  @JsonKey(name: 'instructions')
  List<String>? get instructions;
  @JsonKey(name: 'artStyle')
  ArtStyle? get artStyle;
  @JsonKey(name: 'createdDate', fromJson: _dateFromJson, toJson: _dateToJson)
  DateTime? get createdDate;
  @JsonKey(name: 'modifiedDate', fromJson: _dateFromJson, toJson: _dateToJson)
  DateTime? get modifiedDate;

  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProjectDtoCopyWith<ProjectDto> get copyWith =>
      _$ProjectDtoCopyWithImpl<ProjectDto>(this as ProjectDto, _$identity);

  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProjectDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.projectName, projectName) ||
                other.projectName == projectName) &&
            const DeepCollectionEquality()
                .equals(other.instructions, instructions) &&
            (identical(other.artStyle, artStyle) ||
                other.artStyle == artStyle) &&
            (identical(other.createdDate, createdDate) ||
                other.createdDate == createdDate) &&
            (identical(other.modifiedDate, modifiedDate) ||
                other.modifiedDate == modifiedDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      projectName,
      const DeepCollectionEquality().hash(instructions),
      artStyle,
      createdDate,
      modifiedDate);

  @override
  String toString() {
    return 'ProjectDto(id: $id, projectName: $projectName, instructions: $instructions, artStyle: $artStyle, createdDate: $createdDate, modifiedDate: $modifiedDate)';
  }
}

abstract mixin class $ProjectDtoCopyWith<$Res> {
  factory $ProjectDtoCopyWith(
          ProjectDto value, $Res Function(ProjectDto) _then) =
      _$ProjectDtoCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int? id,
      @JsonKey(name: 'projectName') String? projectName,
      @JsonKey(name: 'instructions') List<String>? instructions,
      @JsonKey(name: 'artStyle') ArtStyle? artStyle,
      @JsonKey(
          name: 'createdDate', fromJson: _dateFromJson, toJson: _dateToJson)
      DateTime? createdDate,
      @JsonKey(
          name: 'modifiedDate', fromJson: _dateFromJson, toJson: _dateToJson)
      DateTime? modifiedDate});
}

class _$ProjectDtoCopyWithImpl<$Res> implements $ProjectDtoCopyWith<$Res> {
  _$ProjectDtoCopyWithImpl(this._self, this._then);

  final ProjectDto _self;
  final $Res Function(ProjectDto) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? projectName = freezed,
    Object? instructions = freezed,
    Object? artStyle = freezed,
    Object? createdDate = freezed,
    Object? modifiedDate = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      projectName: freezed == projectName
          ? _self.projectName
          : projectName // ignore: cast_nullable_to_non_nullable
              as String?,
      instructions: freezed == instructions
          ? _self.instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      artStyle: freezed == artStyle
          ? _self.artStyle
          : artStyle // ignore: cast_nullable_to_non_nullable
              as ArtStyle?,
      createdDate: freezed == createdDate
          ? _self.createdDate
          : createdDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      modifiedDate: freezed == modifiedDate
          ? _self.modifiedDate
          : modifiedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

extension ProjectDtoPatterns on ProjectDto {

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ProjectDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProjectDto() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ProjectDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProjectDto():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ProjectDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProjectDto() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'id') int? id,
            @JsonKey(name: 'projectName') String? projectName,
            @JsonKey(name: 'instructions') List<String>? instructions,
            @JsonKey(name: 'artStyle') ArtStyle? artStyle,
            @JsonKey(
                name: 'createdDate',
                fromJson: _dateFromJson,
                toJson: _dateToJson)
            DateTime? createdDate,
            @JsonKey(
                name: 'modifiedDate',
                fromJson: _dateFromJson,
                toJson: _dateToJson)
            DateTime? modifiedDate)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ProjectDto() when $default != null:
        return $default(_that.id, _that.projectName, _that.instructions,
            _that.artStyle, _that.createdDate, _that.modifiedDate);
      case _:
        return orElse();
    }
  }

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'id') int? id,
            @JsonKey(name: 'projectName') String? projectName,
            @JsonKey(name: 'instructions') List<String>? instructions,
            @JsonKey(name: 'artStyle') ArtStyle? artStyle,
            @JsonKey(
                name: 'createdDate',
                fromJson: _dateFromJson,
                toJson: _dateToJson)
            DateTime? createdDate,
            @JsonKey(
                name: 'modifiedDate',
                fromJson: _dateFromJson,
                toJson: _dateToJson)
            DateTime? modifiedDate)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProjectDto():
        return $default(_that.id, _that.projectName, _that.instructions,
            _that.artStyle, _that.createdDate, _that.modifiedDate);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            @JsonKey(name: 'id') int? id,
            @JsonKey(name: 'projectName') String? projectName,
            @JsonKey(name: 'instructions') List<String>? instructions,
            @JsonKey(name: 'artStyle') ArtStyle? artStyle,
            @JsonKey(
                name: 'createdDate',
                fromJson: _dateFromJson,
                toJson: _dateToJson)
            DateTime? createdDate,
            @JsonKey(
                name: 'modifiedDate',
                fromJson: _dateFromJson,
                toJson: _dateToJson)
            DateTime? modifiedDate)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ProjectDto() when $default != null:
        return $default(_that.id, _that.projectName, _that.instructions,
            _that.artStyle, _that.createdDate, _that.modifiedDate);
      case _:
        return null;
    }
  }
}

@JsonSerializable()
class _ProjectDto implements ProjectDto {
  _ProjectDto(
      {@JsonKey(name: 'id') this.id,
      @JsonKey(name: 'projectName') this.projectName,
      @JsonKey(name: 'instructions') final List<String>? instructions,
      @JsonKey(name: 'artStyle') this.artStyle,
      @JsonKey(
          name: 'createdDate', fromJson: _dateFromJson, toJson: _dateToJson)
      this.createdDate,
      @JsonKey(
          name: 'modifiedDate', fromJson: _dateFromJson, toJson: _dateToJson)
      this.modifiedDate})
      : _instructions = instructions;
  factory _ProjectDto.fromJson(Map<String, dynamic> json) =>
      _$ProjectDtoFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int? id;
  @override
  @JsonKey(name: 'projectName')
  final String? projectName;
  final List<String>? _instructions;
  @override
  @JsonKey(name: 'instructions')
  List<String>? get instructions {
    final value = _instructions;
    if (value == null) return null;
    if (_instructions is EqualUnmodifiableListView) return _instructions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'artStyle')
  final ArtStyle? artStyle;
  @override
  @JsonKey(name: 'createdDate', fromJson: _dateFromJson, toJson: _dateToJson)
  final DateTime? createdDate;
  @override
  @JsonKey(name: 'modifiedDate', fromJson: _dateFromJson, toJson: _dateToJson)
  final DateTime? modifiedDate;

  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ProjectDtoCopyWith<_ProjectDto> get copyWith =>
      __$ProjectDtoCopyWithImpl<_ProjectDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ProjectDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ProjectDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.projectName, projectName) ||
                other.projectName == projectName) &&
            const DeepCollectionEquality()
                .equals(other._instructions, _instructions) &&
            (identical(other.artStyle, artStyle) ||
                other.artStyle == artStyle) &&
            (identical(other.createdDate, createdDate) ||
                other.createdDate == createdDate) &&
            (identical(other.modifiedDate, modifiedDate) ||
                other.modifiedDate == modifiedDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      projectName,
      const DeepCollectionEquality().hash(_instructions),
      artStyle,
      createdDate,
      modifiedDate);

  @override
  String toString() {
    return 'ProjectDto(id: $id, projectName: $projectName, instructions: $instructions, artStyle: $artStyle, createdDate: $createdDate, modifiedDate: $modifiedDate)';
  }
}

abstract mixin class _$ProjectDtoCopyWith<$Res>
    implements $ProjectDtoCopyWith<$Res> {
  factory _$ProjectDtoCopyWith(
          _ProjectDto value, $Res Function(_ProjectDto) _then) =
      __$ProjectDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int? id,
      @JsonKey(name: 'projectName') String? projectName,
      @JsonKey(name: 'instructions') List<String>? instructions,
      @JsonKey(name: 'artStyle') ArtStyle? artStyle,
      @JsonKey(
          name: 'createdDate', fromJson: _dateFromJson, toJson: _dateToJson)
      DateTime? createdDate,
      @JsonKey(
          name: 'modifiedDate', fromJson: _dateFromJson, toJson: _dateToJson)
      DateTime? modifiedDate});
}

class __$ProjectDtoCopyWithImpl<$Res> implements _$ProjectDtoCopyWith<$Res> {
  __$ProjectDtoCopyWithImpl(this._self, this._then);

  final _ProjectDto _self;
  final $Res Function(_ProjectDto) _then;

  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? projectName = freezed,
    Object? instructions = freezed,
    Object? artStyle = freezed,
    Object? createdDate = freezed,
    Object? modifiedDate = freezed,
  }) {
    return _then(_ProjectDto(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      projectName: freezed == projectName
          ? _self.projectName
          : projectName // ignore: cast_nullable_to_non_nullable
              as String?,
      instructions: freezed == instructions
          ? _self._instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      artStyle: freezed == artStyle
          ? _self.artStyle
          : artStyle // ignore: cast_nullable_to_non_nullable
              as ArtStyle?,
      createdDate: freezed == createdDate
          ? _self.createdDate
          : createdDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      modifiedDate: freezed == modifiedDate
          ? _self.modifiedDate
          : modifiedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
