// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'album_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AlbumDetailState {
  AlbumDto? get album;
  bool get loading;
  String?
      get error; // Tracks media IDs currently being deleted/removed so the UI can show
// per-item loading indicators.
  Set<String> get pendingMediaIds;

  /// Create a copy of AlbumDetailState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AlbumDetailStateCopyWith<AlbumDetailState> get copyWith =>
      _$AlbumDetailStateCopyWithImpl<AlbumDetailState>(
          this as AlbumDetailState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AlbumDetailState &&
            (identical(other.album, album) || other.album == album) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.error, error) || other.error == error) &&
            const DeepCollectionEquality()
                .equals(other.pendingMediaIds, pendingMediaIds));
  }

  @override
  int get hashCode => Object.hash(runtimeType, album, loading, error,
      const DeepCollectionEquality().hash(pendingMediaIds));

  @override
  String toString() {
    return 'AlbumDetailState(album: $album, loading: $loading, error: $error, pendingMediaIds: $pendingMediaIds)';
  }
}

/// @nodoc
abstract mixin class $AlbumDetailStateCopyWith<$Res> {
  factory $AlbumDetailStateCopyWith(
          AlbumDetailState value, $Res Function(AlbumDetailState) _then) =
      _$AlbumDetailStateCopyWithImpl;
  @useResult
  $Res call(
      {AlbumDto? album,
      bool loading,
      String? error,
      Set<String> pendingMediaIds});

  $AlbumDtoCopyWith<$Res>? get album;
}

/// @nodoc
class _$AlbumDetailStateCopyWithImpl<$Res>
    implements $AlbumDetailStateCopyWith<$Res> {
  _$AlbumDetailStateCopyWithImpl(this._self, this._then);

  final AlbumDetailState _self;
  final $Res Function(AlbumDetailState) _then;

  /// Create a copy of AlbumDetailState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? album = freezed,
    Object? loading = null,
    Object? error = freezed,
    Object? pendingMediaIds = null,
  }) {
    return _then(_self.copyWith(
      album: freezed == album
          ? _self.album
          : album // ignore: cast_nullable_to_non_nullable
              as AlbumDto?,
      loading: null == loading
          ? _self.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      pendingMediaIds: null == pendingMediaIds
          ? _self.pendingMediaIds
          : pendingMediaIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
    ));
  }

  /// Create a copy of AlbumDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AlbumDtoCopyWith<$Res>? get album {
    if (_self.album == null) {
      return null;
    }

    return $AlbumDtoCopyWith<$Res>(_self.album!, (value) {
      return _then(_self.copyWith(album: value));
    });
  }
}

/// Adds pattern-matching-related methods to [AlbumDetailState].
extension AlbumDetailStatePatterns on AlbumDetailState {
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
    TResult Function(_AlbumDetailState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AlbumDetailState() when $default != null:
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
    TResult Function(_AlbumDetailState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AlbumDetailState():
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
    TResult? Function(_AlbumDetailState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AlbumDetailState() when $default != null:
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
    TResult Function(AlbumDto? album, bool loading, String? error,
            Set<String> pendingMediaIds)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AlbumDetailState() when $default != null:
        return $default(
            _that.album, _that.loading, _that.error, _that.pendingMediaIds);
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
    TResult Function(AlbumDto? album, bool loading, String? error,
            Set<String> pendingMediaIds)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AlbumDetailState():
        return $default(
            _that.album, _that.loading, _that.error, _that.pendingMediaIds);
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
    TResult? Function(AlbumDto? album, bool loading, String? error,
            Set<String> pendingMediaIds)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AlbumDetailState() when $default != null:
        return $default(
            _that.album, _that.loading, _that.error, _that.pendingMediaIds);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _AlbumDetailState implements AlbumDetailState {
  const _AlbumDetailState(
      {this.album,
      this.loading = false,
      this.error,
      final Set<String> pendingMediaIds = const {}})
      : _pendingMediaIds = pendingMediaIds;

  @override
  final AlbumDto? album;
  @override
  @JsonKey()
  final bool loading;
  @override
  final String? error;
// Tracks media IDs currently being deleted/removed so the UI can show
// per-item loading indicators.
  final Set<String> _pendingMediaIds;
// Tracks media IDs currently being deleted/removed so the UI can show
// per-item loading indicators.
  @override
  @JsonKey()
  Set<String> get pendingMediaIds {
    if (_pendingMediaIds is EqualUnmodifiableSetView) return _pendingMediaIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_pendingMediaIds);
  }

  /// Create a copy of AlbumDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AlbumDetailStateCopyWith<_AlbumDetailState> get copyWith =>
      __$AlbumDetailStateCopyWithImpl<_AlbumDetailState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AlbumDetailState &&
            (identical(other.album, album) || other.album == album) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.error, error) || other.error == error) &&
            const DeepCollectionEquality()
                .equals(other._pendingMediaIds, _pendingMediaIds));
  }

  @override
  int get hashCode => Object.hash(runtimeType, album, loading, error,
      const DeepCollectionEquality().hash(_pendingMediaIds));

  @override
  String toString() {
    return 'AlbumDetailState(album: $album, loading: $loading, error: $error, pendingMediaIds: $pendingMediaIds)';
  }
}

/// @nodoc
abstract mixin class _$AlbumDetailStateCopyWith<$Res>
    implements $AlbumDetailStateCopyWith<$Res> {
  factory _$AlbumDetailStateCopyWith(
          _AlbumDetailState value, $Res Function(_AlbumDetailState) _then) =
      __$AlbumDetailStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {AlbumDto? album,
      bool loading,
      String? error,
      Set<String> pendingMediaIds});

  @override
  $AlbumDtoCopyWith<$Res>? get album;
}

/// @nodoc
class __$AlbumDetailStateCopyWithImpl<$Res>
    implements _$AlbumDetailStateCopyWith<$Res> {
  __$AlbumDetailStateCopyWithImpl(this._self, this._then);

  final _AlbumDetailState _self;
  final $Res Function(_AlbumDetailState) _then;

  /// Create a copy of AlbumDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? album = freezed,
    Object? loading = null,
    Object? error = freezed,
    Object? pendingMediaIds = null,
  }) {
    return _then(_AlbumDetailState(
      album: freezed == album
          ? _self.album
          : album // ignore: cast_nullable_to_non_nullable
              as AlbumDto?,
      loading: null == loading
          ? _self.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _self.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      pendingMediaIds: null == pendingMediaIds
          ? _self._pendingMediaIds
          : pendingMediaIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
    ));
  }

  /// Create a copy of AlbumDetailState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AlbumDtoCopyWith<$Res>? get album {
    if (_self.album == null) {
      return null;
    }

    return $AlbumDtoCopyWith<$Res>(_self.album!, (value) {
      return _then(_self.copyWith(album: value));
    });
  }
}

// dart format on
