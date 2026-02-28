// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProjectDto {
  @JsonKey(name: 'id')
  String? get id;
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

  /// Create a copy of ProjectDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ProjectDtoCopyWith<ProjectDto> get copyWith =>
      _$ProjectDtoCopyWithImpl<ProjectDto>(this as ProjectDto, _$identity);

  /// Serializes this ProjectDto to a JSON map.
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

/// @nodoc
abstract mixin class $ProjectDtoCopyWith<$Res> {
  factory $ProjectDtoCopyWith(
          ProjectDto value, $Res Function(ProjectDto) _then) =
      _$ProjectDtoCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String? id,
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

/// @nodoc
class _$ProjectDtoCopyWithImpl<$Res> implements $ProjectDtoCopyWith<$Res> {
  _$ProjectDtoCopyWithImpl(this._self, this._then);

  final ProjectDto _self;
  final $Res Function(ProjectDto) _then;

  /// Create a copy of ProjectDto
  /// with the given fields replaced by the non-null parameter values.
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
              as String?,
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

/// Adds pattern-matching-related methods to [ProjectDto].
extension ProjectDtoPatterns on ProjectDto {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

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

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

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

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

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

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'id') String? id,
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

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'id') String? id,
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

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            @JsonKey(name: 'id') String? id,
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

/// @nodoc
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
  final String? id;
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

  /// Create a copy of ProjectDto
  /// with the given fields replaced by the non-null parameter values.
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

/// @nodoc
abstract mixin class _$ProjectDtoCopyWith<$Res>
    implements $ProjectDtoCopyWith<$Res> {
  factory _$ProjectDtoCopyWith(
          _ProjectDto value, $Res Function(_ProjectDto) _then) =
      __$ProjectDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String? id,
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

/// @nodoc
class __$ProjectDtoCopyWithImpl<$Res> implements _$ProjectDtoCopyWith<$Res> {
  __$ProjectDtoCopyWithImpl(this._self, this._then);

  final _ProjectDto _self;
  final $Res Function(_ProjectDto) _then;

  /// Create a copy of ProjectDto
  /// with the given fields replaced by the non-null parameter values.
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
              as String?,
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
