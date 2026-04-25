import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' as ui;

import '../../init/access_token_storage.dart';
import '../../init/sl.dart';
import '../../packages/index.dart';
import '../home/home_controller.dart';
import 'generation_result_page.dart';
import 'project_state.dart';

// ─── Data ─────────────────────────────────────────────────────────────────────

class _DrawStroke {
  final List<Offset> points;
  final double brushSize;
  final bool isErase;

  const _DrawStroke({
    required this.points,
    required this.brushSize,
    required this.isErase,
  });
}

// ─── Page ─────────────────────────────────────────────────────────────────────

/// Full-screen page that lets the user paint a mask over an image, choose
/// [EditMode], enter a prompt, and call [imageMaskedEdit].
///
/// * [imageUrl]       – URL / server path of the source image.
/// * [mimeType]          – MIME type of the image (defaults to JPEG).
/// * [projectId]         – Pre-selected project.  Required when
///                         [showProjectPicker] is false.
/// * [showProjectPicker] – When true a project dropdown is shown so the user
///                         can pick which project to generate into.
///                         Pass false (default) when a [projectId] is already
///                         known (e.g. opened from GenerationResultPage).
/// * [homeController]    – Used for project list + gallery refresh.
class MaskEditPage extends StatefulWidget {
  const MaskEditPage({
    super.key,
    required this.imageUrl,
    this.imagePath,
    this.projectId,
    this.showProjectPicker = false,
    required this.homeController,
  });

  /// Signed URL used only for displaying the image on canvas.
  final String imageUrl;

  /// Server-side media path (e.g. `server/image_xxx.png`) sent to the API.
  /// Falls back to [imageUrl] when null.
  final String? imagePath;

  final int? projectId;
  final bool showProjectPicker;
  final HomeController homeController;

  @override
  State<MaskEditPage> createState() => _MaskEditPageState();
}

class _MaskEditPageState extends State<MaskEditPage> {
  // ── Drawing state ────────────────────────────────────────────────────────
  final List<_DrawStroke> _strokes = [];
  List<Offset> _currentStrokePoints = [];
  double _brushSize = 24.0;
  bool _isErase = false;
  Size _canvasSize = Size.zero;

  // ── API options ──────────────────────────────────────────────────────────
  EditMode _editMode = EditMode.editModeDefault;
  final _promptCtrl = TextEditingController();

  // ── Project selection (when projectId not pre-set) ───────────────────────
  int? _selectedProjectId;
  List<ProjectDto> _projects = [];
  bool _projectsLoading = false;

  // ── Generating ───────────────────────────────────────────────────────────
  bool _generating = false;

  /// Original pixel dimensions of the source image, resolved on init.
  /// Used to capture the mask at the correct size to match the server image.
  Size? _originalImageSize;

  @override
  void initState() {
    super.initState();
    _selectedProjectId = widget.projectId;
    if (widget.showProjectPicker) _loadProjects();
    _loadImageSize();
  }

  @override
  void dispose() {
    _promptCtrl.dispose();
    super.dispose();
  }

  // ─── Image size resolution ────────────────────────────────────────────────

  Future<void> _loadImageSize() async {
    if (widget.imageUrl.isEmpty) return;
    try {
      final completer = Completer<ui.Image>();
      final provider = CachedNetworkImageProvider(widget.imageUrl);
      final stream = provider.resolve(const ImageConfiguration());
      late ImageStreamListener listener;
      listener = ImageStreamListener(
        (info, _) {
          if (!completer.isCompleted) completer.complete(info.image);
          stream.removeListener(listener);
        },
        onError: (e, _) {
          if (!completer.isCompleted) completer.completeError(e);
          stream.removeListener(listener);
        },
      );
      stream.addListener(listener);
      final img = await completer.future;
      _originalImageSize = Size(img.width.toDouble(), img.height.toDouble());
    } catch (_) {
      // Falls back to canvas size in _captureMask()
    }
  }

  // ─── Project loading ──────────────────────────────────────────────────────

