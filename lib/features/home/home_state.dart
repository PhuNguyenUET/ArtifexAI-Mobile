import 'package:freezed_annotation/freezed_annotation.dart';
import '../../packages/domain/index.dart';

part 'home_state.freezed.dart';

enum HomeTab { albums, projects, profile }

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(HomeTab.albums) HomeTab activeTab,

    // Gallery (all user media — shown as pinned card in Albums tab)
    @Default([]) List<MediaDto> gallery,
    @Default(false) bool galleryLoading,
    String? galleryError,

    // Albums
    @Default([]) List<AlbumDto> albums,
    @Default(false) bool albumsLoading,
    String? albumsError,

    // Projects
    @Default([]) List<ProjectDto> projects,
    @Default(false) bool projectsLoading,
    String? projectsError,

    // Profile
    UserDto? user,
    @Default(false) bool profileLoading,
    String? profileError,
  }) = _HomeState;
}

