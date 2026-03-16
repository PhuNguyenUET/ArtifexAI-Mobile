import '../../../packages/index.dart';
import '../album_detail/album_detail_controller.dart';

/// Full-screen image viewer with a bottom action bar.
///
/// Receives the full [media] list and the [initialIndex] so the user can
/// swipe between images without going back to the grid.
class MediaViewerPage extends StatefulWidget {
  const MediaViewerPage({
    super.key,
    required this.media,
    required this.initialIndex,
    required this.albumId,
  });

  final List<MediaDto> media;
  final int initialIndex;
  final String albumId;

  @override
  State<MediaViewerPage> createState() => _MediaViewerPageState();
}

class _MediaViewerPageState extends State<MediaViewerPage> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  MediaDto get _current => widget.media[_currentIndex];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // ── Space background ─────────────────────────────────────────────────
          const LavaBackground(),
          // Dark scrim so the image reads clearly against the background
          Container(color: Colors.black.withValues(alpha: 0.55)),
          // ── Full-screen pager ────────────────────────────────────────────────
          PageView.builder(
            controller: _pageController,
            itemCount: widget.media.length,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            itemBuilder: (context, i) {
              final item = widget.media[i];
              return InteractiveViewer(
                minScale: 0.8,
                maxScale: 4.0,
                child: Center(
                  child: item.mediaUrl != null
                      ? AppImage(
                          asset: item.mediaUrl!,
                          fit: BoxFit.contain,
                        )
                      : const Icon(Icons.broken_image_outlined,
                          size: 64, color: Colors.white38),
                ),
              );
            },
          ),

          // ── Top bar ──────────────────────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                left: 8,
                right: 16,
                bottom: 8,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.6),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded,
                        color: Colors.white, size: 24),
                  ),
                  const Spacer(),
                  // Page indicator  e.g. "3 / 12"
                  Text(
                    '${_currentIndex + 1} / ${widget.media.length}',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom action bar ─────────────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _BottomActionBar(
              mediaId: _current.id ?? '',
              albumId: widget.albumId,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Bottom Action Bar ────────────────────────────────────────────────────────

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar({
    required this.mediaId,
    required this.albumId,
  });

  final String mediaId;
  final String albumId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withValues(alpha: 0.75),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        children: [
          // Remove from album
          Expanded(
            child: _ActionButton(
              icon: Icons.folder_off_outlined,
              label: 'Remove from Album',
              color: Colors.white,
              onTap: () => _confirmRemove(context),
            ),
          ),
          const SizedBox(width: 16),
          // Delete permanently
          Expanded(
            child: _ActionButton(
              icon: Icons.delete_outline_rounded,
              label: 'Delete Image',
              color: AppColor.alertError,
              onTap: () => _confirmDelete(context),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmRemove(BuildContext context) {
    _showConfirmSheet(
      context: context,
      icon: Icons.folder_off_outlined,
      iconColor: AppColor.alertWarning,
      title: 'Remove from Album',
      message: 'This image will be removed from this album but will remain in your gallery.',
      confirmLabel: 'Remove',
      confirmColor: AppColor.alertWarning,
      onConfirm: () {
        context.read<AlbumDetailController>().removeFromAlbum(
          mediaId: mediaId,
          albumId: albumId,
          onSuccess: () {
            if (context.mounted) Navigator.of(context).pop();
          },
          onError: (msg) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(msg), backgroundColor: AppColor.alertError),
              );
            }
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context) {
    _showConfirmSheet(
      context: context,
      icon: Icons.delete_forever_outlined,
      iconColor: AppColor.alertError,
      title: 'Delete Image',
      message: 'This image will be permanently deleted and cannot be recovered.',
      confirmLabel: 'Delete',
      confirmColor: AppColor.alertError,
      onConfirm: () {
        context.read<AlbumDetailController>().deleteMedia(
          mediaId: mediaId,
          onSuccess: () {
            if (context.mounted) Navigator.of(context).pop();
          },
          onError: (msg) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(msg), backgroundColor: AppColor.alertError),
              );
            }
          },
        );
      },
    );
  }

  void _showConfirmSheet({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String message,
    required String confirmLabel,
    required Color confirmColor,
    required VoidCallback onConfirm,
  }) {
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
          24, 20, 24, MediaQuery.of(sheetCtx).padding.bottom + 24,
        ),
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
                color: iconColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 17, fontWeight: FontWeight.w700,
                color: AppColor.spaceTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13, color: AppColor.spaceTextSecondary, height: 1.5,
              ),
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
                      onConfirm();
                    },
                    active: confirmColor,
                    buttonStyle: YDButtonStyle.defaultSolidStyle.copyWith(
                      backgroundColor: MaterialStatePropertyAll(confirmColor),
                      foregroundColor: const MaterialStatePropertyAll(Colors.white),
                    ),
                    child: Text(confirmLabel,
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
}

// ─── Action Button ────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppStyleConstant.mediumRounding),
          border: Border.all(
            color: color.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 5),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


