// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HomeState {
  HomeTab get activeTab; // Albums
  List<AlbumDto> get albums;
  bool get albumsLoading;
  String? get albumsError; // Projects
  List<ProjectDto> get projects;
  bool get projectsLoading;
  String? get projectsError; // Profile
  UserDto? get user;
  bool get profileLoading;
  String? get profileError;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HomeStateCopyWith<HomeState> get copyWith =>
      _$HomeStateCopyWithImpl<HomeState>(this as HomeState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HomeState &&
            (identical(other.activeTab, activeTab) ||
                other.activeTab == activeTab) &&
            const DeepCollectionEquality().equals(other.albums, albums) &&
            (identical(other.albumsLoading, albumsLoading) ||
                other.albumsLoading == albumsLoading) &&
            (identical(other.albumsError, albumsError) ||
                other.albumsError == albumsError) &&
            const DeepCollectionEquality().equals(other.projects, projects) &&
            (identical(other.projectsLoading, projectsLoading) ||
                other.projectsLoading == projectsLoading) &&
            (identical(other.projectsError, projectsError) ||
                other.projectsError == projectsError) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.profileLoading, profileLoading) ||
                other.profileLoading == profileLoading) &&
            (identical(other.profileError, profileError) ||
                other.profileError == profileError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      activeTab,
      const DeepCollectionEquality().hash(albums),
      albumsLoading,
      albumsError,
      const DeepCollectionEquality().hash(projects),
      projectsLoading,
      projectsError,
      user,
      profileLoading,
      profileError);

  @override
  String toString() {
    return 'HomeState(activeTab: $activeTab, albums: $albums, albumsLoading: $albumsLoading, albumsError: $albumsError, projects: $projects, projectsLoading: $projectsLoading, projectsError: $projectsError, user: $user, profileLoading: $profileLoading, profileError: $profileError)';
  }
}

/// @nodoc
abstract mixin class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) _then) =
      _$HomeStateCopyWithImpl;
  @useResult
  $Res call(
      {HomeTab activeTab,
      List<AlbumDto> albums,
      bool albumsLoading,
      String? albumsError,
      List<ProjectDto> projects,
      bool projectsLoading,
      String? projectsError,
      UserDto? user,
      bool profileLoading,
      String? profileError});

  $UserDtoCopyWith<$Res>? get user;
}

/// @nodoc
class _$HomeStateCopyWithImpl<$Res> implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._self, this._then);

  final HomeState _self;
  final $Res Function(HomeState) _then;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeTab = null,
    Object? albums = null,
    Object? albumsLoading = null,
    Object? albumsError = freezed,
    Object? projects = null,
    Object? projectsLoading = null,
    Object? projectsError = freezed,
    Object? user = freezed,
    Object? profileLoading = null,
    Object? profileError = freezed,
  }) {
    return _then(_self.copyWith(
      activeTab: null == activeTab
          ? _self.activeTab
          : activeTab // ignore: cast_nullable_to_non_nullable
              as HomeTab,
      albums: null == albums
          ? _self.albums
          : albums // ignore: cast_nullable_to_non_nullable
              as List<AlbumDto>,
      albumsLoading: null == albumsLoading
          ? _self.albumsLoading
          : albumsLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      albumsError: freezed == albumsError
          ? _self.albumsError
          : albumsError // ignore: cast_nullable_to_non_nullable
              as String?,
      projects: null == projects
          ? _self.projects
          : projects // ignore: cast_nullable_to_non_nullable
              as List<ProjectDto>,
      projectsLoading: null == projectsLoading
          ? _self.projectsLoading
          : projectsLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      projectsError: freezed == projectsError
          ? _self.projectsError
          : projectsError // ignore: cast_nullable_to_non_nullable
              as String?,
      user: freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserDto?,
      profileLoading: null == profileLoading
          ? _self.profileLoading
          : profileLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      profileError: freezed == profileError
          ? _self.profileError
          : profileError // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserDtoCopyWith<$Res>? get user {
    if (_self.user == null) {
      return null;
    }

    return $UserDtoCopyWith<$Res>(_self.user!, (value) {
      return _then(_self.copyWith(user: value));
    });
  }
}

/// Adds pattern-matching-related methods to [HomeState].
extension HomeStatePatterns on HomeState {
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
    TResult Function(_HomeState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HomeState() when $default != null:
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
    TResult Function(_HomeState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeState():
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
    TResult? Function(_HomeState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeState() when $default != null:
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
            HomeTab activeTab,
            List<AlbumDto> albums,
            bool albumsLoading,
            String? albumsError,
            List<ProjectDto> projects,
            bool projectsLoading,
            String? projectsError,
            UserDto? user,
            bool profileLoading,
            String? profileError)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _HomeState() when $default != null:
        return $default(
            _that.activeTab,
            _that.albums,
            _that.albumsLoading,
            _that.albumsError,
            _that.projects,
            _that.projectsLoading,
            _that.projectsError,
            _that.user,
            _that.profileLoading,
            _that.profileError);
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
            HomeTab activeTab,
            List<AlbumDto> albums,
            bool albumsLoading,
            String? albumsError,
            List<ProjectDto> projects,
            bool projectsLoading,
            String? projectsError,
            UserDto? user,
            bool profileLoading,
            String? profileError)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeState():
        return $default(
            _that.activeTab,
            _that.albums,
            _that.albumsLoading,
            _that.albumsError,
            _that.projects,
            _that.projectsLoading,
            _that.projectsError,
            _that.user,
            _that.profileLoading,
            _that.profileError);
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
            HomeTab activeTab,
            List<AlbumDto> albums,
            bool albumsLoading,
            String? albumsError,
            List<ProjectDto> projects,
            bool projectsLoading,
            String? projectsError,
            UserDto? user,
            bool profileLoading,
            String? profileError)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _HomeState() when $default != null:
        return $default(
            _that.activeTab,
            _that.albums,
            _that.albumsLoading,
            _that.albumsError,
            _that.projects,
            _that.projectsLoading,
            _that.projectsError,
            _that.user,
            _that.profileLoading,
            _that.profileError);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _HomeState implements HomeState {
  const _HomeState(
      {this.activeTab = HomeTab.albums,
      final List<AlbumDto> albums = const [],
      this.albumsLoading = false,
      this.albumsError,
      final List<ProjectDto> projects = const [],
      this.projectsLoading = false,
      this.projectsError,
      this.user,
      this.profileLoading = false,
      this.profileError})
      : _albums = albums,
        _projects = projects;

  @override
  @JsonKey()
  final HomeTab activeTab;
// Albums
  final List<AlbumDto> _albums;
// Albums
  @override
  @JsonKey()
  List<AlbumDto> get albums {
    if (_albums is EqualUnmodifiableListView) return _albums;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_albums);
  }

  @override
  @JsonKey()
  final bool albumsLoading;
  @override
  final String? albumsError;
// Projects
  final List<ProjectDto> _projects;
// Projects
  @override
  @JsonKey()
  List<ProjectDto> get projects {
    if (_projects is EqualUnmodifiableListView) return _projects;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_projects);
  }

  @override
  @JsonKey()
  final bool projectsLoading;
  @override
  final String? projectsError;
// Profile
  @override
  final UserDto? user;
  @override
  @JsonKey()
  final bool profileLoading;
  @override
  final String? profileError;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HomeStateCopyWith<_HomeState> get copyWith =>
      __$HomeStateCopyWithImpl<_HomeState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HomeState &&
            (identical(other.activeTab, activeTab) ||
                other.activeTab == activeTab) &&
            const DeepCollectionEquality().equals(other._albums, _albums) &&
            (identical(other.albumsLoading, albumsLoading) ||
                other.albumsLoading == albumsLoading) &&
            (identical(other.albumsError, albumsError) ||
                other.albumsError == albumsError) &&
            const DeepCollectionEquality().equals(other._projects, _projects) &&
            (identical(other.projectsLoading, projectsLoading) ||
                other.projectsLoading == projectsLoading) &&
            (identical(other.projectsError, projectsError) ||
                other.projectsError == projectsError) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.profileLoading, profileLoading) ||
                other.profileLoading == profileLoading) &&
            (identical(other.profileError, profileError) ||
                other.profileError == profileError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      activeTab,
      const DeepCollectionEquality().hash(_albums),
      albumsLoading,
      albumsError,
      const DeepCollectionEquality().hash(_projects),
      projectsLoading,
      projectsError,
      user,
      profileLoading,
      profileError);

  @override
  String toString() {
    return 'HomeState(activeTab: $activeTab, albums: $albums, albumsLoading: $albumsLoading, albumsError: $albumsError, projects: $projects, projectsLoading: $projectsLoading, projectsError: $projectsError, user: $user, profileLoading: $profileLoading, profileError: $profileError)';
  }
}

