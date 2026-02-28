import '../../init/access_token_storage.dart';
import '../../init/sl.dart';
import '../../packages/index.dart';
import 'home_state.dart';

class HomeController extends Cubit<HomeState> {
  HomeController() : super(const HomeState()) {
    fetchAlbums();
  }

  final _storage = sl.get<AccessTokenStorage>();

  // ─── Tab ─────────────────────────────────────────────────────────────────────

  void switchTab(HomeTab tab) {
    emit(state.copyWith(activeTab: tab));
    if (tab == HomeTab.albums && state.albums.isEmpty && !state.albumsLoading) {
      fetchAlbums();
    } else if (tab == HomeTab.projects && state.projects.isEmpty && !state.projectsLoading) {
      fetchProjects();
    } else if (tab == HomeTab.profile && state.user == null && !state.profileLoading) {
      fetchProfile();
    }
  }

  // ─── Albums ───────────────────────────────────────────────────────────────────

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

  Future<void> deleteAlbum(String albumId) async {
    try {
      await _storage.repository.deleteAlbum(albumId: albumId);
      final updated = state.albums.where((a) => a.id != albumId).toList();
      emit(state.copyWith(albums: updated));
    } on CustomException catch (e) {
      emit(state.copyWith(albumsError: e.message));
    } catch (_) {
      emit(state.copyWith(albumsError: 'Failed to delete album.'));
    }
  }

  // ─── Projects ─────────────────────────────────────────────────────────────────

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

  Future<void> deleteProject(String projectId) async {
    try {
      await _storage.repository.deleteProject(projectId: projectId);
      final updated = state.projects.where((p) => p.id != projectId).toList();
      emit(state.copyWith(projects: updated));
    } on CustomException catch (e) {
      emit(state.copyWith(projectsError: e.message));
    } catch (_) {
      emit(state.copyWith(projectsError: 'Failed to delete project.'));
    }
  }

  // ─── Profile ──────────────────────────────────────────────────────────────────

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
}