  Future<void> _loadProjects() async {
    setState(() => _projectsLoading = true);
    try {
      final list =
          await sl.get<AccessTokenStorage>().repository.getAllProjects();
      if (mounted) setState(() => _projects = list);
    } catch (_) {
      if (mounted) _toast('Failed to load projects', isError: true);
    } finally {
      if (mounted) setState(() => _projectsLoading = false);
    }
  }

  // ─── Drawing ──────────────────────────────────────────────────────────────

  void _onPanStart(DragStartDetails d) {
    _currentStrokePoints = [d.localPosition];
    setState(() {});
  }

  void _onPanUpdate(DragUpdateDetails d) {
    _currentStrokePoints.add(d.localPosition);
    setState(() {});
  }

  void _onPanEnd(DragEndDetails _) {
    if (_currentStrokePoints.isNotEmpty) {
      _strokes.add(_DrawStroke(
        points: List.of(_currentStrokePoints),
        brushSize: _brushSize,
        isErase: _isErase,
      ));
      _currentStrokePoints = [];
    }
    setState(() {});
  }

  void _clearMask() => setState(() {
        _strokes.clear();
        _currentStrokePoints = [];
      });

  void _undoLast() {
    if (_strokes.isNotEmpty) setState(() => _strokes.removeLast());
  }

  // ─── All strokes including any in-progress stroke ─────────────────────────

  List<_DrawStroke> get _allStrokes => [
        ..._strokes,
        if (_currentStrokePoints.isNotEmpty)
          _DrawStroke(
            points: _currentStrokePoints,
            brushSize: _brushSize,
            isErase: _isErase,
          ),
      ];

  // ─── Mask capture via PictureRecorder ────────────────────────────────────

  Future<String> _captureMask() async {
    final Size targetSize;
    final List<_DrawStroke> strokesToRender;

    if (_originalImageSize != null && _originalImageSize != Size.zero) {
      // Compute the BoxFit.contain scale used to display the image in the canvas.
      // renderScale = how many canvas pixels correspond to one image pixel.
      final double renderScale = math.min(
        _canvasSize.width / _originalImageSize!.width,
        _canvasSize.height / _originalImageSize!.height,
      );
      // The image is centred inside the canvas — compute the letterbox offsets.
      final double offsetX =
          (_canvasSize.width - _originalImageSize!.width * renderScale) / 2;
      final double offsetY =
          (_canvasSize.height - _originalImageSize!.height * renderScale) / 2;

      // Transform every stroke point from canvas space → image space.
      strokesToRender = _allStrokes.map((stroke) {
        return _DrawStroke(
          points: stroke.points
              .map((p) => Offset(
                    (p.dx - offsetX) / renderScale,
                    (p.dy - offsetY) / renderScale,
                  ))
              .toList(),
          brushSize: stroke.brushSize / renderScale,
          isErase: stroke.isErase,
        );
      }).toList();
      targetSize = _originalImageSize!;
    } else {
      // Fallback: no size info, use canvas dimensions as before.
      strokesToRender = _allStrokes;
      targetSize = _canvasSize;
    }

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    _MaskPainter(strokes: strokesToRender).paint(canvas, targetSize);
    final picture = recorder.endRecording();
    final image = await picture.toImage(
      targetSize.width.round(),
      targetSize.height.round(),
    );
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return base64Encode(byteData!.buffer.asUint8List());
  }

  // ─── Toast ────────────────────────────────────────────────────────────────

