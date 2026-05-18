// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_state.dart';

// **************************************************************************
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

mixin _$HomeState {
  HomeTab
      get activeTab; // Gallery (all user media — shown as pinned card in Albums tab)
  List<MediaDto> get gallery;
  bool get galleryLoading;
  String? get galleryError; // Albums
  List<AlbumDto> get albums;
  bool get albumsLoading;
  String? get albumsError; // Projects
  List<ProjectDto> get projects;
  bool get projectsLoading;
  String? get projectsError; // Profile
  UserDto? get user;
  bool get profileLoading;
  String? get profileError;

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
            const DeepCollectionEquality().equals(other.gallery, gallery) &&
            (identical(other.galleryLoading, galleryLoading) ||
                other.galleryLoading == galleryLoading) &&
            (identical(other.galleryError, galleryError) ||
                other.galleryError == galleryError) &&
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
      const DeepCollectionEquality().hash(gallery),
      galleryLoading,
      galleryError,
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
    return 'HomeState(activeTab: $activeTab, gallery: $gallery, galleryLoading: $galleryLoading, galleryError: $galleryError, albums: $albums, albumsLoading: $albumsLoading, albumsError: $albumsError, projects: $projects, projectsLoading: $projectsLoading, projectsError: $projectsError, user: $user, profileLoading: $profileLoading, profileError: $profileError)';
  }
}

abstract mixin class $HomeStateCopyWith<$Res> {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) _then) =
      _$HomeStateCopyWithImpl;
  @useResult
  $Res call(
      {HomeTab activeTab,
      List<MediaDto> gallery,
      bool galleryLoading,
      String? galleryError,
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

class _$HomeStateCopyWithImpl<$Res> implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._self, this._then);

  final HomeState _self;
  final $Res Function(HomeState) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activeTab = null,
    Object? gallery = null,
    Object? galleryLoading = null,
    Object? galleryError = freezed,
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
      gallery: null == gallery
          ? _self.gallery
          : gallery // ignore: cast_nullable_to_non_nullable
              as List<MediaDto>,
      galleryLoading: null == galleryLoading
          ? _self.galleryLoading
          : galleryLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      galleryError: freezed == galleryError
          ? _self.galleryError
          : galleryError // ignore: cast_nullable_to_non_nullable
              as String?,
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

extension HomeStatePatterns on HomeState {

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

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            HomeTab activeTab,
            List<MediaDto> gallery,
            bool galleryLoading,
            String? galleryError,
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
            _that.gallery,
            _that.galleryLoading,
            _that.galleryError,
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

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            HomeTab activeTab,
            List<MediaDto> gallery,
            bool galleryLoading,
            String? galleryError,
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
            _that.gallery,
            _that.galleryLoading,
            _that.galleryError,
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

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            HomeTab activeTab,
            List<MediaDto> gallery,
            bool galleryLoading,
            String? galleryError,
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
            _that.gallery,
            _that.galleryLoading,
            _that.galleryError,
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

class _HomeState implements HomeState {
  const _HomeState(
      {this.activeTab = HomeTab.albums,
      final List<MediaDto> gallery = const [],
      this.galleryLoading = false,
      this.galleryError,
      final List<AlbumDto> albums = const [],
      this.albumsLoading = false,
      this.albumsError,
      final List<ProjectDto> projects = const [],
      this.projectsLoading = false,
      this.projectsError,
      this.user,
      this.profileLoading = false,
      this.profileError})
      : _gallery = gallery,
        _albums = albums,
        _projects = projects;

  @override
  @JsonKey()
  final HomeTab activeTab;
  final List<MediaDto> _gallery;
  @override
  @JsonKey()
  List<MediaDto> get gallery {
    if (_gallery is EqualUnmodifiableListView) return _gallery;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_gallery);
  }

  @override
  @JsonKey()
  final bool galleryLoading;
  @override
  final String? galleryError;
  final List<AlbumDto> _albums;
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
  final List<ProjectDto> _projects;
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
  @override
  final UserDto? user;
  @override
  @JsonKey()
  final bool profileLoading;
  @override
  final String? profileError;

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
            const DeepCollectionEquality().equals(other._gallery, _gallery) &&
            (identical(other.galleryLoading, galleryLoading) ||
                other.galleryLoading == galleryLoading) &&
            (identical(other.galleryError, galleryError) ||
                other.galleryError == galleryError) &&
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
      const DeepCollectionEquality().hash(_gallery),
      galleryLoading,
      galleryError,
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
    return 'HomeState(activeTab: $activeTab, gallery: $gallery, galleryLoading: $galleryLoading, galleryError: $galleryError, albums: $albums, albumsLoading: $albumsLoading, albumsError: $albumsError, projects: $projects, projectsLoading: $projectsLoading, projectsError: $projectsError, user: $user, profileLoading: $profileLoading, profileError: $profileError)';
  }
}

abstract mixin class _$HomeStateCopyWith<$Res>
    implements $HomeStateCopyWith<$Res> {
  factory _$HomeStateCopyWith(
          _HomeState value, $Res Function(_HomeState) _then) =
      __$HomeStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {HomeTab activeTab,
      List<MediaDto> gallery,
      bool galleryLoading,
      String? galleryError,
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

class __$HomeStateCopyWithImpl<$Res> implements _$HomeStateCopyWith<$Res> {
  __$HomeStateCopyWithImpl(this._self, this._then);

  final _HomeState _self;
  final $Res Function(_HomeState) _then;

  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? activeTab = null,
    Object? gallery = null,
    Object? galleryLoading = null,
    Object? galleryError = freezed,
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
      gallery: null == gallery
          ? _self._gallery
          : gallery // ignore: cast_nullable_to_non_nullable
              as List<MediaDto>,
      galleryLoading: null == galleryLoading
          ? _self.galleryLoading
          : galleryLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      galleryError: freezed == galleryError
          ? _self.galleryError
          : galleryError // ignore: cast_nullable_to_non_nullable
              as String?,
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
