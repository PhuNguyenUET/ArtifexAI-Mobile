import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_player/video_player.dart';
import '../../init/access_token_storage.dart';
import '../../init/sl.dart';
import '../../packages/index.dart';
import '../home/home_controller.dart';
import 'project_state.dart';

class GenerationResultPage extends StatefulWidget {
  const GenerationResultPage({
    super.key,
    required this.result,
    required this.mode,
    required this.projectId,
    required this.homeController,
    this.videoUrl,
    this.customTitle,
  });

  final ImageResponseDto result;
  final GenerationMode   mode;
  final int           projectId;
  final HomeController   homeController;
  final String?          videoUrl;
  final String?          customTitle;

  @override
  State<GenerationResultPage> createState() => _GenerationResultPageState();
}

class _GenerationResultPageState extends State<GenerationResultPage> {
  int _currentIndex = 0;
  final CarouselSliderController _carouselCtrl = CarouselSliderController();

  VideoPlayerController? _videoCtrl;
  bool _videoInitialized = false;

  bool get _isVideo => widget.videoUrl != null;
  List<String> get _urls => widget.result.imageUrls ?? [];
  bool get _single => _urls.length == 1;

  @override
  void initState() {
    super.initState();
    if (_isVideo) _initVideo();
  }

  Future<void> _initVideo() async {
    _videoCtrl = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl!));
    await _videoCtrl!.initialize();
    _videoCtrl!.setLooping(true);
    _videoCtrl!.play();
    _videoCtrl!.addListener(_onVideoUpdate);
    if (mounted) setState(() => _videoInitialized = true);
  }

  void _onVideoUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _videoCtrl?.dispose();
    super.dispose();
  }

  bool _isSaving = false;

  Future<void> _saveToGallery(String url) async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      final permission = await PhotoManager.requestPermissionExtend();
      if (!permission.hasAccess) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(_snackBar(
          icon: Icons.lock_outline_rounded,
          message: 'Photo library permission denied. Please enable it in Settings.',
          color: Colors.redAccent,
        ));
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

      await PhotoManager.editor.saveImage(
        bytes,
        filename: fileName,
      );

      await widget.homeController.fetchGallery();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(_snackBar(
        icon: Icons.check_circle_outline,
        message: 'Saved to your phone\'s gallery',
        color: const Color(0xFF2ECC71),
      ));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(_snackBar(
        icon: Icons.error_outline_rounded,
        message: 'Could not save image: ${e.toString()}',
        color: Colors.redAccent,
      ));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  SnackBar _snackBar({
    required IconData icon,
    required String message,
    required Color color,
  }) {
    return SnackBar(
      content: Row(children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(message, style: const TextStyle(color: Colors.white)),
        ),
      ]),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const LavaBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(context),
                Expanded(child: _buildContent()),
                _buildBottomBar(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
      decoration: const BoxDecoration(
        color: AppColor.spaceCard,
        border: Border(bottom: BorderSide(color: AppColor.spaceBorder)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.customTitle ?? '${widget.mode.label} Results',
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                ),
                Text(
                  _isVideo
                      ? '1 video generated'
                      : '${_urls.length} image${_urls.length != 1 ? 's' : ''} generated',
                  style: GoogleFonts.inter(fontSize: 12, color: AppColor.spaceTextSecondary),
                ),
              ],
            ),
          ),
          if (!_single)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColor.primaryBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_currentIndex + 1} / ${_urls.length}',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColor.primary),
              ),
            ),
        ],
      ),
    );
  }

  void _showInstructionSheet() {
    bool adding = false;
    bool added  = false;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSt) {
          Future<void> removeFromProject() async {
                if (adding || added) return;
                setSt(() => adding = true);
                try {
                  final project = await sl
                      .get<AccessTokenStorage>()
                      .repository
                      .getProjectById(projectId: widget.projectId);
                  final updatedList = (project.instructions ?? [])
                      .where((i) => i != widget.result.updatedInstruction!)
                      .toList();
                  await sl
                      .get<AccessTokenStorage>()
                      .repository
                      .updateInstructions(
                        projectId: widget.projectId,
                        instructions: updatedList,
                      );
                  setSt(() { adding = false; added = true; });
                } catch (_) {
                  setSt(() => adding = false);
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(_snackBar(
                      icon: Icons.error_outline_rounded,
                      message: 'Could not remove instruction. Please try again.',
                      color: Colors.redAccent,
                    ));
                  }
                }
              }

              return Container(
                margin: EdgeInsets.fromLTRB(
                    12, 0, 12, MediaQuery.of(context).padding.bottom + 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColor.spaceCard,
                  borderRadius:
                      BorderRadius.circular(AppStyleConstant.largeRounding),
                  border: Border.all(color: AppColor.spaceBorder),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: AppColor.spaceBorder,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.tips_and_updates_outlined,
                            size: 18, color: AppColor.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Updated Instructions',
                          style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColor.spaceCardHigh,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColor.spaceBorder),
                      ),
                      child: Text(
                        widget.result.updatedInstruction!,
                        style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColor.spaceTextPrimary,
                            height: 1.6),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (widget.result.updatedInstruction != 'N/A')
                    GestureDetector(
                      onTap: added ? null : removeFromProject,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: BoxDecoration(
                          gradient: added
                              ? null
                              : const LinearGradient(
                                  colors: [
                                    AppColor.gradientStart3,
                                    AppColor.gradientEnd3
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                          color: added ? AppColor.spaceCardHigh : null,
                          borderRadius: BorderRadius.circular(
                              AppStyleConstant.buttonBorderRadius),
                          border: added
                              ? Border.all(color: AppColor.spaceBorder)
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: adding
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    added
                                        ? Icons.check_circle_outline_rounded
                                        : Icons.remove_circle_outline_rounded,
                                    size: 16,
                                    color: added
                                        ? AppColor.primary
                                        : Colors.white,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    added
                                        ? 'Removed from Instructions'
                                        : 'Remove from Project Instructions',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: added
                                          ? AppColor.primary
                                          : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => Navigator.of(ctx).pop(),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: BoxDecoration(
                          color: AppColor.spaceCardHigh,
                          borderRadius: BorderRadius.circular(
                              AppStyleConstant.buttonBorderRadius),
                          border: Border.all(color: AppColor.spaceBorder),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Got it',
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
            },
          ),
        );
  }

  Widget _buildContent() {
    if (_isVideo) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _videoInitialized && _videoCtrl != null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppStyleConstant.largeRounding),
                      child: AspectRatio(
                        aspectRatio: _videoCtrl!.value.aspectRatio,
                        child: VideoPlayer(_videoCtrl!),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => setState(() {
                        _videoCtrl!.value.isPlaying
                            ? _videoCtrl!.pause()
                            : _videoCtrl!.play();
                      }),
                      child: Container(
                        width: 52, height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.spaceCardHigh,
                          border: Border.all(color: AppColor.spaceBorder),
                        ),
                        child: Icon(
                          _videoCtrl!.value.isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: Colors.white, size: 28,
                        ),
                      ),
                    ),
                  ],
                )
              : Container(
                  height: 220,
                  decoration: BoxDecoration(
                    color: AppColor.spaceCardHigh,
                    borderRadius: BorderRadius.circular(AppStyleConstant.largeRounding),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(color: AppColor.primary, strokeWidth: 2),
                  ),
                ),
        ),
      );
    }

    if (_single) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppStyleConstant.largeRounding),
            child: AspectRatio(
              aspectRatio: 1,
              child: AppImage(asset: _urls.first, fit: BoxFit.cover, width: double.infinity),
            ),
          ),
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
        const SizedBox(height: 16),
        CarouselSlider.builder(
          carouselController: _carouselCtrl,
          itemCount: _urls.length,
          options: CarouselOptions(
            height: MediaQuery.of(context).size.width - 32,
            viewportFraction: 0.88,
            enlargeCenterPage: true,
            enlargeFactor: 0.22,
            enableInfiniteScroll: _urls.length > 1,
            onPageChanged: (i, _) => setState(() => _currentIndex = i),
          ),
          itemBuilder: (_, i, __) => ClipRRect(
            borderRadius: BorderRadius.circular(AppStyleConstant.largeRounding),
            child: AspectRatio(
              aspectRatio: 1,
              child: AppImage(asset: _urls[i], fit: BoxFit.cover, width: double.infinity),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_urls.length, (i) {
            final active = i == _currentIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: active ? 22 : 7,
              height: 7,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: active ? AppColor.primary : AppColor.spaceBorder,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final currentUrl = _urls.isNotEmpty ? _urls[_currentIndex] : null;
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
      decoration: const BoxDecoration(
        color: AppColor.spaceCard,
        border: Border(top: BorderSide(color: AppColor.spaceBorder)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.result.updatedInstruction != null && widget.result.updatedInstruction != 'N/A') ...[
            GestureDetector(
              onTap: _showInstructionSheet,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: AppColor.spaceCardHigh,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColor.primary.withValues(alpha: 0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.tips_and_updates_outlined, size: 15, color: AppColor.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'AI updated the instructions for better results',
                        style: GoogleFonts.inter(fontSize: 12, color: AppColor.spaceTextSecondary),
                      ),
                    ),
                    Text(
                      'See details',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColor.primary),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 11, color: AppColor.primary),
                  ],
                ),
              ),
            ),
          ],
          Row(
            children: [
              if (!_isVideo) ...[
                Expanded(
                  child: _ActionButton(
                    icon: _isSaving ? Icons.hourglass_top_rounded : Icons.save_alt_rounded,
                    label: _single ? 'Save to Gallery' : 'Save This',
                    gradient: const [AppColor.gradientStart3, AppColor.gradientEnd3],
                    onTap: (!_isSaving && currentUrl != null) ? () => _saveToGallery(currentUrl) : null,
                  ),
                ),
                if (!_single) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ActionButton(
                      icon: _isSaving ? Icons.hourglass_top_rounded : Icons.save_rounded,
                      label: 'Save All',
                      gradient: const [AppColor.gradientStart5, AppColor.gradientEnd5],
                      onTap: _isSaving
                          ? null
                          : () async {
                              for (final url in _urls) await _saveToGallery(url);
                            },
                    ),
                  ),
                ],

              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    this.gradient,
    this.onTap,
  });

  final IconData          icon;
  final String            label;
  final List<Color>?      gradient;
  final VoidCallback?     onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: gradient != null
              ? LinearGradient(colors: gradient!, begin: Alignment.topLeft, end: Alignment.bottomRight)
              : null,
          borderRadius: BorderRadius.circular(AppStyleConstant.buttonBorderRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 6),
            Text(label, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

