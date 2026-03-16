import 'dart:convert';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import '../../packages/index.dart';
import '../home/home_controller.dart';
import 'generation_result_page.dart';
import 'project_controller.dart';
import 'project_state.dart';

class ProjectPage extends StatelessWidget {
  const ProjectPage({super.key, required this.project});

  final ProjectDto project;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProjectController(),
      child: _ProjectView(project: project),
    );
  }
}

// ─── View ──────────────────────────────────────────────────────────────────────

class _ProjectView extends StatefulWidget {
  const _ProjectView({required this.project});
  final ProjectDto project;

  @override
  State<_ProjectView> createState() => _ProjectViewState();
}

class _ProjectViewState extends State<_ProjectView> {
  // ── Shared ───────────────────────────────────────────────────────────────
  final _promptCtrl        = TextEditingController();
  final _additionalCtrl    = TextEditingController();
  final _charDescCtrl      = TextEditingController();
  final _actionDescCtrl    = TextEditingController();
  int   _numberOfOutputs   = 1;

  // ── Single-image modes ────────────────────────────────────────────────────
  ReferenceImage? _singleImage;
  String?         _singleImagePreview;   // base64

  // ── Multi-image modes ────────────────────────────────────────────────────
  final List<ReferenceImage> _multiImages      = [];
  final List<String>         _multiImagePreviews = [];

  // ── Upscale ───────────────────────────────────────────────────────────────
  UpscaleFactor _upscaleFactor = UpscaleFactor.x2;

  // ── Style change ──────────────────────────────────────────────────────────
  ArtStyle _targetStyle = ArtStyle.realistic;

  // ── Video ─────────────────────────────────────────────────────────────────
  VideoLength _videoLength = VideoLength.medium;

  @override
  void dispose() {
    _promptCtrl.dispose();
    _additionalCtrl.dispose();
    _charDescCtrl.dispose();
    _actionDescCtrl.dispose();
    super.dispose();
  }

  // ─── Image helpers ────────────────────────────────────────────────────────

  Future<(ReferenceImage, String)?> _pickImage() async {
    final picker = ImagePicker();
    final file   = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return null;

    final bytes = await FlutterImageCompress.compressWithFile(
      file.path, quality: 80,
    );
    if (bytes == null) return null;

    final ext     = file.path.toLowerCase();
    final mimeType = ext.endsWith('.png') ? MimeType.png : MimeType.jpeg;
    final b64      = base64Encode(bytes);

    return (ReferenceImage(imagePath: b64, mimeType: mimeType), b64);
  }

  Future<void> _pickSingleImage() async {
    final result = await _pickImage();
    if (result == null) return;
    setState(() {
      _singleImage        = result.$1;
      _singleImagePreview = result.$2;
    });
  }

  Future<void> _addMultiImage() async {
    final result = await _pickImage();
    if (result == null) return;
    setState(() {
      _multiImages.add(result.$1);
      _multiImagePreviews.add(result.$2);
    });
  }

  void _removeMultiImage(int index) {
    setState(() {
      _multiImages.removeAt(index);
      _multiImagePreviews.removeAt(index);
    });
  }

  // ─── Toast ────────────────────────────────────────────────────────────────

