// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reference_image.dart';

// **************************************************************************
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

mixin _$ReferenceImage {
  @JsonKey(name: 'imagePath')
  String? get imagePath;
  @JsonKey(name: 'mimeType')
  MimeType? get mimeType;

  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReferenceImageCopyWith<ReferenceImage> get copyWith =>
      _$ReferenceImageCopyWithImpl<ReferenceImage>(
          this as ReferenceImage, _$identity);

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

abstract mixin class $ReferenceImageCopyWith<$Res> {
  factory $ReferenceImageCopyWith(
          ReferenceImage value, $Res Function(ReferenceImage) _then) =
      _$ReferenceImageCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'imagePath') String? imagePath,
      @JsonKey(name: 'mimeType') MimeType? mimeType});
}

class _$ReferenceImageCopyWithImpl<$Res>
    implements $ReferenceImageCopyWith<$Res> {
  _$ReferenceImageCopyWithImpl(this._self, this._then);

  final ReferenceImage _self;
  final $Res Function(ReferenceImage) _then;

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

extension ReferenceImagePatterns on ReferenceImage {

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

class __$ReferenceImageCopyWithImpl<$Res>
    implements _$ReferenceImageCopyWith<$Res> {
  __$ReferenceImageCopyWithImpl(this._self, this._then);

  final _ReferenceImage _self;
  final $Res Function(_ReferenceImage) _then;

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
