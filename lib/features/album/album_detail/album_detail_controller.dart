import '../../../init/access_token_storage.dart';
import '../../../init/sl.dart';
import '../../../packages/index.dart';
import 'album_detail_state.dart';

class AlbumDetailController extends Cubit<AlbumDetailState> {
  AlbumDetailController(AlbumDto album)
      : super(AlbumDetailState(album: album)) {
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

  Future<void> deleteMedia({
    required int mediaId,
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

  Future<void> removeFromAlbum({
    required int mediaId,
    required int albumId,
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

  void _markPending(int id) {
    emit(state.copyWith(pendingMediaIds: {...state.pendingMediaIds, id}));
  }

  void _unmarkPending(int id) {
    emit(state.copyWith(
      pendingMediaIds: state.pendingMediaIds.where((e) => e != id).toSet(),
    ));
  }

  void _removeMedia(int id) {
    final updated = state.album?.mediaList?.where((m) => m.id != id).toList();
    emit(state.copyWith(
      album: state.album?.copyWith(mediaList: updated ?? []),
    ));
  }
}