  void _toast(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        Icon(isError ? Icons.error_outline : Icons.info_outline, color: Colors.white, size: 18),
        const SizedBox(width: 10),
        Expanded(child: Text(msg, style: const TextStyle(color: Colors.white))),
      ]),
      backgroundColor: isError ? AppColor.alertError : AppColor.alertWarning,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    ));
  }

  // ─── Submit ───────────────────────────────────────────────────────────────

  Future<void> _submit(ProjectController ctrl) async {
    final mode = ctrl.state.mode;
    FocusScope.of(context).unfocus();

    // Validation
    if (mode.requiresPrompt && _promptCtrl.text.trim().isEmpty) {
      _toast('Please enter a prompt / description.');
      return;
    }
    if (mode == GenerationMode.styleChange && _singleImage == null) {
      _toast('Please select a reference image.');
      return;
    }
    if (mode == GenerationMode.upscale && _singleImage == null) {
      _toast('Please select an image to upscale.');
      return;
    }

    await ctrl.generate(
      mode:               mode,
      projectId:          widget.project.id!,
      splashDescription:  _promptCtrl.text.trim(),
      variationPrompt:    _promptCtrl.text.trim(),
      variationImages:    _multiImages,
      styleImage:         _singleImage,
      targetedStyle:      _targetStyle,
      additionalPrompts:  _additionalCtrl.text.trim(),
      characterDescription: _charDescCtrl.text.trim().isEmpty ? null : _charDescCtrl.text.trim(),
      actionDescription:  _actionDescCtrl.text.trim().isEmpty ? null : _actionDescCtrl.text.trim(),
      spriteImages:       _multiImages,
      upscaleImage:       _singleImage,
      upscaleFactor:      _upscaleFactor,
      videoPrompt:        _promptCtrl.text.trim(),
      videoReferenceImage: _multiImages.isNotEmpty ? _multiImages.first : null,
      videoLength:        _videoLength,
      numberOfOutputs:    _numberOfOutputs,
      onError: (msg) => _toast(msg, isError: true),
    );

    if (!mounted) return;

    // Video result
    final videoResult = ctrl.state.videoResult;
    if (videoResult != null && videoResult.videoUrl != null) {
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => GenerationResultPage(
          result: ImageResponseDto(imageUrls: [], updatedInstruction: videoResult.updatedInstruction),
          videoUrl: videoResult.videoUrl,
          mode: mode,
          projectId: widget.project.id!,
          homeController: context.read<HomeController>(),
        ),
      ));
      ctrl.clearResult();
      return;
    }

    // Image result
    final result = ctrl.state.result;
    if (result != null && result.imageUrls != null && result.imageUrls!.isNotEmpty) {
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => GenerationResultPage(
          result: result,
          mode: mode,
          projectId: widget.project.id!,
          homeController: context.read<HomeController>(),
        ),
      ));
      ctrl.clearResult();
    }
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectController, ProjectState>(
      builder: (context, state) {
        final ctrl = context.read<ProjectController>();
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              const LavaBackground(),
              Column(
                children: [
                  _buildAppBar(context, state),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
                      child: _buildForm(state),
                    ),
                  ),
                ],
              ),
              // Bottom mode bar
              Positioned(
                left: 0, right: 0, bottom: 0,
                child: _buildModeBar(context, state, ctrl),
              ),
              // Full-screen loading overlay
              if (state.generating) _buildLoadingOverlay(),
            ],
          ),
        );
      },
    );
  }

  // ─── App Bar ──────────────────────────────────────────────────────────────

  Widget _buildAppBar(BuildContext context, ProjectState state) {
    final meta = ArtStyleHelper.of(widget.project.artStyle);
    return Container(
      padding: EdgeInsets.fromLTRB(4, MediaQuery.of(context).padding.top + 4, 16, 8),
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
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: meta.colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
            child: Icon(meta.icon, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.project.projectName ?? 'Project',
                  style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  meta.label,
                  style: GoogleFonts.inter(fontSize: 11, color: AppColor.spaceTextSecondary),
                ),
              ],
            ),
          ),
          _buildGenerateButton(context, state),
        ],
      ),
    );
  }

  Widget _buildGenerateButton(BuildContext context, ProjectState state) {
    return GestureDetector(
      onTap: state.generating ? null : () => _submit(context.read<ProjectController>()),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColor.gradientStart3, AppColor.gradientEnd3],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Generate', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  // ─── Mode bar ─────────────────────────────────────────────────────────────

  Widget _buildModeBar(BuildContext context, ProjectState state, ProjectController ctrl) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.spaceCard,
        border: const Border(top: BorderSide(color: AppColor.spaceBorder)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: GenerationMode.values.map((mode) {
              final selected = state.mode == mode;
              return Expanded(
                child: _ModeBarItem(
                  mode: mode,
                  selected: selected,
                  onTap: () {
                    if (selected) return;
                    ctrl.setMode(mode);
                    setState(() {
                      _singleImage = null;
                      _singleImagePreview = null;
                      _multiImages.clear();
                      _multiImagePreviews.clear();
                      _promptCtrl.clear();
                      _additionalCtrl.clear();
                      _charDescCtrl.clear();
                      _actionDescCtrl.clear();
                      _numberOfOutputs = 1;
                      _videoLength = VideoLength.medium;
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // ─── Dynamic Form ─────────────────────────────────────────────────────────

  Widget _buildForm(ProjectState state) {
    switch (state.mode) {
      case GenerationMode.splashArt:   return _buildSplashArtForm();
      case GenerationMode.variation:   return _buildVariationForm();
      case GenerationMode.styleChange: return _buildStyleChangeForm();
      case GenerationMode.spriteSheet: return _buildSpriteSheetForm();
      case GenerationMode.upscale:     return _buildUpscaleForm();
      case GenerationMode.video:       return _buildVideoForm();
    }
  }

  // ── Splash Art ────────────────────────────────────────────────────────────

  Widget _buildSplashArtForm() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _modeTitle('Splash Art', 'Describe your scene and the AI will paint it'),
      const SizedBox(height: 20),
      _fieldLabel('Description'),
      const SizedBox(height: 8),
      AppTextFormField(
        controller: _promptCtrl,
        hintText: 'A dragon soaring above a burning castle at sunset…',
        maxLines: 5, textCapitalization: TextCapitalization.sentences,
      ),
      const SizedBox(height: 24),
      _outputCountSelector(),
    ]);
  }

  // ── Variation ─────────────────────────────────────────────────────────────

  Widget _buildVariationForm() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _modeTitle('Variation', 'Generate new variations from a prompt or reference images'),
      const SizedBox(height: 20),
      _fieldLabel('Prompt'),
      const SizedBox(height: 8),
      AppTextFormField(
        controller: _promptCtrl,
        hintText: 'Describe what you want to create…',
        maxLines: 4, textCapitalization: TextCapitalization.sentences,
      ),
      const SizedBox(height: 20),
      _fieldLabel('Reference Images (optional)'),
      const SizedBox(height: 8),
      _buildMultiImagePicker(),
      const SizedBox(height: 24),
      _outputCountSelector(),
    ]);
  }

  // ── Style Change ──────────────────────────────────────────────────────────

  Widget _buildStyleChangeForm() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _modeTitle('Style Change', 'Transform an existing image into a new art style'),
      const SizedBox(height: 20),
      _fieldLabel('Reference Image'),
      const SizedBox(height: 8),
      _buildSingleImagePicker(),
      const SizedBox(height: 20),
      _fieldLabel('Target Art Style'),
      const SizedBox(height: 8),
      _buildStylePicker(),
      const SizedBox(height: 20),
      _fieldLabel('Additional Prompts (optional)'),
      const SizedBox(height: 8),
      AppTextFormField(
        controller: _additionalCtrl,
        hintText: 'Add any extra style guidance…',
        maxLines: 3, textCapitalization: TextCapitalization.sentences,
      ),
      const SizedBox(height: 24),
      _outputCountSelector(),
    ]);
  }

  // ── Sprite Sheet ──────────────────────────────────────────────────────────

  Widget _buildSpriteSheetForm() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _modeTitle('Sprite Sheet', 'Generate a character sprite sheet with multiple poses'),
      const SizedBox(height: 20),
      _fieldLabel('Character Description (optional)'),
      const SizedBox(height: 8),
      AppTextFormField(
        controller: _charDescCtrl,
        hintText: 'A knight in golden armour…',
        maxLines: 3, textCapitalization: TextCapitalization.sentences,
      ),
      const SizedBox(height: 20),
      _fieldLabel('Action Description (optional)'),
      const SizedBox(height: 8),
      AppTextFormField(
        controller: _actionDescCtrl,
        hintText: 'Walking, attacking, jumping…',
        maxLines: 3, textCapitalization: TextCapitalization.sentences,
      ),
      const SizedBox(height: 20),
      _fieldLabel('Reference Images (optional)'),
      const SizedBox(height: 8),
      _buildMultiImagePicker(),
      const SizedBox(height: 24),
      _outputCountSelector(),
    ]);
  }

  // ── Upscale ───────────────────────────────────────────────────────────────

  Widget _buildUpscaleForm() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _modeTitle('Upscale', 'Enhance and upscale an image to a higher resolution'),
      const SizedBox(height: 20),
      _fieldLabel('Image to Upscale'),
      const SizedBox(height: 8),
      _buildSingleImagePicker(),
      const SizedBox(height: 20),
      _fieldLabel('Upscale Factor'),
      const SizedBox(height: 8),
      _buildUpscaleFactorPicker(),
    ]);
  }

  // ── Video ──────────────────────────────────────────────────────────────────

  Widget _buildVideoForm() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _modeTitle('Video', 'Bring your scene to life with an AI-generated video clip'),
      const SizedBox(height: 20),
      _fieldLabel('Prompt'),
      const SizedBox(height: 8),
      AppTextFormField(
        controller: _promptCtrl,
        hintText: 'A warrior charging through a burning battlefield…',
        maxLines: 5,
        textCapitalization: TextCapitalization.sentences,
      ),
      const SizedBox(height: 20),
      _fieldLabel('Reference Image (optional)'),
      const SizedBox(height: 8),
      _buildSingleImagePicker(),
      const SizedBox(height: 24),
      _fieldLabel('Video Length'),
      const SizedBox(height: 12),
      _buildVideoLengthPicker(),
    ]);
  }

  Widget _buildVideoLengthPicker() {
    const lengths = [
      (VideoLength.short,  'Short',  '4s'),
      (VideoLength.medium, 'Medium', '6s'),
      (VideoLength.long,   'Long',   '8s'),
    ];
    return Row(
      children: lengths.map((e) => Expanded(
        child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: _VideoLengthCard(
            length:   e.$1,
            label:    e.$2,
            duration: e.$3,
            selected: _videoLength == e.$1,
            onTap: () => setState(() => _videoLength = e.$1),
          ),
        ),
      )).toList(),
    );
  }

  Widget _modeTitle(String title, String subtitle) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
      const SizedBox(height: 4),
      Text(subtitle, style: GoogleFonts.inter(fontSize: 13, color: AppColor.spaceTextSecondary, height: 1.4)),
    ]);
  }

  Widget _fieldLabel(String label) => Text(
    label,
    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColor.spaceTextPrimary, letterSpacing: 0.2),
  );

  // ── Single image picker ────────────────────────────────────────────────────

  Widget _buildSingleImagePicker() {
    if (_singleImagePreview != null) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppStyleConstant.mediumRounding),
            child: Image.memory(
              base64Decode(_singleImagePreview!),
              height: 200, width: double.infinity, fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 8, right: 8,
            child: GestureDetector(
              onTap: () => setState(() { _singleImage = null; _singleImagePreview = null; }),
              child: Container(
                width: 28, height: 28,
                decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                child: const Icon(Icons.close, size: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      );
    }
    return GestureDetector(
      onTap: _pickSingleImage,
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          color: AppColor.spaceCardHigh,
          borderRadius: BorderRadius.circular(AppStyleConstant.mediumRounding),
          border: Border.all(color: AppColor.spaceBorder, style: BorderStyle.solid),
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.add_photo_alternate_outlined, size: 36, color: AppColor.spaceTextSecondary),
          const SizedBox(height: 8),
          Text('Tap to select image', style: GoogleFonts.inter(fontSize: 13, color: AppColor.spaceTextSecondary)),
        ]),
      ),
    );
  }

  // ── Multi image picker ─────────────────────────────────────────────────────

  Widget _buildMultiImagePicker() {
    return Column(children: [
      if (_multiImagePreviews.isNotEmpty) ...[
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _multiImagePreviews.length + 1,
            itemBuilder: (_, i) {
              if (i == _multiImagePreviews.length) {
                // Add button
                return GestureDetector(
                  onTap: _addMultiImage,
                  child: Container(
                    width: 80, height: 80,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: AppColor.spaceCardHigh,
                      borderRadius: BorderRadius.circular(AppStyleConstant.smallRounding),
                      border: Border.all(color: AppColor.spaceBorder),
                    ),
                    child: const Icon(Icons.add_rounded, color: AppColor.spaceTextSecondary),
                  ),
                );
              }
              return Stack(
                children: [
                  Container(
                    width: 80, height: 80,
                    margin: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppStyleConstant.smallRounding),
                      child: Image.memory(base64Decode(_multiImagePreviews[i]), fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    top: 2, right: 10,
                    child: GestureDetector(
                      onTap: () => _removeMultiImage(i),
                      child: Container(
                        width: 20, height: 20,
                        decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                        child: const Icon(Icons.close, size: 12, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ] else ...[
        GestureDetector(
          onTap: _addMultiImage,
          child: Container(
            height: 90,
            decoration: BoxDecoration(
              color: AppColor.spaceCardHigh,
              borderRadius: BorderRadius.circular(AppStyleConstant.mediumRounding),
              border: Border.all(color: AppColor.spaceBorder),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.add_photo_alternate_outlined, size: 28, color: AppColor.spaceTextSecondary),
              const SizedBox(width: 8),
              Text('Add reference images', style: GoogleFonts.inter(fontSize: 13, color: AppColor.spaceTextSecondary)),
            ]),
          ),
        ),
      ],
    ]);
  }

  // ── Output count selector ──────────────────────────────────────────────────

  Widget _outputCountSelector() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        _fieldLabel('Number of Outputs'),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: AppColor.primaryBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text('$_numberOfOutputs', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700, color: AppColor.primary)),
        ),
      ]),
      const SizedBox(height: 12),
      Row(children: [
        for (final n in [1, 2, 3, 4]) ...[
          GestureDetector(
            onTap: () => setState(() => _numberOfOutputs = n),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 52, height: 44,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: _numberOfOutputs == n ? AppColor.primary : AppColor.spaceCardHigh,
                borderRadius: BorderRadius.circular(AppStyleConstant.smallRounding),
                border: Border.all(
                  color: _numberOfOutputs == n ? AppColor.primary : AppColor.spaceBorder,
                ),
              ),
              child: Center(
                child: Text('$n', style: GoogleFonts.inter(
                  fontSize: 16, fontWeight: FontWeight.w700,
                  color: _numberOfOutputs == n ? Colors.white : AppColor.spaceTextSecondary,
                )),
              ),
            ),
          ),
        ],
      ]),
    ]);
  }

  // ── Style picker ──────────────────────────────────────────────────────────

  Widget _buildStylePicker() {
    return Wrap(
      spacing: 8, runSpacing: 8,
      children: ArtStyle.values.map((style) {
        final meta = ArtStyleHelper.of(style);
        final selected = _targetStyle == style;
        return GestureDetector(
          onTap: () => setState(() => _targetStyle = style),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: selected ? AppColor.primaryBackground : AppColor.spaceCardHigh,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: selected ? AppColor.primary : AppColor.spaceBorder, width: selected ? 1.5 : 1),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(meta.icon, size: 14, color: selected ? AppColor.primary : AppColor.spaceTextSecondary),
              const SizedBox(width: 6),
              Text(meta.label, style: GoogleFonts.inter(
                fontSize: 12, fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? AppColor.primary : AppColor.spaceTextSecondary,
              )),
            ]),
          ),
        );
      }).toList(),
    );
  }

  // ── Upscale factor picker ──────────────────────────────────────────────────

  Widget _buildUpscaleFactorPicker() {
    const factors = [
      (UpscaleFactor.x2, '2×'), (UpscaleFactor.x4, '4×'),
      (UpscaleFactor.x6, '6×'), (UpscaleFactor.x8, '8×'), (UpscaleFactor.x10, '10×'),
    ];
    return Row(children: factors.map((e) {
      final selected = _upscaleFactor == e.$1;
      return GestureDetector(
        onTap: () => setState(() => _upscaleFactor = e.$1),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 56, height: 44,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: selected ? AppColor.primary : AppColor.spaceCardHigh,
            borderRadius: BorderRadius.circular(AppStyleConstant.smallRounding),
            border: Border.all(color: selected ? AppColor.primary : AppColor.spaceBorder),
          ),
          child: Center(child: Text(e.$2, style: GoogleFonts.inter(
            fontSize: 14, fontWeight: FontWeight.w700,
            color: selected ? Colors.white : AppColor.spaceTextSecondary,
          ))),
        ),
      );
    }).toList());
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
              // Animated gradient circle
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(seconds: 2),
                builder: (_, t, child) => Transform.rotate(
                  angle: t * 6.28,
                  child: child,
                ),
                child: Container(
                  width: 72, height: 72,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppColor.gradientStart3, AppColor.gradientEnd3, AppColor.gradientStart5],
                      begin: Alignment.topLeft, end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Center(child: Icon(Icons.auto_awesome, size: 32, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Generating Art…',
                style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'The AI is working its magic.\nThis may take up to a minute.',
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
}

// ─── Video Length Card ─────────────────────────────────────────────────────────

class _VideoLengthCard extends StatefulWidget {
  const _VideoLengthCard({
    required this.length,
    required this.label,
    required this.duration,
    required this.selected,
    required this.onTap,
  });

  final VideoLength  length;
  final String       label;
  final String       duration;
  final bool         selected;
  final VoidCallback onTap;

  @override
  State<_VideoLengthCard> createState() => _VideoLengthCardState();
}

class _VideoLengthCardState extends State<_VideoLengthCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double>   _glow;

  static const _colors = [Color(0xFFFF6B6B), Color(0xFFFFE66D)];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _glow = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    if (widget.selected) _ctrl.forward();
  }

  @override
  void didUpdateWidget(_VideoLengthCard old) {
    super.didUpdateWidget(old);
    if (widget.selected != old.selected) {
      widget.selected ? _ctrl.forward() : _ctrl.reverse();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) {
          final t = _glow.value;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppStyleConstant.mediumRounding),
              // Blend from flat card to gradient by layering opacity
              color: Color.lerp(AppColor.spaceCardHigh, Colors.transparent, t),
              gradient: t > 0
                  ? LinearGradient(
                      colors: [
                        Color.lerp(AppColor.spaceCardHigh, _colors[0], t)!,
                        Color.lerp(AppColor.spaceCardHigh, _colors[1], t)!,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              border: Border.all(
                color: Color.lerp(AppColor.spaceBorder, _colors[0], t)!,
                width: 1.0 + 0.5 * t,
              ),
              boxShadow: [
                BoxShadow(
                  color: _colors[0].withValues(alpha: 0.4 * t),
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(
                widget.label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.lerp(FontWeight.w500, FontWeight.w700, t),
                  color: Color.lerp(AppColor.spaceTextPrimary, Colors.white, t),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.duration,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: Color.lerp(
                    AppColor.spaceTextSecondary,
                    Colors.white.withValues(alpha: 0.75),
                    t,
                  ),
                ),
              ),
            ]),
          );
        },
      ),
    );
  }
}