/// @nodoc
abstract mixin class _$HomeStateCopyWith<$Res>
    implements $HomeStateCopyWith<$Res> {
  factory _$HomeStateCopyWith(
          _HomeState value, $Res Function(_HomeState) _then) =
      __$HomeStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {HomeTab activeTab,
      List<AlbumDto> albums,
      bool albumsLoading,
      String? albumsError,
      List<ProjectDto> projects,
      bool projectsLoading,
      String? projectsError,
      UserDto? user,
      bool profileLoading,
      String? profileError});

  @override
  $UserDtoCopyWith<$Res>? get user;
}

/// @nodoc
class __$HomeStateCopyWithImpl<$Res> implements _$HomeStateCopyWith<$Res> {
  __$HomeStateCopyWithImpl(this._self, this._then);

  final _HomeState _self;
  final $Res Function(_HomeState) _then;

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? activeTab = null,
    Object? albums = null,
    Object? albumsLoading = null,
    Object? albumsError = freezed,
    Object? projects = null,
    Object? projectsLoading = null,
    Object? projectsError = freezed,
    Object? user = freezed,
    Object? profileLoading = null,
    Object? profileError = freezed,
  }) {
    return _then(_HomeState(
      activeTab: null == activeTab
          ? _self.activeTab
          : activeTab // ignore: cast_nullable_to_non_nullable
              as HomeTab,
      albums: null == albums
          ? _self._albums
          : albums // ignore: cast_nullable_to_non_nullable
              as List<AlbumDto>,
      albumsLoading: null == albumsLoading
          ? _self.albumsLoading
          : albumsLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      albumsError: freezed == albumsError
          ? _self.albumsError
          : albumsError // ignore: cast_nullable_to_non_nullable
              as String?,
      projects: null == projects
          ? _self._projects
          : projects // ignore: cast_nullable_to_non_nullable
              as List<ProjectDto>,
      projectsLoading: null == projectsLoading
          ? _self.projectsLoading
          : projectsLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      projectsError: freezed == projectsError
          ? _self.projectsError
          : projectsError // ignore: cast_nullable_to_non_nullable
              as String?,
      user: freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserDto?,
      profileLoading: null == profileLoading
          ? _self.profileLoading
          : profileLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      profileError: freezed == profileError
          ? _self.profileError
          : profileError // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }

  /// Create a copy of HomeState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserDtoCopyWith<$Res>? get user {
    if (_self.user == null) {
      return null;
    }

    return $UserDtoCopyWith<$Res>(_self.user!, (value) {
      return _then(_self.copyWith(user: value));
    });
  }
}

// dart format on
