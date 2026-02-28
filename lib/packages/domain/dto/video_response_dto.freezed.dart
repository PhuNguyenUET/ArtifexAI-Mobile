// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VideoResponseDto {
  @JsonKey(name: 'videoUrl')
  String? get videoUrl;
  @JsonKey(name: 'updatedInstruction')
  String? get updatedInstruction;

  /// Create a copy of VideoResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $VideoResponseDtoCopyWith<VideoResponseDto> get copyWith =>
      _$VideoResponseDtoCopyWithImpl<VideoResponseDto>(
          this as VideoResponseDto, _$identity);

  /// Serializes this VideoResponseDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is VideoResponseDto &&
            (identical(other.videoUrl, videoUrl) ||
                other.videoUrl == videoUrl) &&
            (identical(other.updatedInstruction, updatedInstruction) ||
                other.updatedInstruction == updatedInstruction));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, videoUrl, updatedInstruction);

  @override
  String toString() {
    return 'VideoResponseDto(videoUrl: $videoUrl, updatedInstruction: $updatedInstruction)';
  }
}

/// @nodoc
abstract mixin class $VideoResponseDtoCopyWith<$Res> {
  factory $VideoResponseDtoCopyWith(
          VideoResponseDto value, $Res Function(VideoResponseDto) _then) =
      _$VideoResponseDtoCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'videoUrl') String? videoUrl,
      @JsonKey(name: 'updatedInstruction') String? updatedInstruction});
}

/// @nodoc
class _$VideoResponseDtoCopyWithImpl<$Res>
    implements $VideoResponseDtoCopyWith<$Res> {
  _$VideoResponseDtoCopyWithImpl(this._self, this._then);

  final VideoResponseDto _self;
  final $Res Function(VideoResponseDto) _then;

  /// Create a copy of VideoResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? videoUrl = freezed,
    Object? updatedInstruction = freezed,
  }) {
    return _then(_self.copyWith(
      videoUrl: freezed == videoUrl
          ? _self.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedInstruction: freezed == updatedInstruction
          ? _self.updatedInstruction
          : updatedInstruction // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [VideoResponseDto].
extension VideoResponseDtoPatterns on VideoResponseDto {
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
    TResult Function(_VideoResponseDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VideoResponseDto() when $default != null:
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
    TResult Function(_VideoResponseDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VideoResponseDto():
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
    TResult? Function(_VideoResponseDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VideoResponseDto() when $default != null:
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
    TResult Function(@JsonKey(name: 'videoUrl') String? videoUrl,
            @JsonKey(name: 'updatedInstruction') String? updatedInstruction)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _VideoResponseDto() when $default != null:
        return $default(_that.videoUrl, _that.updatedInstruction);
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
    TResult Function(@JsonKey(name: 'videoUrl') String? videoUrl,
            @JsonKey(name: 'updatedInstruction') String? updatedInstruction)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VideoResponseDto():
        return $default(_that.videoUrl, _that.updatedInstruction);
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
    TResult? Function(@JsonKey(name: 'videoUrl') String? videoUrl,
            @JsonKey(name: 'updatedInstruction') String? updatedInstruction)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _VideoResponseDto() when $default != null:
        return $default(_that.videoUrl, _that.updatedInstruction);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _VideoResponseDto implements VideoResponseDto {
  _VideoResponseDto(
      {@JsonKey(name: 'videoUrl') this.videoUrl,
      @JsonKey(name: 'updatedInstruction') this.updatedInstruction});
  factory _VideoResponseDto.fromJson(Map<String, dynamic> json) =>
      _$VideoResponseDtoFromJson(json);

  @override
  @JsonKey(name: 'videoUrl')
  final String? videoUrl;
  @override
  @JsonKey(name: 'updatedInstruction')
  final String? updatedInstruction;

  /// Create a copy of VideoResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$VideoResponseDtoCopyWith<_VideoResponseDto> get copyWith =>
      __$VideoResponseDtoCopyWithImpl<_VideoResponseDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$VideoResponseDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _VideoResponseDto &&
            (identical(other.videoUrl, videoUrl) ||
                other.videoUrl == videoUrl) &&
            (identical(other.updatedInstruction, updatedInstruction) ||
                other.updatedInstruction == updatedInstruction));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, videoUrl, updatedInstruction);

  @override
  String toString() {
    return 'VideoResponseDto(videoUrl: $videoUrl, updatedInstruction: $updatedInstruction)';
  }
}

/// @nodoc
abstract mixin class _$VideoResponseDtoCopyWith<$Res>
    implements $VideoResponseDtoCopyWith<$Res> {
  factory _$VideoResponseDtoCopyWith(
          _VideoResponseDto value, $Res Function(_VideoResponseDto) _then) =
      __$VideoResponseDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'videoUrl') String? videoUrl,
      @JsonKey(name: 'updatedInstruction') String? updatedInstruction});
}

/// @nodoc
class __$VideoResponseDtoCopyWithImpl<$Res>
    implements _$VideoResponseDtoCopyWith<$Res> {
  __$VideoResponseDtoCopyWithImpl(this._self, this._then);

  final _VideoResponseDto _self;
  final $Res Function(_VideoResponseDto) _then;

  /// Create a copy of VideoResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? videoUrl = freezed,
    Object? updatedInstruction = freezed,
  }) {
    return _then(_VideoResponseDto(
      videoUrl: freezed == videoUrl
          ? _self.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedInstruction: freezed == updatedInstruction
          ? _self.updatedInstruction
          : updatedInstruction // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
