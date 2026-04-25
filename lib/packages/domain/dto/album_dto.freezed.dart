// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'album_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AlbumDto {
  @JsonKey(name: 'id')
  int? get id;
  @JsonKey(name: 'name')
  String? get name;
  @JsonKey(name: 'mediaList')
  List<MediaDto>? get mediaList;
  @JsonKey(name: 'createdDate', fromJson: _dateFromJson, toJson: _dateToJson)
  DateTime? get createdDate;
  @JsonKey(name: 'modifiedDate', fromJson: _dateFromJson, toJson: _dateToJson)
  DateTime? get modifiedDate;

  /// Create a copy of AlbumDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AlbumDtoCopyWith<AlbumDto> get copyWith =>
      _$AlbumDtoCopyWithImpl<AlbumDto>(this as AlbumDto, _$identity);

  /// Serializes this AlbumDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AlbumDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other.mediaList, mediaList) &&
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
      name,
      const DeepCollectionEquality().hash(mediaList),
      createdDate,
      modifiedDate);

  @override
  String toString() {
    return 'AlbumDto(id: $id, name: $name, mediaList: $mediaList, createdDate: $createdDate, modifiedDate: $modifiedDate)';
  }
}

/// @nodoc
abstract mixin class $AlbumDtoCopyWith<$Res> {
  factory $AlbumDtoCopyWith(AlbumDto value, $Res Function(AlbumDto) _then) =
      _$AlbumDtoCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int? id,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'mediaList') List<MediaDto>? mediaList,
      @JsonKey(
          name: 'createdDate', fromJson: _dateFromJson, toJson: _dateToJson)
      DateTime? createdDate,
      @JsonKey(
          name: 'modifiedDate', fromJson: _dateFromJson, toJson: _dateToJson)
      DateTime? modifiedDate});
}

/// @nodoc
class _$AlbumDtoCopyWithImpl<$Res> implements $AlbumDtoCopyWith<$Res> {
  _$AlbumDtoCopyWithImpl(this._self, this._then);

  final AlbumDto _self;
  final $Res Function(AlbumDto) _then;

  /// Create a copy of AlbumDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? mediaList = freezed,
    Object? createdDate = freezed,
    Object? modifiedDate = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      mediaList: freezed == mediaList
          ? _self.mediaList
          : mediaList // ignore: cast_nullable_to_non_nullable
              as List<MediaDto>?,
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

/// Adds pattern-matching-related methods to [AlbumDto].
extension AlbumDtoPatterns on AlbumDto {
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
    TResult Function(_AlbumDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AlbumDto() when $default != null:
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
    TResult Function(_AlbumDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AlbumDto():
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
    TResult? Function(_AlbumDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AlbumDto() when $default != null:
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
            @JsonKey(name: 'id') int? id,
            @JsonKey(name: 'name') String? name,
            @JsonKey(name: 'mediaList') List<MediaDto>? mediaList,
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
      case _AlbumDto() when $default != null:
        return $default(_that.id, _that.name, _that.mediaList,
            _that.createdDate, _that.modifiedDate);
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
            @JsonKey(name: 'id') int? id,
            @JsonKey(name: 'name') String? name,
            @JsonKey(name: 'mediaList') List<MediaDto>? mediaList,
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
      case _AlbumDto():
        return $default(_that.id, _that.name, _that.mediaList,
            _that.createdDate, _that.modifiedDate);
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
            @JsonKey(name: 'id') int? id,
            @JsonKey(name: 'name') String? name,
            @JsonKey(name: 'mediaList') List<MediaDto>? mediaList,
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
      case _AlbumDto() when $default != null:
        return $default(_that.id, _that.name, _that.mediaList,
            _that.createdDate, _that.modifiedDate);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AlbumDto implements AlbumDto {
  _AlbumDto(
      {@JsonKey(name: 'id') this.id,
      @JsonKey(name: 'name') this.name,
      @JsonKey(name: 'mediaList') final List<MediaDto>? mediaList,
      @JsonKey(
          name: 'createdDate', fromJson: _dateFromJson, toJson: _dateToJson)
      this.createdDate,
      @JsonKey(
          name: 'modifiedDate', fromJson: _dateFromJson, toJson: _dateToJson)
      this.modifiedDate})
      : _mediaList = mediaList;
  factory _AlbumDto.fromJson(Map<String, dynamic> json) =>
      _$AlbumDtoFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int? id;
  @override
  @JsonKey(name: 'name')
  final String? name;
  final List<MediaDto>? _mediaList;
  @override
  @JsonKey(name: 'mediaList')
  List<MediaDto>? get mediaList {
    final value = _mediaList;
    if (value == null) return null;
    if (_mediaList is EqualUnmodifiableListView) return _mediaList;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'createdDate', fromJson: _dateFromJson, toJson: _dateToJson)
  final DateTime? createdDate;
  @override
  @JsonKey(name: 'modifiedDate', fromJson: _dateFromJson, toJson: _dateToJson)
  final DateTime? modifiedDate;

  /// Create a copy of AlbumDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AlbumDtoCopyWith<_AlbumDto> get copyWith =>
      __$AlbumDtoCopyWithImpl<_AlbumDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AlbumDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AlbumDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality()
                .equals(other._mediaList, _mediaList) &&
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
      name,
      const DeepCollectionEquality().hash(_mediaList),
      createdDate,
      modifiedDate);

  @override
  String toString() {
    return 'AlbumDto(id: $id, name: $name, mediaList: $mediaList, createdDate: $createdDate, modifiedDate: $modifiedDate)';
  }
}

/// @nodoc
abstract mixin class _$AlbumDtoCopyWith<$Res>
    implements $AlbumDtoCopyWith<$Res> {
  factory _$AlbumDtoCopyWith(_AlbumDto value, $Res Function(_AlbumDto) _then) =
      __$AlbumDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int? id,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'mediaList') List<MediaDto>? mediaList,
      @JsonKey(
          name: 'createdDate', fromJson: _dateFromJson, toJson: _dateToJson)
      DateTime? createdDate,
      @JsonKey(
          name: 'modifiedDate', fromJson: _dateFromJson, toJson: _dateToJson)
      DateTime? modifiedDate});
}

/// @nodoc
class __$AlbumDtoCopyWithImpl<$Res> implements _$AlbumDtoCopyWith<$Res> {
  __$AlbumDtoCopyWithImpl(this._self, this._then);

  final _AlbumDto _self;
  final $Res Function(_AlbumDto) _then;

  /// Create a copy of AlbumDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? mediaList = freezed,
    Object? createdDate = freezed,
    Object? modifiedDate = freezed,
  }) {
    return _then(_AlbumDto(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      mediaList: freezed == mediaList
          ? _self._mediaList
          : mediaList // ignore: cast_nullable_to_non_nullable
              as List<MediaDto>?,
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
