// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ImageResponseDto {
  @JsonKey(name: 'imageUrls')
  List<String>? get imageUrls;
  @JsonKey(name: 'updatedInstruction')
  String? get updatedInstruction;

  /// Create a copy of ImageResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ImageResponseDtoCopyWith<ImageResponseDto> get copyWith =>
      _$ImageResponseDtoCopyWithImpl<ImageResponseDto>(
          this as ImageResponseDto, _$identity);

  /// Serializes this ImageResponseDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ImageResponseDto &&
            const DeepCollectionEquality().equals(other.imageUrls, imageUrls) &&
            (identical(other.updatedInstruction, updatedInstruction) ||
                other.updatedInstruction == updatedInstruction));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(imageUrls), updatedInstruction);

  @override
  String toString() {
    return 'ImageResponseDto(imageUrls: $imageUrls, updatedInstruction: $updatedInstruction)';
  }
}

/// @nodoc
abstract mixin class $ImageResponseDtoCopyWith<$Res> {
  factory $ImageResponseDtoCopyWith(
          ImageResponseDto value, $Res Function(ImageResponseDto) _then) =
      _$ImageResponseDtoCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'imageUrls') List<String>? imageUrls,
      @JsonKey(name: 'updatedInstruction') String? updatedInstruction});
}

/// @nodoc
class _$ImageResponseDtoCopyWithImpl<$Res>
    implements $ImageResponseDtoCopyWith<$Res> {
  _$ImageResponseDtoCopyWithImpl(this._self, this._then);

  final ImageResponseDto _self;
  final $Res Function(ImageResponseDto) _then;

  /// Create a copy of ImageResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imageUrls = freezed,
    Object? updatedInstruction = freezed,
  }) {
    return _then(_self.copyWith(
      imageUrls: freezed == imageUrls
          ? _self.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      updatedInstruction: freezed == updatedInstruction
          ? _self.updatedInstruction
          : updatedInstruction // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ImageResponseDto].
extension ImageResponseDtoPatterns on ImageResponseDto {
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
    TResult Function(_ImageResponseDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ImageResponseDto() when $default != null:
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
    TResult Function(_ImageResponseDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ImageResponseDto():
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
    TResult? Function(_ImageResponseDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ImageResponseDto() when $default != null:
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
    TResult Function(@JsonKey(name: 'imageUrls') List<String>? imageUrls,
            @JsonKey(name: 'updatedInstruction') String? updatedInstruction)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ImageResponseDto() when $default != null:
        return $default(_that.imageUrls, _that.updatedInstruction);
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
    TResult Function(@JsonKey(name: 'imageUrls') List<String>? imageUrls,
            @JsonKey(name: 'updatedInstruction') String? updatedInstruction)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ImageResponseDto():
        return $default(_that.imageUrls, _that.updatedInstruction);
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
    TResult? Function(@JsonKey(name: 'imageUrls') List<String>? imageUrls,
            @JsonKey(name: 'updatedInstruction') String? updatedInstruction)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ImageResponseDto() when $default != null:
        return $default(_that.imageUrls, _that.updatedInstruction);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ImageResponseDto implements ImageResponseDto {
  _ImageResponseDto(
      {@JsonKey(name: 'imageUrls') final List<String>? imageUrls,
      @JsonKey(name: 'updatedInstruction') this.updatedInstruction})
      : _imageUrls = imageUrls;
  factory _ImageResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ImageResponseDtoFromJson(json);

  final List<String>? _imageUrls;
  @override
  @JsonKey(name: 'imageUrls')
  List<String>? get imageUrls {
    final value = _imageUrls;
    if (value == null) return null;
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'updatedInstruction')
  final String? updatedInstruction;

  /// Create a copy of ImageResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ImageResponseDtoCopyWith<_ImageResponseDto> get copyWith =>
      __$ImageResponseDtoCopyWithImpl<_ImageResponseDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ImageResponseDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ImageResponseDto &&
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls) &&
            (identical(other.updatedInstruction, updatedInstruction) ||
                other.updatedInstruction == updatedInstruction));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_imageUrls), updatedInstruction);

  @override
  String toString() {
    return 'ImageResponseDto(imageUrls: $imageUrls, updatedInstruction: $updatedInstruction)';
  }
}

/// @nodoc
abstract mixin class _$ImageResponseDtoCopyWith<$Res>
    implements $ImageResponseDtoCopyWith<$Res> {
  factory _$ImageResponseDtoCopyWith(
          _ImageResponseDto value, $Res Function(_ImageResponseDto) _then) =
      __$ImageResponseDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'imageUrls') List<String>? imageUrls,
      @JsonKey(name: 'updatedInstruction') String? updatedInstruction});
}

/// @nodoc
class __$ImageResponseDtoCopyWithImpl<$Res>
    implements _$ImageResponseDtoCopyWith<$Res> {
  __$ImageResponseDtoCopyWithImpl(this._self, this._then);

  final _ImageResponseDto _self;
  final $Res Function(_ImageResponseDto) _then;

  /// Create a copy of ImageResponseDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? imageUrls = freezed,
    Object? updatedInstruction = freezed,
  }) {
    return _then(_ImageResponseDto(
      imageUrls: freezed == imageUrls
          ? _self._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      updatedInstruction: freezed == updatedInstruction
          ? _self.updatedInstruction
          : updatedInstruction // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

// dart format on
