import 'package:freezed_annotation/freezed_annotation.dart';
import '../../packages/domain/index.dart';

part 'home_state.freezed.dart';

enum HomeTab { albums, projects, profile }

@freezed
abstract class HomeState with _$HomeState {
  const factory HomeState({
    @Default(HomeTab.albums) HomeTab activeTab,

    @Default([]) List<MediaDto> gallery,
    @Default(false) bool galleryLoading,
    String? galleryError,

    @Default([]) List<AlbumDto> albums,
    @Default(false) bool albumsLoading,
    String? albumsError,

    @Default([]) List<ProjectDto> projects,
    @Default(false) bool projectsLoading,
    String? projectsError,

    UserDto? user,
    @Default(false) bool profileLoading,
    String? profileError,
  }) = _HomeState;
}

