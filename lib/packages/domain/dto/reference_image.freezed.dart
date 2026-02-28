// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reference_image.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReferenceImage {
  @JsonKey(name: 'imagePath')
  String? get imagePath;
  @JsonKey(name: 'mimeType')
  MimeType? get mimeType;

  /// Create a copy of ReferenceImage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReferenceImageCopyWith<ReferenceImage> get copyWith =>
      _$ReferenceImageCopyWithImpl<ReferenceImage>(
          this as ReferenceImage, _$identity);

  /// Serializes this ReferenceImage to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReferenceImage &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, imagePath, mimeType);

  @override
  String toString() {
    return 'ReferenceImage(imagePath: $imagePath, mimeType: $mimeType)';
  }
}

/// @nodoc
abstract mixin class $ReferenceImageCopyWith<$Res> {
  factory $ReferenceImageCopyWith(
          ReferenceImage value, $Res Function(ReferenceImage) _then) =
      _$ReferenceImageCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'imagePath') String? imagePath,
      @JsonKey(name: 'mimeType') MimeType? mimeType});
}

/// @nodoc
class _$ReferenceImageCopyWithImpl<$Res>
    implements $ReferenceImageCopyWith<$Res> {
  _$ReferenceImageCopyWithImpl(this._self, this._then);

  final ReferenceImage _self;
  final $Res Function(ReferenceImage) _then;

  /// Create a copy of ReferenceImage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imagePath = freezed,
    Object? mimeType = freezed,
  }) {
    return _then(_self.copyWith(
      imagePath: freezed == imagePath
          ? _self.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      mimeType: freezed == mimeType
          ? _self.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as MimeType?,
    ));
  }
}

/// Adds pattern-matching-related methods to [ReferenceImage].
extension ReferenceImagePatterns on ReferenceImage {
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
    TResult Function(_ReferenceImage value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReferenceImage() when $default != null:
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
    TResult Function(_ReferenceImage value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReferenceImage():
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
    TResult? Function(_ReferenceImage value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReferenceImage() when $default != null:
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
    TResult Function(@JsonKey(name: 'imagePath') String? imagePath,
            @JsonKey(name: 'mimeType') MimeType? mimeType)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ReferenceImage() when $default != null:
        return $default(_that.imagePath, _that.mimeType);
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
    TResult Function(@JsonKey(name: 'imagePath') String? imagePath,
            @JsonKey(name: 'mimeType') MimeType? mimeType)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReferenceImage():
        return $default(_that.imagePath, _that.mimeType);
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
    TResult? Function(@JsonKey(name: 'imagePath') String? imagePath,
            @JsonKey(name: 'mimeType') MimeType? mimeType)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ReferenceImage() when $default != null:
        return $default(_that.imagePath, _that.mimeType);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ReferenceImage implements ReferenceImage {
  _ReferenceImage(
      {@JsonKey(name: 'imagePath') this.imagePath,
      @JsonKey(name: 'mimeType') this.mimeType});
  factory _ReferenceImage.fromJson(Map<String, dynamic> json) =>
      _$ReferenceImageFromJson(json);

  @override
  @JsonKey(name: 'imagePath')
  final String? imagePath;
  @override
  @JsonKey(name: 'mimeType')
  final MimeType? mimeType;

  /// Create a copy of ReferenceImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ReferenceImageCopyWith<_ReferenceImage> get copyWith =>
      __$ReferenceImageCopyWithImpl<_ReferenceImage>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ReferenceImageToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ReferenceImage &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, imagePath, mimeType);

  @override
  String toString() {
    return 'ReferenceImage(imagePath: $imagePath, mimeType: $mimeType)';
  }
}

/// @nodoc
abstract mixin class _$ReferenceImageCopyWith<$Res>
    implements $ReferenceImageCopyWith<$Res> {
  factory _$ReferenceImageCopyWith(
          _ReferenceImage value, $Res Function(_ReferenceImage) _then) =
      __$ReferenceImageCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'imagePath') String? imagePath,
      @JsonKey(name: 'mimeType') MimeType? mimeType});
}

/// @nodoc
class __$ReferenceImageCopyWithImpl<$Res>
    implements _$ReferenceImageCopyWith<$Res> {
  __$ReferenceImageCopyWithImpl(this._self, this._then);

  final _ReferenceImage _self;
  final $Res Function(_ReferenceImage) _then;

  /// Create a copy of ReferenceImage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? imagePath = freezed,
    Object? mimeType = freezed,
  }) {
    return _then(_ReferenceImage(
      imagePath: freezed == imagePath
          ? _self.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      mimeType: freezed == mimeType
          ? _self.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as MimeType?,
    ));
  }
}

// dart format on
