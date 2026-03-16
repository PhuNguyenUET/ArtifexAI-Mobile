import '../../../init/access_token_storage.dart';
import '../../../init/sl.dart';
import '../../../packages/index.dart';
import 'album_detail_state.dart';

class AlbumDetailController extends Cubit<AlbumDetailState> {
  AlbumDetailController(AlbumDto album)
      : super(AlbumDetailState(album: album)) {
    // Refresh the album from the server to get the latest media list.
    _refresh();
  }

  final _storage = sl.get<AccessTokenStorage>();

  Future<void> _refresh() async {
    final id = state.album?.id;
    if (id == null) return;
    emit(state.copyWith(loading: true, error: null));
    try {
      final fresh = await _storage.repository.getAlbumById(albumId: id);
      emit(state.copyWith(album: fresh));
    } on CustomException catch (e) {
      emit(state.copyWith(error: e.message));
    } catch (_) {
      emit(state.copyWith(error: 'Failed to refresh album.'));
    } finally {
      emit(state.copyWith(loading: false));
    }
  }

  Future<void> refresh() => _refresh();

  /// Permanently deletes [mediaId] from the server and removes it from the
  /// local album state.
  Future<void> deleteMedia({
    required String mediaId,
    VoidCallback? onSuccess,
    void Function(String)? onError,
  }) async {
    _markPending(mediaId);
    try {
      await _storage.repository.deleteMedia(mediaId: mediaId);
      _removeMedia(mediaId);
      onSuccess?.call();
    } on CustomException catch (e) {
      onError?.call(e.message);
    } catch (_) {
      onError?.call('Failed to delete image.');
    } finally {
      _unmarkPending(mediaId);
    }
  }

  /// Removes [mediaId] from this album only (does not delete the media itself).
  Future<void> removeFromAlbum({
    required String mediaId,
    required String albumId,
    VoidCallback? onSuccess,
    void Function(String)? onError,
  }) async {
    _markPending(mediaId);
    try {
      await _storage.repository.deleteMediaFromAlbum(
        albumId: albumId,
        mediaId: mediaId,
      );
      _removeMedia(mediaId);
      onSuccess?.call();
    } on CustomException catch (e) {
      onError?.call(e.message);
    } catch (_) {
      onError?.call('Failed to remove image from album.');
    } finally {
      _unmarkPending(mediaId);
    }
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────────

  void _markPending(String id) {
    emit(state.copyWith(pendingMediaIds: {...state.pendingMediaIds, id}));
  }

  void _unmarkPending(String id) {
    emit(state.copyWith(
      pendingMediaIds: state.pendingMediaIds.where((e) => e != id).toSet(),
    ));
  }

  void _removeMedia(String id) {
    final updated = state.album?.mediaList?.where((m) => m.id != id).toList();
    emit(state.copyWith(
      album: state.album?.copyWith(mediaList: updated ?? []),
    ));
  }
}