// ─── Mode Bar Item ─────────────────────────────────────────────────────────────

class _ModeBarItem extends StatefulWidget {
  const _ModeBarItem({
    required this.mode,
    required this.selected,
    required this.onTap,
  });

  final GenerationMode mode;
  final bool           selected;
  final VoidCallback   onTap;

  @override
  State<_ModeBarItem> createState() => _ModeBarItemState();
}

class _ModeBarItemState extends State<_ModeBarItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double>   _scale;
  late final Animation<double>   _iconScale;
  late final Animation<double>   _glow;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _scale = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack),
    );
    _iconScale = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack),
    );
    _glow = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    if (widget.selected) _ctrl.forward();
  }

  @override
  void didUpdateWidget(_ModeBarItem old) {
    super.didUpdateWidget(old);
    if (widget.selected != old.selected) {
      if (widget.selected) {
        _ctrl.forward();
      } else {
        _ctrl.reverse();
      }
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = widget.mode.gradientColors;

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon container — only this scales up
                Transform.scale(
                  scale: _scale.value,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          colors[0].withValues(alpha: 0.12 + 0.58 * _glow.value),
                          colors[1].withValues(alpha: 0.12 + 0.58 * _glow.value),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: colors[0].withValues(alpha: 0.18 + 0.62 * _glow.value),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colors[0].withValues(alpha: 0.5 * _glow.value),
                          blurRadius: 12,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Transform.scale(
                      scale: _iconScale.value,
                      child: Icon(
                        widget.mode.icon,
                        size: 16,
                        color: Color.lerp(
                          AppColor.spaceTextSecondary,
                          Colors.white,
                          _glow.value,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                // Label — fixed size, no scaling
                Text(
                  widget.mode.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.lerp(
                      FontWeight.w400,
                      FontWeight.w700,
                      _glow.value,
                    ),
                    color: Color.lerp(
                      AppColor.spaceTextSecondary,
                      colors[0],
                      _glow.value,
                    ),
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