  void _toast(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(
        content: Row(children: [
          Icon(isError ? Icons.error_outline : Icons.info_outline,
              color: Colors.white, size: 18),
          const SizedBox(width: 10),
          Expanded(
              child:
                  Text(msg, style: const TextStyle(color: Colors.white))),
        ]),
        backgroundColor:
            isError ? AppColor.alertError : AppColor.alertWarning,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ));
  }

  // ─── Generate ─────────────────────────────────────────────────────────────

  Future<void> _generate() async {
    final projectId = _selectedProjectId ?? widget.projectId;
    if (projectId == null) {
      _toast('Please select a project', isError: true);
      return;
    }
    if (_strokes.isEmpty && _currentStrokePoints.isEmpty) {
      _toast('Please paint the area you want to edit', isError: true);
      return;
    }
    if (_canvasSize == Size.zero) {
      _toast('Canvas not ready – please try again', isError: true);
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _generating = true);

    try {
      final maskBase64 = await _captureMask();
      final resolvedPath = widget.imagePath ?? widget.imageUrl;
      final mimeType = resolvedPath.toLowerCase().endsWith('.png')
          ? MimeType.png
          : MimeType.jpeg;
      final imageInfo = ReferenceImage(imagePath: resolvedPath, mimeType: mimeType);

          final result = await sl
          .get<AccessTokenStorage>()
          .repository
          .imageMaskedEdit(
            projectId: projectId,
            imageInfo: imageInfo,
            maskImageBase64: maskBase64,
            prompt: _promptCtrl.text.trim().isEmpty
                ? null
                : _promptCtrl.text.trim(),
            editMode: _editMode,
          );

      if (!mounted) return;
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => GenerationResultPage(
          result: result,
          mode: GenerationMode.variation,
          customTitle: 'Mask Edit Results',
          projectId: projectId,
          homeController: widget.homeController,
        ),
      ));
    } on CustomException catch (e) {
      _toast(e.message, isError: true);
    } catch (_) {
      _toast('Generation failed. Please try again.', isError: true);
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.spaceBg,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          const LavaBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(child: _buildCanvas()),
                _buildToolbar(),
                _buildOptions(),
              ],
            ),
          ),
          if (_generating) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  // ─── Full-screen loading overlay ──────────────────────────────────────────

  Widget _buildLoadingOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.82),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
            decoration: BoxDecoration(
              color: AppColor.spaceCard,
              borderRadius: BorderRadius.circular(AppStyleConstant.largeRounding),
              border: Border.all(color: AppColor.spaceBorder),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(seconds: 2),
                builder: (_, t, child) => Transform.rotate(
                  angle: t * 6.28,
                  child: child,
                ),
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppColor.gradientStart3, AppColor.gradientEnd3, AppColor.gradientStart5],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.auto_awesome, size: 32, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Generating…',
                style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'The AI is applying your mask edit.\nThis may take up to a minute.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 13, color: AppColor.spaceTextSecondary, height: 1.5),
              ),
              const SizedBox(height: 28),
              const LinearProgressIndicator(
                color: AppColor.primary,
                backgroundColor: AppColor.spaceBorder,
              ),
            ]),
          ),
        ),
      ),
    );
  }

  // ─── AppBar ───────────────────────────────────────────────────────────────

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
      decoration: const BoxDecoration(
        color: AppColor.spaceCard,
        border: Border(bottom: BorderSide(color: AppColor.spaceBorder)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mask Edit',
                  style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                Text(
                  'Paint over the region to edit',
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColor.spaceTextSecondary),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: _generating ? null : _generate,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColor.gradientStart3, AppColor.gradientEnd3],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(
                    AppStyleConstant.buttonBorderRadius),
              ),
              child: Text(
                'Generate',
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

  // ─── Canvas ───────────────────────────────────────────────────────────────

  Widget _buildCanvas() {
    return LayoutBuilder(builder: (context, constraints) {
      _canvasSize = Size(constraints.maxWidth, constraints.maxHeight);
      return GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: Stack(
          fit: StackFit.expand,
          children: [
            widget.imageUrl.isNotEmpty
                ? AppImage(asset: widget.imageUrl, fit: BoxFit.contain)
                : Container(color: AppColor.spaceCardHigh),
            CustomPaint(
              painter: _OverlayPainter(strokes: _allStrokes),
            ),
          ],
        ),
      );
    });
  }

  // ─── Toolbar ──────────────────────────────────────────────────────────────

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      decoration: const BoxDecoration(
        color: AppColor.spaceCard,
        border: Border(top: BorderSide(color: AppColor.spaceBorder)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.brush_rounded,
                  size: 15, color: AppColor.spaceTextSecondary),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 3,
                    thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 8),
                    overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 16),
                  ),
                  child: Slider(
                    value: _brushSize,
                    min: 5,
                    max: 80,
                    activeColor: AppColor.primary,
                    inactiveColor: AppColor.spaceBorder,
                    onChanged: (v) => setState(() => _brushSize = v),
                  ),
                ),
              ),
              SizedBox(
                width: 38,
                child: Text(
                  '${_brushSize.round()}px',
                  textAlign: TextAlign.right,
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColor.spaceTextSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _ToolButton(
                icon: Icons.brush_rounded,
                label: 'Paint',
                active: !_isErase,
                onTap: () => setState(() => _isErase = false),
              ),
              const SizedBox(width: 8),
              _ToolButton(
                icon: Icons.auto_fix_high_rounded,
                label: 'Erase',
                active: _isErase,
                onTap: () => setState(() => _isErase = true),
              ),
              const Spacer(),
              _ToolButton(
                icon: Icons.undo_rounded,
                label: 'Undo',
                active: false,
                onTap: _undoLast,
              ),
              const SizedBox(width: 8),
              _ToolButton(
                icon: Icons.clear_rounded,
                label: 'Clear',
                active: false,
                color: AppColor.alertError,
                onTap: _clearMask,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Options panel ────────────────────────────────────────────────────────

  Widget _buildOptions() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 260),
      decoration: const BoxDecoration(
        color: AppColor.spaceCard,
        border: Border(top: BorderSide(color: AppColor.spaceBorder)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 12,
          bottom: MediaQuery.of(context).padding.bottom + 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.showProjectPicker) ...[
              _label('Project'),
              const SizedBox(height: 6),
              _buildProjectDropdown(),
              const SizedBox(height: 14),
            ],
            _label('Edit Mode'),
            const SizedBox(height: 6),
            _buildChipSelector<EditMode>(
              values: EditMode.values,
              selected: _editMode,
              labelOf: _editModeLabel,
              onSelect: (v) => setState(() => _editMode = v),
            ),
            const SizedBox(height: 14),
            _label('Prompt (optional)'),
            const SizedBox(height: 6),
            TextField(
              controller: _promptCtrl,
              style: GoogleFonts.inter(
                  fontSize: 13, color: AppColor.spaceTextPrimary),
              maxLines: 2,
              decoration: InputDecoration(
                hintText:
                    'Describe what to generate in the selected area…',
                hintStyle: GoogleFonts.inter(
                    fontSize: 13, color: AppColor.spaceTextHint),
                filled: true,
                fillColor: AppColor.spaceInputFill,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      AppStyleConstant.textFieldBorderRadius),
                  borderSide:
                      const BorderSide(color: AppColor.spaceBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      AppStyleConstant.textFieldBorderRadius),
                  borderSide:
                      const BorderSide(color: AppColor.spaceBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      AppStyleConstant.textFieldBorderRadius),
                  borderSide:
                      const BorderSide(color: AppColor.primary),
                ),
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  // ─── Sub-helpers ──────────────────────────────────────────────────────────

  Widget _label(String text) => Text(
        text,
        style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColor.spaceTextSecondary),
      );

  Widget _buildProjectDropdown() {
    if (_projectsLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
              strokeWidth: 2, color: AppColor.primary),
        ),
      );
    }
    if (_projects.isEmpty) {
      return Text('No projects available',
          style: GoogleFonts.inter(
              fontSize: 12, color: AppColor.spaceTextHint));
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: AppColor.spaceInputFill,
        borderRadius: BorderRadius.circular(
            AppStyleConstant.textFieldBorderRadius),
        border: Border.all(color: AppColor.spaceBorder),
      ),
      child: DropdownButton<int?>(
        value: _selectedProjectId,
        isExpanded: true,
        dropdownColor: AppColor.spaceCard,
        underline: const SizedBox(),
        hint: Text('Select a project',
            style: GoogleFonts.inter(
                fontSize: 13, color: AppColor.spaceTextHint)),
        style: GoogleFonts.inter(
            fontSize: 13, color: AppColor.spaceTextPrimary),
        items: _projects
            .map((p) => DropdownMenuItem(
                  value: p.id,
                  child: Text(p.projectName ?? p.id?.toString() ?? '',
                      overflow: TextOverflow.ellipsis),
                ))
            .toList(),
        onChanged: (v) => setState(() => _selectedProjectId = v),
      ),
    );
  }

  Widget _buildChipSelector<T>({
    required List<T> values,
    required T selected,
    required String Function(T) labelOf,
    required void Function(T) onSelect,
  }) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: values.map((v) {
        final isSel = v == selected;
        return GestureDetector(
          onTap: () => onSelect(v),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isSel
                  ? AppColor.primary.withValues(alpha: 0.18)
                  : AppColor.spaceInputFill,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSel ? AppColor.primary : AppColor.spaceBorder,
              ),
            ),
            child: Text(
              labelOf(v),
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isSel
                    ? AppColor.primary
                    : AppColor.spaceTextSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ─── Label helpers ────────────────────────────────────────────────────────

  String _editModeLabel(EditMode mode) {
    switch (mode) {
      case EditMode.editModeDefault:
        return 'Default';
      case EditMode.editModeInpaintRemoval:
        return 'Removal';
      case EditMode.editModeInpaintInsertion:
        return 'Insertion';
      case EditMode.editModeOutpaint:
        return 'Outpaint';
      case EditMode.editModeControlledEditing:
        return 'Controlled';
      case EditMode.editModeStyle:
        return 'Style';
      case EditMode.editModeBgswap:
        return 'BG Swap';
      case EditMode.editModeProductImage:
        return 'Product';
      case EditMode.editModeUnspecified:
        return 'Unspecified';
    }
  }

}

// ─── _ToolButton ──────────────────────────────────────────────────────────────

class _ToolButton extends StatelessWidget {
  const _ToolButton({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c =
        color ?? (active ? AppColor.primary : AppColor.spaceTextSecondary);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active
              ? AppColor.primary.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: active ? AppColor.primary : AppColor.spaceBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: c),
            const SizedBox(width: 4),
            Text(label,
                style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: c)),
          ],
        ),
      ),
    );
  }
}

