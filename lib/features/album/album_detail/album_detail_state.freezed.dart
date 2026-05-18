// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'album_detail_state.dart';

// **************************************************************************
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

mixin _$AlbumDetailState {
  AlbumDto? get album;
  bool get loading;
  String?
      get error; // Tracks media IDs currently being deleted/removed so the UI can show
  Set<int> get pendingMediaIds;

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

abstract mixin class $AlbumDetailStateCopyWith<$Res> {
  factory $AlbumDetailStateCopyWith(
          AlbumDetailState value, $Res Function(AlbumDetailState) _then) =
      _$AlbumDetailStateCopyWithImpl;
  @useResult
  $Res call(
      {AlbumDto? album, bool loading, String? error, Set<int> pendingMediaIds});

  $AlbumDtoCopyWith<$Res>? get album;
}

class _$AlbumDetailStateCopyWithImpl<$Res>
    implements $AlbumDetailStateCopyWith<$Res> {
  _$AlbumDetailStateCopyWithImpl(this._self, this._then);

  final AlbumDetailState _self;
  final $Res Function(AlbumDetailState) _then;

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
              as Set<int>,
    ));
  }

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

extension AlbumDetailStatePatterns on AlbumDetailState {

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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(AlbumDto? album, bool loading, String? error,
            Set<int> pendingMediaIds)?
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(AlbumDto? album, bool loading, String? error,
            Set<int> pendingMediaIds)
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(AlbumDto? album, bool loading, String? error,
            Set<int> pendingMediaIds)?
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

class _AlbumDetailState implements AlbumDetailState {
  const _AlbumDetailState(
      {this.album,
      this.loading = false,
      this.error,
      final Set<int> pendingMediaIds = const {}})
      : _pendingMediaIds = pendingMediaIds;

  @override
  final AlbumDto? album;
  @override
  @JsonKey()
  final bool loading;
  @override
  final String? error;
  final Set<int> _pendingMediaIds;
  @override
  @JsonKey()
  Set<int> get pendingMediaIds {
    if (_pendingMediaIds is EqualUnmodifiableSetView) return _pendingMediaIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_pendingMediaIds);
  }

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

abstract mixin class _$AlbumDetailStateCopyWith<$Res>
    implements $AlbumDetailStateCopyWith<$Res> {
  factory _$AlbumDetailStateCopyWith(
          _AlbumDetailState value, $Res Function(_AlbumDetailState) _then) =
      __$AlbumDetailStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {AlbumDto? album, bool loading, String? error, Set<int> pendingMediaIds});

  @override
  $AlbumDtoCopyWith<$Res>? get album;
}

class __$AlbumDetailStateCopyWithImpl<$Res>
    implements _$AlbumDetailStateCopyWith<$Res> {
  __$AlbumDetailStateCopyWithImpl(this._self, this._then);

  final _AlbumDetailState _self;
  final $Res Function(_AlbumDetailState) _then;

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
              as Set<int>,
    ));
  }

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
