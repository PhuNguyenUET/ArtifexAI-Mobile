import '../../../packages/index.dart';
import '../../home/home_controller.dart';
import '../../project/mask_edit_page.dart';
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
    required this.homeController,
  });

  final List<MediaDto> media;
  final int initialIndex;
  final int albumId;
  final HomeController homeController;

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
              mediaId: _current.id ?? 0,
              albumId: widget.albumId,
              mediaUrl: _current.mediaUrl,
              mediaPath: _current.mediaPath,
              homeController: widget.homeController,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Bottom Action Bar ────────────────────────────────────────────────────────

class _BottomActionBar extends StatefulWidget {
  const _BottomActionBar({
    required this.mediaId,
    required this.albumId,
    required this.mediaUrl,
    required this.homeController,
    this.mediaPath,
  });

  final int mediaId;
  final int albumId;
  final String? mediaUrl;
  final String? mediaPath;
  final HomeController homeController;

  @override
  State<_BottomActionBar> createState() => _BottomActionBarState();
}

class _BottomActionBarState extends State<_BottomActionBar> {
  bool _isSaving = false;

  // ─── Save to phone gallery ────────────────────────────────────────────────

  Future<void> _saveToGallery() async {
    final url = widget.mediaUrl;
    if (url == null || _isSaving) return;
    setState(() => _isSaving = true);
    try {
      final permission = await PhotoManager.requestPermissionExtend();
      if (!permission.hasAccess) {
        if (!mounted) return;
        _showSnackBar(
          icon: Icons.lock_outline_rounded,
          message: 'Photo library permission denied. Please enable it in Settings.',
          color: Colors.redAccent,
        );
        return;
      }

      final response = await Dio().get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      final bytes = Uint8List.fromList(response.data!);

      final fileName = Uri.parse(url).pathSegments.lastWhere(
            (s) => s.isNotEmpty,
            orElse: () => 'artifex_${DateTime.now().millisecondsSinceEpoch}.jpg',
          );

      await PhotoManager.editor.saveImage(bytes, filename: fileName);

      if (!mounted) return;
      _showSnackBar(
        icon: Icons.check_circle_outline,
        message: 'Saved to your phone\'s gallery',
        color: const Color(0xFF2ECC71),
      );
    } catch (e) {
      if (!mounted) return;
      _showSnackBar(
        icon: Icons.error_outline_rounded,
        message: 'Could not save image: ${e.toString()}',
        color: Colors.redAccent,
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showSnackBar({
    required IconData icon,
    required String message,
    required Color color,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(message, style: const TextStyle(color: Colors.white))),
        ]),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Row 1: Remove from Album | Save to Gallery ───────────────────
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.folder_off_outlined,
                  label: 'Remove from Album',
                  color: Colors.white,
                  onTap: () => _confirmRemove(context),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ActionButton(
                  icon: _isSaving ? Icons.hourglass_top_rounded : Icons.save_alt_rounded,
                  label: 'Save to Gallery',
                  color: const Color(0xFF2ECC71),
                  onTap: (!_isSaving && widget.mediaUrl != null) ? _saveToGallery : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // ── Row 2: Mask Edit | Delete Image ──────────────────────────────
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: Icons.brush_rounded,
                  label: 'Mask Edit',
                  color: AppColor.gradientStart3,
                  onTap: widget.mediaUrl != null
                      ? () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => MaskEditPage(
                              imageUrl: widget.mediaUrl!,
                              imagePath: widget.mediaPath,
                              homeController: widget.homeController,
                              showProjectPicker: true,
                            ),
                          ))
                      : null,
                ),
              ),
              const SizedBox(width: 10),
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
          mediaId: widget.mediaId,
          albumId: widget.albumId,
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
          mediaId: widget.mediaId,
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
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

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
