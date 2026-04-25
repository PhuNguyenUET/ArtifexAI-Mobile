import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../packages/domain/index.dart';

part 'album_detail_state.freezed.dart';

@freezed
abstract class AlbumDetailState with _$AlbumDetailState {
  const factory AlbumDetailState({
    AlbumDto? album,
    @Default(false) bool loading,
    String? error,
    // Tracks media IDs currently being deleted/removed so the UI can show
    // per-item loading indicators.
    @Default({}) Set<int> pendingMediaIds,
  }) = _AlbumDetailState;
}

