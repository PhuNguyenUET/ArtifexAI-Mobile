import '../../../packages/index.dart';
import '../../home/home_controller.dart';

/// Full-screen image viewer opened from the Gallery card.
/// Bottom bar has: Delete (permanent) + Add to Albums (multi-select picker).
class GalleryViewerPage extends StatefulWidget {
  const GalleryViewerPage({
    super.key,
    required this.media,
    required this.initialIndex,
  });

  final List<MediaDto> media;
  final int initialIndex;

  @override
  State<GalleryViewerPage> createState() => _GalleryViewerPageState();
}

class _GalleryViewerPageState extends State<GalleryViewerPage> {
  late final PageController _pageController;
  late List<MediaDto> _media;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _media = List.of(widget.media);
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  MediaDto get _current => _media[_currentIndex];

  void _removeCurrentFromList() {
    setState(() {
      _media.removeAt(_currentIndex);
      if (_media.isEmpty) {
        Navigator.of(context).pop();
        return;
      }
      // Keep index in bounds after removal
      if (_currentIndex >= _media.length) {
        _currentIndex = _media.length - 1;
      }
      // Rebuild controller for the new list
      _pageController.jumpToPage(_currentIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_media.isEmpty) return const SizedBox.shrink();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // ── Space background ──────────────────────────────────────────────
          const LavaBackground(),
          // Dark scrim so the image reads clearly against the background
          Container(color: Colors.black.withValues(alpha: 0.55)),
          // ── Full-screen pager ──────────────────────────────────────────────
          PageView.builder(
            controller: _pageController,
            itemCount: _media.length,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            itemBuilder: (context, i) {
              final item = _media[i];
              return InteractiveViewer(
                minScale: 0.8,
                maxScale: 4.0,
                child: Center(
                  child: item.mediaUrl != null
                      ? AppImage(asset: item.mediaUrl!, fit: BoxFit.contain)
                      : const Icon(Icons.broken_image_outlined,
                          size: 64, color: Colors.white38),
                ),
              );
            },
          ),

          // ── Top bar ────────────────────────────────────────────────────────
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
                  Text(
                    '${_currentIndex + 1} / ${_media.length}',
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

          // ── Bottom action bar ──────────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _GalleryActionBar(
              mediaId: _current.id ?? '',
              onDeleted: _removeCurrentFromList,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Gallery Action Bar ───────────────────────────────────────────────────────

class _GalleryActionBar extends StatelessWidget {
  const _GalleryActionBar({
    required this.mediaId,
    required this.onDeleted,
  });

  final String mediaId;
  final VoidCallback onDeleted;

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
          // Add to Albums
          Expanded(
            child: _GalleryActionButton(
              icon: Icons.add_to_photos_outlined,
              label: 'Add to Albums',
              color: Colors.white,
              onTap: () => _showAddToAlbumsSheet(context),
            ),
          ),
          const SizedBox(width: 16),
          // Delete permanently
          Expanded(
            child: _GalleryActionButton(
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

  // ─── Delete ─────────────────────────────────────────────────────────────────

  void _confirmDelete(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.spaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppStyleConstant.sheetTopBorderRadius),
        ),
      ),
      builder: (sheetCtx) => _ConfirmDeleteSheet(
        onConfirm: () {
          context.read<HomeController>().deleteGalleryMedia(
            mediaId: mediaId,
            onSuccess: onDeleted,
            onError: (msg) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(msg),
                    backgroundColor: AppColor.alertError,
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }

  // ─── Add to Albums ──────────────────────────────────────────────────────────

  void _showAddToAlbumsSheet(BuildContext context) {
    // Capture the HomeController before going into the sheet's builder context.
    final homeCtrl = context.read<HomeController>();
    final albums = homeCtrl.state.albums;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.spaceCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppStyleConstant.sheetTopBorderRadius),
        ),
      ),
      builder: (_) => _AddToAlbumsSheet(
        mediaId: mediaId,
        albums: albums,
        homeController: homeCtrl,
      ),
    );
  }
}

// ─── Confirm Delete Sheet ─────────────────────────────────────────────────────

class _ConfirmDeleteSheet extends StatelessWidget {
  const _ConfirmDeleteSheet({required this.onConfirm});

  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          24, 20, 24, MediaQuery.of(context).padding.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
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
            'Delete Image',
            style: GoogleFonts.inter(
                fontSize: 17, fontWeight: FontWeight.w700,
                color: AppColor.spaceTextPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            'This image will be permanently deleted and cannot be recovered.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
                fontSize: 13, color: AppColor.spaceTextSecondary, height: 1.5),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: YDOutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
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
                    Navigator.of(context).pop();
                    onConfirm();
                  },
                  active: AppColor.alertError,
                  buttonStyle: YDButtonStyle.defaultSolidStyle.copyWith(
                    backgroundColor: const MaterialStatePropertyAll(AppColor.alertError),
                    foregroundColor: const MaterialStatePropertyAll(Colors.white),
                  ),
                  child: Text('Delete',
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Add to Albums Sheet ──────────────────────────────────────────────────────

class _AddToAlbumsSheet extends StatefulWidget {
  const _AddToAlbumsSheet({
    required this.mediaId,
    required this.albums,
    required this.homeController,
  });

  final String mediaId;
  final List<AlbumDto> albums;
  final HomeController homeController;

  @override
  State<_AddToAlbumsSheet> createState() => _AddToAlbumsSheetState();
}

class _AddToAlbumsSheetState extends State<_AddToAlbumsSheet> {
  final Set<String> _selected = {};
  bool _loading = false;

  Future<void> _submit() async {
    if (_selected.isEmpty) {
      Navigator.of(context).pop();
      return;
    }
    setState(() => _loading = true);

    int successes = 0;
    int failures = 0;

    await Future.wait(
      _selected.map((albumId) async {
        final ok = await widget.homeController.addMediaToAlbum(
          mediaId: widget.mediaId,
          albumId: albumId,
        );
        if (ok) {
          successes++;
        } else {
          failures++;
        }
      }),
    );

    if (!mounted) return;
    Navigator.of(context).pop();

    final msg = failures == 0
        ? 'Added to ${successes == 1 ? '1 album' : '$successes albums'}'
        : 'Added to $successes album${successes != 1 ? 's' : ''}, $failures failed';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor:
            failures == 0 ? AppColor.alertSuccess : AppColor.alertWarning,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, scrollController) => Column(
        children: [
          // ── Header ────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Column(
              children: [
                // Drag handle
                Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: AppColor.spaceBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Add to Albums',
                      style: GoogleFonts.inter(
                        fontSize: 17, fontWeight: FontWeight.w700,
                        color: AppColor.spaceTextPrimary,
                      ),
                    ),
                    const Spacer(),
                    if (_selected.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColor.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('${_selected.length} selected',
                            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Select one or more albums to add this image to.',
                  style: GoogleFonts.inter(fontSize: 13, color: AppColor.spaceTextSecondary),
                ),
                const SizedBox(height: 12),
                Divider(height: 1, color: AppColor.spaceBorder),
              ],
            ),
          ),

          // ── Album list ────────────────────────────────────────────────────
          Expanded(
            child: widget.albums.isEmpty
                ? Center(
                    child: Text('No albums yet',
                        style: GoogleFonts.inter(fontSize: 14, color: AppColor.spaceTextSecondary)),
                  )
                : ListView.separated(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: widget.albums.length,
                    separatorBuilder: (_, __) => Divider(
                        height: 1, indent: 72, color: AppColor.spaceBorder),
                    itemBuilder: (_, i) {
                      final album = widget.albums[i];
                      final id = album.id ?? '';
                      final isSelected = _selected.contains(id);
                      final thumb = album.mediaList?.isNotEmpty == true
                          ? album.mediaList!.first.mediaUrl
                          : null;
                      final count = album.mediaList?.length ?? 0;

                      return InkWell(
                        onTap: () => setState(() {
                          if (isSelected) {
                            _selected.remove(id);
                          } else {
                            _selected.add(id);
                          }
                        }),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    AppStyleConstant.smallRounding),
                                child: SizedBox(
                                  width: 48, height: 48,
                                  child: thumb != null
                                      ? AppImage(asset: thumb, fit: BoxFit.cover)
                                      : Container(
                                          color: AppColor.spaceCardHigh,
                                          child: const Icon(
                                              Icons.photo_library_outlined,
                                              size: 22,
                                              color: AppColor.spaceTextSecondary),
                                        ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      album.name ?? 'Untitled',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                          fontSize: 15, fontWeight: FontWeight.w600,
                                          color: AppColor.spaceTextPrimary),
                                    ),
                                    Text(
                                      '$count ${count == 1 ? 'image' : 'images'}',
                                      style: GoogleFonts.inter(
                                          fontSize: 12, color: AppColor.spaceTextSecondary),
                                    ),
                                  ],
                                ),
                              ),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                width: 24, height: 24,
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColor.primary : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected ? AppColor.primary : AppColor.spaceBorder,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: isSelected
                                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // ── Done button ───────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(24, 12, 24, bottomInset + 16),
            child: AppFilledButton(
              onPressed: _loading ? null : _submit,
              width: double.infinity,
              child: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : Text(
                      _selected.isEmpty ? 'Cancel' : 'Add to ${_selected.length} album${_selected.length != 1 ? 's' : ''}',
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Action Button ────────────────────────────────────────────────────────────

class _GalleryActionButton extends StatelessWidget {
  const _GalleryActionButton({
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
          border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
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
                  fontSize: 11, fontWeight: FontWeight.w500, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

