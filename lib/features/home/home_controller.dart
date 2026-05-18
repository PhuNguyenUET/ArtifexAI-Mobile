import '../../init/access_token_storage.dart';
import '../../init/sl.dart';
import '../../packages/index.dart';
import 'home_state.dart';

class HomeController extends Cubit<HomeState> {
  HomeController() : super(const HomeState()) {
    _fetchAlbumsAndGallery();
  }

  final _storage = sl.get<AccessTokenStorage>();

  void switchTab(HomeTab tab) {
    emit(state.copyWith(activeTab: tab));
    if (tab == HomeTab.albums && state.albums.isEmpty && !state.albumsLoading) {
      _fetchAlbumsAndGallery();
    } else if (tab == HomeTab.projects && state.projects.isEmpty && !state.projectsLoading) {
      fetchProjects();
    } else if (tab == HomeTab.profile && state.user == null && !state.profileLoading) {
      fetchProfile();
    }
  }

  Future<void> _fetchAlbumsAndGallery() async {
    await Future.wait([fetchAlbums(), fetchGallery()]);
  }

  Future<void> fetchAlbums() async {
    emit(state.copyWith(albumsLoading: true, albumsError: null));
    try {
      final albums = await _storage.repository.getAllAlbums();
      emit(state.copyWith(albums: albums));
    } on CustomException catch (e) {
      emit(state.copyWith(albumsError: e.message));
    } catch (_) {
      emit(state.copyWith(albumsError: 'Failed to load albums.'));
    } finally {
      emit(state.copyWith(albumsLoading: false));
    }
  }

  Future<void> fetchGallery() async {
    emit(state.copyWith(galleryLoading: true, galleryError: null));
    try {
      final media = await _storage.repository.getGallery();
      emit(state.copyWith(gallery: media));
    } on CustomException catch (e) {
      emit(state.copyWith(galleryError: e.message));
    } catch (_) {
      emit(state.copyWith(galleryError: 'Failed to load gallery.'));
    } finally {
      emit(state.copyWith(galleryLoading: false));
    }
  }

  Future<void> deleteGalleryMedia({
    required int mediaId,
    VoidCallback? onSuccess,
    void Function(String)? onError,
  }) async {
    try {
      await _storage.repository.deleteMedia(mediaId: mediaId);
      emit(state.copyWith(
        gallery: state.gallery.where((m) => m.id != mediaId).toList(),
      ));
      onSuccess?.call();
    } on CustomException catch (e) {
      onError?.call(e.message);
    } catch (_) {
      onError?.call('Failed to delete image.');
    }
  }

  Future<bool> addMediaToAlbum({
    required int mediaId,
    required int albumId,
  }) async {
    try {
      await _storage.repository.addMedia(albumId: albumId, mediaId: mediaId);
      return true;
    } on CustomException {
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> deleteAlbum(
    int albumId, {
    VoidCallback? onSuccess,
    void Function(String)? onError,
  }) async {
    try {
      await _storage.repository.deleteAlbum(albumId: albumId);
      final updated = state.albums.where((a) => a.id != albumId).toList();
      emit(state.copyWith(albums: updated));
      onSuccess?.call();
    } on CustomException catch (e) {
      onError?.call(e.message);
    } catch (_) {
      onError?.call('Failed to delete album.');
    }
  }

  Future<AlbumDto?> createAlbum({
    required String name,
    required List<int> mediaIds,
    void Function(String)? onError,
  }) async {
    try {
      final album = await _storage.repository.createAlbum(
        name: name,
        mediaIds: mediaIds,
      );
      emit(state.copyWith(albums: [album, ...state.albums]));
      return album;
    } on CustomException catch (e) {
      onError?.call(e.message);
      return null;
    } catch (_) {
      onError?.call('Failed to create album.');
      return null;
    }
  }

  Future<void> fetchProjects() async {
    emit(state.copyWith(projectsLoading: true, projectsError: null));
    try {
      final projects = await _storage.repository.getAllProjects();
      emit(state.copyWith(projects: projects));
    } on CustomException catch (e) {
      emit(state.copyWith(projectsError: e.message));
    } catch (_) {
      emit(state.copyWith(projectsError: 'Failed to load projects.'));
    } finally {
      emit(state.copyWith(projectsLoading: false));
    }
  }

  Future<void> deleteProject(
    int projectId, {
    VoidCallback? onSuccess,
    void Function(String)? onError,
  }) async {
    try {
      await _storage.repository.deleteProject(projectId: projectId);
      final updated = state.projects.where((p) => p.id != projectId).toList();
      emit(state.copyWith(projects: updated));
      onSuccess?.call();
    } on CustomException catch (e) {
      onError?.call(e.message);
    } catch (_) {
      onError?.call('Failed to delete project.');
    }
  }

  Future<ProjectDto?> createProject({
    required String projectName,
    required ArtStyle artStyle,
    required List<String> instructions,
    void Function(String)? onError,
  }) async {
    try {
      final project = await _storage.repository.createProject(
        projectName: projectName,
        artStyle: artStyle,
        instructions: instructions.isNotEmpty ? instructions.join('\n') : '',
      );
      emit(state.copyWith(projects: [project, ...state.projects]));
      return project;
    } on CustomException catch (e) {
      onError?.call(e.message);
      return null;
    } catch (_) {
      onError?.call('Failed to create project.');
      return null;
    }
  }

  Future<void> fetchProfile() async {
    emit(state.copyWith(profileLoading: true, profileError: null));
    try {
      final user = await _storage.repository.currentUser();
      emit(state.copyWith(user: user));
    } on CustomException catch (e) {
      emit(state.copyWith(profileError: e.message));
    } catch (_) {
      emit(state.copyWith(profileError: 'Failed to load profile.'));
    } finally {
      emit(state.copyWith(profileLoading: false));
    }
  }

  Future<void> signOut(VoidCallback onSignedOut) async {
    await _storage.clearTokens();
    onSignedOut();
  }

  Future<bool> editUser({
    String? firstName,
    String? lastName,
    String? dateOfBirth,
    void Function(String)? onError,
  }) async {
    try {
      await _storage.repository.editUser(
        firstName: firstName,
        lastName: lastName,
        dateOfBirth: dateOfBirth,
      );
      final updated = await _storage.repository.currentUser();
      emit(state.copyWith(user: updated));
      return true;
    } on CustomException catch (e) {
      onError?.call(e.message);
      return false;
    } catch (_) {
      onError?.call('Failed to update profile.');
      return false;
    }
  }

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
    void Function(String)? onError,
  }) async {
    try {
      await _storage.repository
          .changePassword(oldPassword: oldPassword, newPassword: newPassword);
      return true;
    } on CustomException catch (e) {
      onError?.call(e.message);
      return false;
    } catch (_) {
      onError?.call('Failed to change password.');
      return false;
    }
  }

  Future<bool> sendVerificationEmail({
    void Function(String)? onError,
  }) async {
    try {
      await _storage.repository.validateEmail();
      return true;
    } on CustomException catch (e) {
      onError?.call(e.message);
      return false;
    } catch (_) {
      onError?.call('Failed to send verification email.');
      return false;
    }
  }

  Future<bool> verifyEmailToken({
    required String token,
    void Function(String)? onError,
  }) async {
    try {
      await _storage.repository.emailToken(token: token);
      final updated = await _storage.repository.currentUser();
      emit(state.copyWith(user: updated));
      return true;
    } on CustomException catch (e) {
      onError?.call(e.message);
      return false;
    } catch (_) {
      onError?.call('Invalid or expired token. Please try again.');
      return false;
    }
  }
}