// ─── Overlay painter (semi-transparent purple highlight) ──────────────────────

class _OverlayPainter extends CustomPainter {
  final List<_DrawStroke> strokes;

  const _OverlayPainter({required this.strokes});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(
        Rect.fromLTWH(0, 0, size.width, size.height), Paint());
    for (final stroke in strokes) {
      if (stroke.points.isEmpty) continue;
      final paint = Paint()
        ..strokeWidth = stroke.brushSize
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;
      if (stroke.isErase) {
        paint
          ..blendMode = BlendMode.clear
          ..color = Colors.transparent;
      } else {
        paint
          ..blendMode = BlendMode.srcOver
          ..color = const Color(0xAAEE85FF);
      }
      _drawStroke(canvas, stroke, paint);
    }
    canvas.restore();
  }

  void _drawStroke(Canvas canvas, _DrawStroke stroke, Paint paint) {
    if (stroke.points.length == 1) {
      canvas.drawCircle(
        stroke.points.first,
        stroke.brushSize / 2,
        Paint()
          ..color = stroke.isErase
              ? Colors.transparent
              : const Color(0xAAEE85FF)
          ..blendMode =
              stroke.isErase ? BlendMode.clear : BlendMode.srcOver,
      );
    } else {
      final path = Path()
        ..moveTo(stroke.points.first.dx, stroke.points.first.dy);
      for (var i = 1; i < stroke.points.length; i++) {
        path.lineTo(stroke.points[i].dx, stroke.points[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_OverlayPainter old) => old.strokes != strokes;
}

// ─── Mask painter (black background, white = edit area) ──────────────────────

class _MaskPainter extends CustomPainter {
  final List<_DrawStroke> strokes;

  const _MaskPainter({required this.strokes});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.black,
    );
    for (final stroke in strokes) {
      if (stroke.points.isEmpty) continue;
      final color = stroke.isErase ? Colors.black : Colors.white;
      final paint = Paint()
        ..color = color
        ..strokeWidth = stroke.brushSize
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;
      if (stroke.points.length == 1) {
        canvas.drawCircle(
            stroke.points.first, stroke.brushSize / 2, Paint()..color = color);
      } else {
        final path = Path()
          ..moveTo(stroke.points.first.dx, stroke.points.first.dy);
        for (var i = 1; i < stroke.points.length; i++) {
          path.lineTo(stroke.points[i].dx, stroke.points[i].dy);
        }
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_MaskPainter old) => old.strokes != strokes;
}
