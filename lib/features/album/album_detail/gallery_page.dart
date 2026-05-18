import '../../../packages/index.dart';
import '../../home/home_controller.dart';
import '../../home/home_state.dart';
import '../media_viewer/gallery_viewer_page.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<HomeController>(),
      child: const _GalleryView(),
    );
  }
}

class _GalleryView extends StatelessWidget {
  const _GalleryView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeController, HomeState>(
      builder: (context, state) => Scaffold(
        backgroundColor: AppColor.spaceBg,
        appBar: _buildAppBar(context, state),
        body: _buildBody(context, state),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, HomeState state) {
    final count = state.gallery.length;

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
                    Row(
                      children: [
                        Text(
                          'Gallery',
                          style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColor.spaceTextPrimary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColor.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.auto_awesome, size: 10, color: Colors.white),
                              const SizedBox(width: 3),
                              Text('All Images',
                                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '$count ${count == 1 ? 'image' : 'images'}',
                      style: GoogleFonts.inter(fontSize: 12, color: AppColor.spaceTextSecondary),
                    ),
                  ],
                ),
              ),
              if (state.galleryLoading)
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

  Widget _buildBody(BuildContext context, HomeState state) {
    if (state.galleryLoading && state.gallery.isEmpty) {
      return _buildLoadingGrid();
    }

    if (state.galleryError != null && state.gallery.isEmpty) {
      return _buildError(context, state.galleryError!);
    }

    if (state.gallery.isEmpty) {
      return _buildEmpty();
    }

    return RefreshIndicator(
      color: AppColor.primary,
      onRefresh: () => context.read<HomeController>().fetchGallery(),
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: state.gallery.length,
        itemBuilder: (context, i) => _GalleryThumbnail(
          media: state.gallery[i],
          allMedia: state.gallery,
          index: i,
        ),
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
              onPressed: () => context.read<HomeController>().fetchGallery(),
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
              decoration: const BoxDecoration(
                color: AppColor.primaryBackground,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.photo_library_outlined, size: 38, color: AppColor.primary),
            ),
            const SizedBox(height: 20),
            Text('No Images Yet',
                style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppColor.spaceTextPrimary)),
            const SizedBox(height: 8),
            Text('Your generated images will appear here.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 14, color: AppColor.spaceTextSecondary)),
          ],
        ),
      ),
    );
  }
}

class _GalleryThumbnail extends StatelessWidget {
  const _GalleryThumbnail({
    required this.media,
    required this.allMedia,
    required this.index,
  });

  final MediaDto media;
  final List<MediaDto> allMedia;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<HomeController>(),
            child: GalleryViewerPage(
              media: allMedia,
              initialIndex: index,
            ),
          ),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppStyleConstant.smallRounding),
        child: media.mediaUrl != null
            ? AppImage(asset: media.mediaUrl!, fit: BoxFit.cover)
            : Container(color: AppColor.spaceCardHigh),
      ),
    );
  }
}

