// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MediaDto {
  @JsonKey(name: 'id')
  int? get id;
  @JsonKey(name: 'mediaPath')
  String? get mediaPath;
  @JsonKey(name: 'mediaUrl')
  String? get mediaUrl;
  @JsonKey(name: 'createdDate', fromJson: _dateFromJson, toJson: _dateToJson)
  DateTime? get createdDate;

  /// Create a copy of MediaDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MediaDtoCopyWith<MediaDto> get copyWith =>
      _$MediaDtoCopyWithImpl<MediaDto>(this as MediaDto, _$identity);

  /// Serializes this MediaDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MediaDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.mediaPath, mediaPath) ||
                other.mediaPath == mediaPath) &&
            (identical(other.mediaUrl, mediaUrl) ||
                other.mediaUrl == mediaUrl) &&
            (identical(other.createdDate, createdDate) ||
                other.createdDate == createdDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, mediaPath, mediaUrl, createdDate);

  @override
  String toString() {
    return 'MediaDto(id: $id, mediaPath: $mediaPath, mediaUrl: $mediaUrl, createdDate: $createdDate)';
  }
}

/// @nodoc
abstract mixin class $MediaDtoCopyWith<$Res> {
  factory $MediaDtoCopyWith(MediaDto value, $Res Function(MediaDto) _then) =
      _$MediaDtoCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int? id,
      @JsonKey(name: 'mediaPath') String? mediaPath,
      @JsonKey(name: 'mediaUrl') String? mediaUrl,
      @JsonKey(
          name: 'createdDate', fromJson: _dateFromJson, toJson: _dateToJson)
      DateTime? createdDate});
}

/// @nodoc
class _$MediaDtoCopyWithImpl<$Res> implements $MediaDtoCopyWith<$Res> {
  _$MediaDtoCopyWithImpl(this._self, this._then);

  final MediaDto _self;
  final $Res Function(MediaDto) _then;

  /// Create a copy of MediaDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? mediaPath = freezed,
    Object? mediaUrl = freezed,
    Object? createdDate = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      mediaPath: freezed == mediaPath
          ? _self.mediaPath
          : mediaPath // ignore: cast_nullable_to_non_nullable
              as String?,
      mediaUrl: freezed == mediaUrl
          ? _self.mediaUrl
          : mediaUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdDate: freezed == createdDate
          ? _self.createdDate
          : createdDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// Adds pattern-matching-related methods to [MediaDto].
extension MediaDtoPatterns on MediaDto {
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
    TResult Function(_MediaDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MediaDto() when $default != null:
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
    TResult Function(_MediaDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MediaDto():
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
    TResult? Function(_MediaDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MediaDto() when $default != null:
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
            @JsonKey(name: 'mediaPath') String? mediaPath,
            @JsonKey(name: 'mediaUrl') String? mediaUrl,
            @JsonKey(
                name: 'createdDate',
                fromJson: _dateFromJson,
                toJson: _dateToJson)
            DateTime? createdDate)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MediaDto() when $default != null:
        return $default(
            _that.id, _that.mediaPath, _that.mediaUrl, _that.createdDate);
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
            @JsonKey(name: 'mediaPath') String? mediaPath,
            @JsonKey(name: 'mediaUrl') String? mediaUrl,
            @JsonKey(
                name: 'createdDate',
                fromJson: _dateFromJson,
                toJson: _dateToJson)
            DateTime? createdDate)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MediaDto():
        return $default(
            _that.id, _that.mediaPath, _that.mediaUrl, _that.createdDate);
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
            @JsonKey(name: 'mediaPath') String? mediaPath,
            @JsonKey(name: 'mediaUrl') String? mediaUrl,
            @JsonKey(
                name: 'createdDate',
                fromJson: _dateFromJson,
                toJson: _dateToJson)
            DateTime? createdDate)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MediaDto() when $default != null:
        return $default(
            _that.id, _that.mediaPath, _that.mediaUrl, _that.createdDate);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MediaDto implements MediaDto {
  _MediaDto(
      {@JsonKey(name: 'id') this.id,
      @JsonKey(name: 'mediaPath') this.mediaPath,
      @JsonKey(name: 'mediaUrl') this.mediaUrl,
      @JsonKey(
          name: 'createdDate', fromJson: _dateFromJson, toJson: _dateToJson)
      this.createdDate});
  factory _MediaDto.fromJson(Map<String, dynamic> json) =>
      _$MediaDtoFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int? id;
  @override
  @JsonKey(name: 'mediaPath')
  final String? mediaPath;
  @override
  @JsonKey(name: 'mediaUrl')
  final String? mediaUrl;
  @override
  @JsonKey(name: 'createdDate', fromJson: _dateFromJson, toJson: _dateToJson)
  final DateTime? createdDate;

  /// Create a copy of MediaDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MediaDtoCopyWith<_MediaDto> get copyWith =>
      __$MediaDtoCopyWithImpl<_MediaDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MediaDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MediaDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.mediaPath, mediaPath) ||
                other.mediaPath == mediaPath) &&
            (identical(other.mediaUrl, mediaUrl) ||
                other.mediaUrl == mediaUrl) &&
            (identical(other.createdDate, createdDate) ||
                other.createdDate == createdDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, mediaPath, mediaUrl, createdDate);

  @override
  String toString() {
    return 'MediaDto(id: $id, mediaPath: $mediaPath, mediaUrl: $mediaUrl, createdDate: $createdDate)';
  }
}

/// @nodoc
abstract mixin class _$MediaDtoCopyWith<$Res>
    implements $MediaDtoCopyWith<$Res> {
  factory _$MediaDtoCopyWith(_MediaDto value, $Res Function(_MediaDto) _then) =
      __$MediaDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') int? id,
      @JsonKey(name: 'mediaPath') String? mediaPath,
      @JsonKey(name: 'mediaUrl') String? mediaUrl,
      @JsonKey(
          name: 'createdDate', fromJson: _dateFromJson, toJson: _dateToJson)
      DateTime? createdDate});
}

/// @nodoc
class __$MediaDtoCopyWithImpl<$Res> implements _$MediaDtoCopyWith<$Res> {
  __$MediaDtoCopyWithImpl(this._self, this._then);

  final _MediaDto _self;
  final $Res Function(_MediaDto) _then;

  /// Create a copy of MediaDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? mediaPath = freezed,
    Object? mediaUrl = freezed,
    Object? createdDate = freezed,
  }) {
    return _then(_MediaDto(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      mediaPath: freezed == mediaPath
          ? _self.mediaPath
          : mediaPath // ignore: cast_nullable_to_non_nullable
              as String?,
      mediaUrl: freezed == mediaUrl
          ? _self.mediaUrl
          : mediaUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      createdDate: freezed == createdDate
          ? _self.createdDate
          : createdDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
