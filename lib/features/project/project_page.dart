import 'dart:convert';
import 'package:marquee/marquee.dart';
import '../../init/access_token_storage.dart';
import '../../init/sl.dart';
import '../../packages/app_core/utils/art_style_helper.dart';
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
  void initState() {
    super.initState();
    // Seed the cubit with the instructions already on the project DTO.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectController>().loadInstructions(
            widget.project.instructions ?? [],
          );
    });
  }

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

    final ext      = file.path.toLowerCase();
    final mimeType = ext.endsWith('.png') ? MimeType.png : MimeType.jpeg;
    final b64      = base64Encode(bytes);

    // Upload to server and get back the MediaDto with the server-side path.
    final mediaDto = await sl.get<AccessTokenStorage>().repository
        .uploadClient(base64: b64, mimeType: mimeType);

    return (
      ReferenceImage(imagePath: mediaDto.mediaPath, mimeType: mimeType),
      b64, // local base64 kept only for preview display
    );
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
    // When no images remain, non-GPT/Gemini models become locked → reset to GPT.
    if (_multiImages.isEmpty) {
      final ctrl = context.read<ProjectController>();
      final m = ctrl.state.generationModel;
      if (m != GenerationModel.gpt && m != GenerationModel.gemini) {
        ctrl.setGenerationModel(GenerationModel.gpt);
      }
    }
  }

  /// Clears the single reference image and resets the model to GPT if a
  /// model that requires an image is selected.
  void _clearSingleImage() {
    setState(() {
      _singleImage = null;
      _singleImagePreview = null;
    });
    final ctrl = context.read<ProjectController>();
    final m = ctrl.state.generationModel;
    if (m != GenerationModel.gpt && m != GenerationModel.gemini) {
      ctrl.setGenerationModel(GenerationModel.gpt);
    }
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
    final genModel = ctrl.state.generationModel;
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
    // GPT and Gemini variation are text-optional. Flux-2 / Qwen variation is
    // strictly image-to-image — the API will reject requests without an image.
    if (mode == GenerationMode.variation &&
        _multiImages.isEmpty &&
        genModel != GenerationModel.gemini &&
        genModel != GenerationModel.gpt) {
      _toast('${genModel.displayName} requires at least one reference image for Variation.',
          isError: true);
      return;
    }
    if (mode == GenerationMode.spriteSheet && _charDescCtrl.text.trim().isEmpty) {
      _toast('Please enter a character description.');
      return;
    }
    if (mode == GenerationMode.spriteSheet && _actionDescCtrl.text.trim().isEmpty) {
      _toast('Please enter an action description.');
      return;
    }
    if (mode == GenerationMode.upscale && _singleImage == null) {
      _toast('Please select an image to upscale.');
      return;
    }

    // ── Model × image safety net ─────────────────────────────────────────────
    // Flux-2 and Qwen are image-to-image only for variation / sprite / style.
    // The UI already locks them, but guard here in case of any bypass.
    if (genModel != GenerationModel.gemini && genModel != GenerationModel.gpt) {
      final bool missingImage;
      switch (mode) {
        case GenerationMode.variation:
          missingImage = _multiImages.isEmpty;
          break;
        case GenerationMode.spriteSheet:
          missingImage = _multiImages.isEmpty;
          break;
        case GenerationMode.styleChange:
          missingImage = _singleImage == null;
          break;
        default:
          missingImage = false;
      }
      if (missingImage) {
        _toast(
          '${genModel.displayName} requires a reference image. '
          'Add one or switch to GPT-Image-2.',
          isError: true,
        );
        return;
      }
    }

    await ctrl.generate(
      mode:               mode,
      projectId:          widget.project.id!,
      generationModel:    genModel,
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
      videoReferenceImage: _singleImage,
      videoLength:        _videoLength,
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
    } else if (ctrl.state.error == null && !ctrl.state.generating) {
      _toast('Something went wrong. Please try again later.', isError: true);
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
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 20,
                  child: Marquee(
                    text: widget.project.projectName ?? 'Project',
                    style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                    scrollAxis: Axis.horizontal,
                    velocity: 30,
                    blankSpace: 48,
                    pauseAfterRound: const Duration(seconds: 2),
                    startAfter: const Duration(seconds: 1),
                    fadingEdgeStartFraction: 0.05,
                    fadingEdgeEndFraction: 0.05,
                  ),
                ),
                Text(
                  meta.label,
                  style: GoogleFonts.inter(
                      fontSize: 11, color: AppColor.spaceTextSecondary),
                ),
              ],
            ),
          ),
          // Instructions button
          _buildInstructionsButton(context, state),
          const SizedBox(width: 8),
          _buildGenerateButton(context, state),
        ],
      ),
    );
  }

  Widget _buildInstructionsButton(BuildContext context, ProjectState state) {
    return Tooltip(
      message: 'Instructions',
      child: GestureDetector(
        onTap: () {
          final ctrl = context.read<ProjectController>();
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => BlocProvider.value(
              value: ctrl,
              child: _InstructionsSheet(projectId: widget.project.id!),
            ),
          );
        },
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColor.spaceCardHigh,
            shape: BoxShape.circle,
            border: Border.all(color: AppColor.spaceBorder),
          ),
          child: const Icon(Icons.menu_book_rounded, size: 18, color: Colors.white),
        ),
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
                    // Clearing images → Flux-2/Qwen require images → reset to GPT.
                    if (ctrl.state.generationModel != GenerationModel.gemini &&
                        ctrl.state.generationModel != GenerationModel.gpt) {
                      ctrl.setGenerationModel(GenerationModel.gpt);
                    }
                    setState(() {
                      _singleImage = null;
                      _singleImagePreview = null;
                      _multiImages.clear();
                      _multiImagePreviews.clear();
                      _promptCtrl.clear();
                      _additionalCtrl.clear();
                      _charDescCtrl.clear();
                      _actionDescCtrl.clear();
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
    return BlocBuilder<ProjectController, ProjectState>(
      builder: (context, state) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _modeTitle('Splash Art', 'Describe your scene and the AI will paint it'),
        const SizedBox(height: 20),
        _ModelSelector(
          mode: GenerationMode.splashArt,
          selected: state.generationModel,
          hasReferenceImage: false,
          onChanged: (m) => context.read<ProjectController>().setGenerationModel(m),
        ),
        const SizedBox(height: 20),
        _fieldLabel('Description'),
        const SizedBox(height: 8),
        AppTextFormField(
          controller: _promptCtrl,
          hintText: 'A dragon soaring above a burning castle at sunset…',
          maxLines: 5, textCapitalization: TextCapitalization.sentences,
        ),
      ]),
    );
  }

  // ── Variation ─────────────────────────────────────────────────────────────

  Widget _buildVariationForm() {
    return BlocBuilder<ProjectController, ProjectState>(
      builder: (context, state) {
        final isLlmModel = state.generationModel == GenerationModel.gemini ||
            state.generationModel == GenerationModel.gpt;
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _modeTitle('Variation', 'Generate new variations from a prompt or reference images'),
          const SizedBox(height: 20),
          _ModelSelector(
            mode: GenerationMode.variation,
            selected: state.generationModel,
            hasReferenceImage: _multiImages.isNotEmpty,
            onChanged: (m) => context.read<ProjectController>().setGenerationModel(m),
          ),
          const SizedBox(height: 20),
          _fieldLabel('Prompt'),
          const SizedBox(height: 8),
          AppTextFormField(
            controller: _promptCtrl,
            hintText: 'Describe what you want to create…',
            maxLines: 4, textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _fieldLabel('Reference Images'),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: isLlmModel
                      ? AppColor.spaceCardHigh
                      : AppColor.primaryBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isLlmModel ? AppColor.spaceBorder : AppColor.primary,
                  ),
                ),
                child: Text(
                  isLlmModel ? 'optional' : 'required',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isLlmModel ? AppColor.spaceTextSecondary : AppColor.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildMultiImagePicker(),
        ]);
      },
    );
  }

  // ── Style Change ──────────────────────────────────────────────────────────

  Widget _buildStyleChangeForm() {
    return BlocBuilder<ProjectController, ProjectState>(
      builder: (context, state) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _modeTitle('Style Change', 'Transform an existing image into a new art style'),
        const SizedBox(height: 20),
        _ModelSelector(
          mode: GenerationMode.styleChange,
          selected: state.generationModel,
          hasReferenceImage: _singleImage != null,
          onChanged: (m) => context.read<ProjectController>().setGenerationModel(m),
        ),
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
      ]),
    );
  }

  // ── Sprite Sheet ──────────────────────────────────────────────────────────

  Widget _buildSpriteSheetForm() {
    return BlocBuilder<ProjectController, ProjectState>(
      builder: (context, state) {
        final imageRequired = state.generationModel == GenerationModel.qwen ||
            state.generationModel == GenerationModel.flux2;
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _modeTitle('Sprite Sheet', 'Generate a character sprite sheet with multiple poses'),
          const SizedBox(height: 20),
          _ModelSelector(
            mode: GenerationMode.spriteSheet,
            selected: state.generationModel,
            hasReferenceImage: _multiImages.isNotEmpty,
            onChanged: (m) => context.read<ProjectController>().setGenerationModel(m),
          ),
          const SizedBox(height: 20),
          _fieldLabel('Character Description'),
          const SizedBox(height: 8),
          AppTextFormField(
            controller: _charDescCtrl,
            hintText: 'A knight in golden armour…',
            maxLines: 3, textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 20),
          _fieldLabel('Action Description'),
          const SizedBox(height: 8),
          AppTextFormField(
            controller: _actionDescCtrl,
            hintText: 'Walking, attacking, jumping…',
            maxLines: 3, textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _fieldLabel('Reference Images'),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: imageRequired
                      ? AppColor.primaryBackground
                      : AppColor.spaceCardHigh,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: imageRequired ? AppColor.primary : AppColor.spaceBorder,
                  ),
                ),
                child: Text(
                  imageRequired ? 'required' : 'optional',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: imageRequired
                        ? AppColor.primary
                        : AppColor.spaceTextSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildMultiImagePicker(),
        ]);
      },
    );
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
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned(
            top: 8, right: 8,
            child: GestureDetector(
              onTap: _clearSingleImage,
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
    return BlocBuilder<ProjectController, ProjectState>(
      builder: (context, state) {
        final model = state.generationModel;
        final String title;
        final String subtitle;
        switch (model) {
          case GenerationModel.gpt:
            title = 'Generating with ChatGPT…';
            subtitle = 'GPT-Image-2 is crafting your image.\nThis may take a moment.';
            break;
          case GenerationModel.gemini:
            title = 'Generating with Gemini…';
            subtitle = 'The AI is working its magic.\nThis may take up to a minute.';
            break;
          case GenerationModel.flux2:
            title = 'Generating with Flux-2…';
            subtitle = 'This may take a moment while the model renders.';
            break;
          case GenerationModel.qwen:
            title = 'Generating with Qwen…';
            subtitle = 'This may take a moment while the model renders.';
            break;
        }
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
                    title,
                    style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
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
      },
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

// ─── Instructions Sheet ────────────────────────────────────────────────────────

class _InstructionsSheet extends StatefulWidget {
  const _InstructionsSheet({required this.projectId});
  final int projectId;

  @override
  State<_InstructionsSheet> createState() => _InstructionsSheetState();
}

class _InstructionsSheetState extends State<_InstructionsSheet> {
  bool _editMode = false;
  final _addCtrl = TextEditingController();
  final _addFocus = FocusNode();

  @override
  void dispose() {
    _addCtrl.dispose();
    _addFocus.dispose();
    super.dispose();
  }

  void _toast(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(children: [
        Icon(isError ? Icons.error_outline : Icons.info_outline,
            color: Colors.white, size: 18),
        const SizedBox(width: 10),
        Expanded(child: Text(msg, style: const TextStyle(color: Colors.white))),
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

  Future<void> _submitAdd(ProjectController ctrl) async {
    final text = _addCtrl.text.trim();
    if (text.isEmpty) return;
    _addFocus.unfocus();
    await ctrl.addInstruction(
      projectId: widget.projectId,
      newInstruction: text,
      onError: (msg) => _toast(msg, isError: true),
    );
    if (!mounted) return;
    if (!ctrl.state.addingInstruction) {
      _addCtrl.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectController, ProjectState>(
      builder: (context, state) {
        final ctrl = context.read<ProjectController>();
        final instructions = state.instructions;
        final isAdding = state.addingInstruction;
        final isUpdating = state.updatingInstructions;

        return Container(
          decoration: const BoxDecoration(
            color: AppColor.spaceCard,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Drag handle ─────────────────────────────────────────────
              const SizedBox(height: 12),
              Container(
                width: 38, height: 4,
                decoration: BoxDecoration(
                  color: AppColor.spaceBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),

              // ── Header ──────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      width: 34, height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEE85FF), Color(0xFF89B8FF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Icon(Icons.menu_book_rounded,
                          size: 17, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Instructions',
                        style: GoogleFonts.inter(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (instructions.isNotEmpty) ...[
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: isUpdating
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColor.primary,
                                ),
                              )
                            : GestureDetector(
                                key: ValueKey(_editMode),
                                onTap: () =>
                                    setState(() => _editMode = !_editMode),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 7),
                                  decoration: BoxDecoration(
                                    color: _editMode
                                        ? AppColor.primaryBackground
                                        : AppColor.spaceCardHigh,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: _editMode
                                          ? AppColor.primary
                                          : AppColor.spaceBorder,
                                    ),
                                  ),
                                  child: Text(
                                    _editMode ? 'Done' : 'Edit',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: _editMode
                                          ? AppColor.primary
                                          : AppColor.spaceTextPrimary,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 4),
              const Divider(color: AppColor.spaceBorder, thickness: 1, height: 24),

              // ── Instruction list ────────────────────────────────────────
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.38,
                ),
                child: instructions.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.auto_awesome_outlined,
                                size: 36,
                                color: AppColor.spaceTextSecondary
                                    .withValues(alpha: 0.5)),
                            const SizedBox(height: 12),
                            Text(
                              'No instructions yet',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColor.spaceTextSecondary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Add your first instruction below and the AI will remember\nyour preferences across all generations.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColor.spaceTextSecondary
                                    .withValues(alpha: 0.7),
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: instructions.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 8),
                        itemBuilder: (_, i) {
                          return _InstructionItem(
                            index: i,
                            text: instructions[i],
                            editMode: _editMode,
                            deleting: isUpdating,
                            onDelete: () => ctrl.deleteInstruction(
                              projectId: widget.projectId,
                              index: i,
                              onError: (msg) =>
                                  _toast(msg, isError: true),
                            ),
                          );
                        },
                      ),
              ),

              const SizedBox(height: 8),
              const Divider(color: AppColor.spaceBorder, thickness: 1, height: 1),
              const SizedBox(height: 12),

              // ── Add instruction field ────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _InstructionAddField(
                  controller: _addCtrl,
                  focusNode: _addFocus,
                  isAdding: isAdding,
                  onSubmit: () => _submitAdd(ctrl),
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        );
      },
    );
  }
}

// ─── Instruction Item ──────────────────────────────────────────────────────────

class _InstructionItem extends StatelessWidget {
  const _InstructionItem({
    required this.index,
    required this.text,
    required this.editMode,
    required this.deleting,
    required this.onDelete,
  });

  final int         index;
  final String      text;
  final bool        editMode;
  final bool        deleting;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColor.spaceCardHigh,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: editMode
              ? AppColor.alertError.withValues(alpha: 0.35)
              : AppColor.spaceBorder,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Index bubble
          Container(
            width: 22, height: 22,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFFEE85FF), Color(0xFF89B8FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColor.spaceTextPrimary,
                height: 1.45,
              ),
            ),
          ),
          // Delete button – only in edit mode
          if (editMode) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: deleting ? null : onDelete,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 28, height: 28,
                decoration: BoxDecoration(
                  color: AppColor.alertError.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColor.alertError.withValues(alpha: 0.4),
                  ),
                ),
                child: Icon(
                  Icons.delete_outline_rounded,
                  size: 14,
                  color: AppColor.alertError,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Add-field with shimmer when AI is running ─────────────────────────────────

class _InstructionAddField extends StatefulWidget {
  const _InstructionAddField({
    required this.controller,
    required this.focusNode,
    required this.isAdding,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final FocusNode             focusNode;
  final bool                  isAdding;
  final VoidCallback          onSubmit;

  @override
  State<_InstructionAddField> createState() => _InstructionAddFieldState();
}

class _InstructionAddFieldState extends State<_InstructionAddField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerCtrl;
  late final Animation<double>   _shimmer;

  @override
  void initState() {
    super.initState();
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _shimmer = Tween<double>(begin: -1.5, end: 2.5).animate(
      CurvedAnimation(parent: _shimmerCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(_InstructionAddField old) {
    super.didUpdateWidget(old);
    if (widget.isAdding && !old.isAdding) {
      _shimmerCtrl.repeat();
    } else if (!widget.isAdding && old.isAdding) {
      _shimmerCtrl.stop();
      _shimmerCtrl.reset();
    }
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    super.dispose();
  }

  // ─── Suffix icon: arrow or spinner ────────────────────────────────────────
  Widget _buildSuffix() {
    if (widget.isAdding) {
      return Padding(
        padding: const EdgeInsets.only(right: 12),
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColor.primary,
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: widget.onSubmit,
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFEE85FF), Color(0xFF89B8FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Icon(
            Icons.arrow_forward_rounded,
            size: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final field = AppTextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      hintText: 'Add an instruction for the AI…',
      maxLines: 3,
      textCapitalization: TextCapitalization.sentences,
      enabled: !widget.isAdding,
      suffixIcon: _buildSuffix(),
    );

    if (!widget.isAdding) return field;

    // Wrap in shimmer overlay while AI is processing
    return AnimatedBuilder(
      animation: _shimmer,
      builder: (_, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: const [
              Colors.transparent,
              Color(0x55EE85FF),
              Color(0x88B8AAFF),
              Color(0x5589B8FF),
              Colors.transparent,
            ],
            stops: [
              0.0,
              (_shimmer.value - 0.4).clamp(0.0, 1.0),
              _shimmer.value.clamp(0.0, 1.0),
              (_shimmer.value + 0.4).clamp(0.0, 1.0),
              1.0,
            ],
          ).createShader(bounds),
          child: child,
        );
      },
      child: field,
    );
  }
}

// ─── Model Selector ────────────────────────────────────────────────────────────

/// Displays a horizontal row of model option cards for the given [mode].
/// GPT-Image-2 is listed first and pre-selected by default.
class _ModelSelector extends StatelessWidget {
  const _ModelSelector({
    required this.mode,
    required this.selected,
    required this.hasReferenceImage,
    required this.onChanged,
  });

  final GenerationMode mode;
  final GenerationModel selected;
  final bool hasReferenceImage;
  final ValueChanged<GenerationModel> onChanged;

  static const _modelColors = {
    GenerationModel.gpt:     [Color(0xFF10A37F), Color(0xFF1A7F64)],
    GenerationModel.gemini:  [Color(0xFF4285F4), Color(0xFFEA4335)],
    GenerationModel.flux2:   [Color(0xFFFF6B35), Color(0xFFFFD93D)],
    GenerationModel.qwen:    [Color(0xFF11998E), Color(0xFF38EF7D)],
  };

  static const _modelIcons = {
    GenerationModel.gpt:     Icons.chat_rounded,
    GenerationModel.gemini:  Icons.auto_awesome_rounded,
    GenerationModel.flux2:   Icons.camera_rounded,
    GenerationModel.qwen:    Icons.psychology_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final models = GenerationModel.values.toList();

    // Non-GPT/Gemini models need a reference image for non-splash-art modes.
    final isLocked = (GenerationModel model) =>
        model != GenerationModel.gpt &&
        model != GenerationModel.gemini &&
        mode != GenerationMode.splashArt &&
        !hasReferenceImage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI Model',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColor.spaceTextPrimary,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 72,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: models.map((model) {
              final isSelected = selected == model;
              final colors = _modelColors[model]!;
              final icon = _modelIcons[model]!;

              // Flux-2 and Qwen are image-to-image only on image-based modes.
              // Lock them until the user adds a reference image.
              final locked = isLocked(model);

              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () {
                    if (locked) {
                      ScaffoldMessenger.of(context)
                        ..clearSnackBars()
                        ..showSnackBar(SnackBar(
                          content: Row(children: [
                            const Icon(Icons.lock_rounded,
                                color: Colors.white, size: 15),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Add a reference image to unlock ${model.displayName}.',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ]),
                          backgroundColor: const Color(0xFF2A2A3D),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          margin: const EdgeInsets.all(16),
                          duration: const Duration(seconds: 2),
                        ));
                      return;
                    }
                    onChanged(model);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    width: 116,
                    height: 72,
                    decoration: BoxDecoration(
                      color: locked
                          ? AppColor.spaceCard
                          : isSelected
                              ? AppColor.spaceCardHigh
                              : AppColor.spaceCard,
                      borderRadius:
                          BorderRadius.circular(AppStyleConstant.mediumRounding),
                      border: Border.all(
                        color: locked
                            ? AppColor.spaceBorder.withValues(alpha: 0.4)
                            : isSelected
                                ? colors.first
                                : AppColor.spaceBorder,
                        width: isSelected && !locked ? 1.5 : 1,
                      ),
                      boxShadow: isSelected && !locked
                          ? [
                              BoxShadow(
                                  color: colors.first.withValues(alpha: 0.25),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4))
                            ]
                          : null,
                    ),
                    child: Opacity(
                      opacity: locked ? 0.35 : 1.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                ShaderMask(
                                  shaderCallback: (b) => LinearGradient(
                                    colors: colors,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ).createShader(b),
                                  child:
                                      Icon(icon, size: 18, color: Colors.white),
                                ),
                                const Spacer(),
                                if (locked)
                                  const Icon(Icons.lock_rounded,
                                      size: 11,
                                      color: AppColor.spaceTextSecondary)
                                else if (isSelected)
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient:
                                          LinearGradient(colors: colors),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              model.displayName,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: isSelected && !locked
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSelected && !locked
                                    ? Colors.white
                                    : AppColor.spaceTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

