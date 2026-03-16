import '../../../packages/index.dart';
import '../../home/home_controller.dart';
import 'album_detail_controller.dart';
import 'album_detail_state.dart';
import '../media_viewer/media_viewer_page.dart';

class AlbumDetailPage extends StatelessWidget {
  const AlbumDetailPage({super.key, required this.album});

  final AlbumDto album;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AlbumDetailController(album),
      child: const _AlbumDetailView(),
    );
  }
}

class _AlbumDetailView extends StatelessWidget {
  const _AlbumDetailView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumDetailController, AlbumDetailState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColor.spaceBg,
          appBar: _buildAppBar(context, state),
          body: _buildBody(context, state),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, AlbumDetailState state) {
    final name = state.album?.name ?? 'Album';
    final count = state.album?.mediaList?.length ?? 0;

    return PreferredSize(
      preferredSize: const Size.fromHeight(AppStyleConstant.appBarHeight),
      child: Container(
        height: AppStyleConstant.appBarHeight + MediaQuery.of(context).padding.top,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        decoration: const BoxDecoration(
          color: AppColor.spaceCard,
          border: Border(bottom: BorderSide(color: AppColor.spaceBorder)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    size: 20, color: AppColor.spaceTextPrimary),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColor.spaceTextPrimary,
                      ),
                    ),
                    Text(
                      '$count ${count == 1 ? 'image' : 'images'}',
                      style: GoogleFonts.inter(fontSize: 12, color: AppColor.spaceTextSecondary),
                    ),
                  ],
                ),
              ),
              if (state.loading)
                const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: SizedBox(
                    width: 20, height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColor.primary),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDeleteAlbum(BuildContext context, AlbumDetailState state) {
    final homeCtrl = context.read<HomeController>();
    final albumId = state.album?.id ?? '';
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.spaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppStyleConstant.sheetTopBorderRadius),
        ),
      ),
      builder: (sheetCtx) => Padding(
        padding: EdgeInsets.fromLTRB(
            24, 20, 24, MediaQuery.of(sheetCtx).padding.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppColor.spaceBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                color: AppColor.alertError.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.delete_forever_outlined,
                  color: AppColor.alertError, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              'Delete Album',
              style: GoogleFonts.inter(
                  fontSize: 17, fontWeight: FontWeight.w700,
                  color: AppColor.spaceTextPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              'This album will be permanently deleted. Images inside will not be affected.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: 13, color: AppColor.spaceTextSecondary, height: 1.5),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: YDOutlinedButton(
                    onPressed: () => Navigator.of(sheetCtx).pop(),
                    label: Text('Cancel',
                        style: GoogleFonts.inter(
                            fontSize: 14, fontWeight: FontWeight.w600,
                            color: Colors.black)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppFilledButton(
                    onPressed: () {
                      Navigator.of(sheetCtx).pop();
                      homeCtrl.deleteAlbum(
                        albumId,
                        onSuccess: () {
                          if (context.mounted) Navigator.of(context).pop();
                        },
                        onError: (msg) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Row(children: [
                              const Icon(Icons.error_outline, color: Colors.white, size: 18),
                              const SizedBox(width: 10),
                              Expanded(child: Text(msg, style: const TextStyle(color: Colors.white))),
                            ]),
                            backgroundColor: AppColor.alertError,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            margin: const EdgeInsets.all(16),
                            duration: const Duration(seconds: 4),
                          ));
                        },
                      );
                    },
                    active: AppColor.alertError,
                    buttonStyle: YDButtonStyle.defaultSolidStyle.copyWith(
                      backgroundColor: const MaterialStatePropertyAll(AppColor.alertError),
                      foregroundColor: const MaterialStatePropertyAll(Colors.black),
                    ),
                    child: Text('Delete',
                        style: GoogleFonts.inter(
                            fontSize: 14, fontWeight: FontWeight.w600,
                            color: Colors.black)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AlbumDetailState state) {
    if (state.loading && state.album?.mediaList == null) {
      return _buildLoadingGrid();
    }

    if (state.error != null && (state.album?.mediaList?.isEmpty ?? true)) {
      return _buildError(context, state.error!);
    }

    final media = state.album?.mediaList ?? [];

    if (media.isEmpty) {
      return _buildEmpty();
    }

    return RefreshIndicator(
      color: AppColor.primary,
      onRefresh: () => context.read<AlbumDetailController>().refresh(),
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: media.length,
        itemBuilder: (context, i) {
          final item = media[i];
          final isPending = state.pendingMediaIds.contains(item.id);
          return _MediaThumbnail(
            media: item,
            isPending: isPending,
            albumId: state.album!.id!,
            allMedia: media,
            index: i,
          );
        },
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: 12,
      itemBuilder: (_, __) => AppSkeletonWidget(
        width: double.infinity,
        height: double.infinity,
        border: BorderRadius.circular(AppStyleConstant.smallRounding),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_outlined, size: 56, color: AppColor.spaceTextSecondary),
            const SizedBox(height: 16),
            Text(message,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 14, color: AppColor.spaceTextSecondary)),
            const SizedBox(height: 20),
            AppFilledButton(
              onPressed: () => context.read<AlbumDetailController>().refresh(),
              child: Text('Retry',
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80, height: 80,
              decoration: const BoxDecoration(color: AppColor.primaryBackground, shape: BoxShape.circle),
              child: const Icon(Icons.photo_library_outlined, size: 38, color: AppColor.primary),
            ),
            const SizedBox(height: 20),
            Text('No Images Yet',
                style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppColor.spaceTextPrimary)),
            const SizedBox(height: 8),
            Text('This album is empty.\nGenerate some art and add it here.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 14, color: AppColor.spaceTextSecondary)),
          ],
        ),
      ),
    );
  }
}

// ─── Media Thumbnail ──────────────────────────────────────────────────────────

class _MediaThumbnail extends StatelessWidget {
  const _MediaThumbnail({
    required this.media,
    required this.isPending,
    required this.albumId,
    required this.allMedia,
    required this.index,
  });

  final MediaDto media;
  final bool isPending;
  final String albumId;
  final List<MediaDto> allMedia;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isPending
          ? null
          : () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<AlbumDetailController>(),
                    child: MediaViewerPage(
                      media: allMedia,
                      initialIndex: index,
                      albumId: albumId,
                    ),
                  ),
                ),
              ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppStyleConstant.smallRounding),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (media.mediaUrl != null)
              AppImage(asset: media.mediaUrl!, fit: BoxFit.cover)
            else
              Container(color: AppColor.spaceCardHigh),
            if (isPending)
              Container(
                color: Colors.black.withValues(alpha: 0.45),
                child: const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
