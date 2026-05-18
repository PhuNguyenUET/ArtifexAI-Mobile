import '../../packages/app_core/utils/art_style_helper.dart';
import '../../packages/index.dart';
import '../home/home_controller.dart';

class CreateProjectSheet extends StatelessWidget {
  const CreateProjectSheet({super.key});

  static Future<void> show(BuildContext context) {
    final homeCtrl = context.read<HomeController>();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: homeCtrl,
        child: const CreateProjectSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.6,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollController) => ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppStyleConstant.sheetTopBorderRadius),
        ),
        child: _CreateProjectBody(scrollController: scrollController),
      ),
    );
  }
}

class _CreateProjectBody extends StatefulWidget {
  const _CreateProjectBody({required this.scrollController});
  final ScrollController scrollController;

  @override
  State<_CreateProjectBody> createState() => _CreateProjectBodyState();
}

class _CreateProjectBodyState extends State<_CreateProjectBody> {
  final _nameCtrl = TextEditingController();
  final _instrCtrl = TextEditingController();

  ArtStyle _selectedStyle = ArtStyle.pixelated;
  final List<String> _instructions = [];

  bool _submitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _instrCtrl.dispose();
    super.dispose();
  }

  void _addInstruction() {
    final text = _instrCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _instructions.add(text);
      _instrCtrl.clear();
    });
  }

  void _removeInstruction(int index) {
    setState(() => _instructions.removeAt(index));
  }

  void _showToast(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.info_outline,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor:
            isError ? AppColor.alertError : AppColor.alertWarning,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (_nameCtrl.text.trim().isEmpty) {
      _showToast('Please enter a project name.');
      return;
    }

    if (_instructions.isEmpty) {
      _showToast('Please add at least one instruction for the AI.');
      return;
    }

    setState(() => _submitting = true);

    await context.read<HomeController>().createProject(
      projectName: _nameCtrl.text.trim(),
      artStyle: _selectedStyle,
      instructions: _instructions,
      onError: (msg) {
        if (mounted) _showToast(msg, isError: true);
      },
    );

    if (!mounted) return;
    setState(() => _submitting = false);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Stack(
      children: [
        Container(
          color: AppColor.spaceCard,
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: ListView(
                    controller: widget.scrollController,
                    padding: EdgeInsets.fromLTRB(20, 4, 20, bottomInset + 16),
                    children: [
                      _buildNameField(),
                      const SizedBox(height: 20),
                      _buildStylePicker(),
                      const SizedBox(height: 20),
                      _buildInstructionsSection(),
                      const SizedBox(height: 24),
                    ],
                  ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 12, 20, bottomPadding + 16),
                decoration: BoxDecoration(
                  color: AppColor.spaceCard,
                  border: Border(top: BorderSide(color: AppColor.spaceBorder)),
                ),
                child: AppFilledButton(
                  onPressed: _submitting ? null : _submit,
                  width: double.infinity,
                  child: Text(
                    'Create Project',
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),

        if (_submitting) _buildProcessingOverlay(),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 8, 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColor.spaceBorder)),
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: const BoxDecoration(color: AppColor.primaryBackground, shape: BoxShape.circle),
            child: const Icon(Icons.auto_awesome, size: 18, color: AppColor.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('New Project', style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700, color: AppColor.spaceTextPrimary)),
                Text('Give your AI a name, style and guidelines', style: GoogleFonts.inter(fontSize: 12, color: AppColor.spaceTextSecondary)),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close_rounded, size: 22, color: AppColor.spaceTextSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Project Name'),
        const SizedBox(height: 10),
          AppTextFormField(
          controller: _nameCtrl,
          hintText: 'e.g. Fantasy RPG, Sci-Fi Shooter…',
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          maxLength: 80,
        ),
      ],
    );
  }

  Widget _buildStylePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Art Style'),
        const SizedBox(height: 4),
        Text('Choose the default visual style for AI generations in this project',
            style: GoogleFonts.inter(fontSize: 12, color: AppColor.spaceTextSecondary)),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 3.2),
          itemCount: ArtStyleHelper.all.length,
          itemBuilder: (_, i) {
            final entry = ArtStyleHelper.all[i];
            final style = entry.key;
            final meta = entry.value;
            final isSelected = _selectedStyle == style;
            return GestureDetector(
              onTap: () => setState(() => _selectedStyle = style),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppStyleConstant.mediumRounding),
                  border: Border.all(
                      color: isSelected ? AppColor.primary : AppColor.spaceBorder,
                      width: isSelected ? 2 : 1),
                  color: isSelected ? AppColor.primaryBackground : AppColor.spaceCardHigh,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: meta.colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
                      ),
                      child: Icon(meta.icon, size: 14, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(meta.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              color: isSelected ? AppColor.primary : AppColor.spaceTextPrimary)),
                    ),
                    if (isSelected) const Icon(Icons.check_circle, size: 14, color: AppColor.primary),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildInstructionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('AI Instructions'),
        const SizedBox(height: 4),
        Text('Add guidelines the AI will follow when generating art for this project',
            style: GoogleFonts.inter(fontSize: 12, color: AppColor.spaceTextSecondary)),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: AppTextFormField(
                controller: _instrCtrl,
                hintText: 'e.g. Use dark fantasy tones…',
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
                maxLines: 3,
                onFieldSubmitted: (_) => _addInstruction(),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _addInstruction,
              child: Container(
                width: 44, height: 44,
                decoration: BoxDecoration(color: AppColor.primary, borderRadius: BorderRadius.circular(AppStyleConstant.mediumRounding)),
                child: const Icon(Icons.add_rounded, color: Colors.white, size: 22),
              ),
            ),
          ],
        ),
        if (_instructions.isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColor.spaceCardHigh,
              borderRadius: BorderRadius.circular(AppStyleConstant.mediumRounding),
              border: Border.all(color: AppColor.spaceBorder),
            ),
            child: Column(
              children: _instructions.indexed.map((entry) {
                final i = entry.$1;
                final instr = entry.$2;
                final isLast = i == _instructions.length - 1;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 20, height: 20,
                            margin: const EdgeInsets.only(top: 1),
                            decoration: const BoxDecoration(color: AppColor.primaryBackground, shape: BoxShape.circle),
                            child: Center(
                              child: Text('${i + 1}',
                                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: AppColor.primary)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(instr,
                                style: GoogleFonts.inter(fontSize: 13, color: AppColor.spaceTextPrimary, height: 1.4)),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => _removeInstruction(i),
                            child: Icon(Icons.close, size: 16, color: AppColor.spaceTextSecondary),
                          ),
                        ],
                      ),
                    ),
                    if (!isLast) const Divider(height: 1, indent: 44, color: AppColor.spaceBorder),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 6),
          Text('${_instructions.length} instruction${_instructions.length != 1 ? 's' : ''} added',
              style: GoogleFonts.inter(fontSize: 11, color: AppColor.spaceTextSecondary)),
        ],
      ],
    );
  }

  Widget _buildProcessingOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.70),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 48),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
            decoration: BoxDecoration(
              color: AppColor.spaceCardHigh,
              borderRadius: BorderRadius.circular(AppStyleConstant.largeRounding),
              border: Border.all(color: AppColor.spaceBorder),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64, height: 64,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        colors: [AppColor.gradientStart3, AppColor.gradientEnd3],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                  ),
                  child: const Center(child: Icon(Icons.auto_awesome, size: 30, color: Colors.white)),
                ),
                const SizedBox(height: 20),
                Text('Creating Your Project',
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: AppColor.spaceTextPrimary)),
                const SizedBox(height: 8),
                Text('Setting up your AI workspace…',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(fontSize: 13, color: AppColor.spaceTextSecondary)),
                const SizedBox(height: 24),
                const LinearProgressIndicator(color: AppColor.primary, backgroundColor: AppColor.spaceBorder),
                const SizedBox(height: 8),
                Text('This may take a moment',
                    style: GoogleFonts.inter(fontSize: 11, color: AppColor.spaceTextSecondary)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(
        text,
        style: GoogleFonts.inter(
            fontSize: 13, fontWeight: FontWeight.w600, color: AppColor.spaceTextPrimary, letterSpacing: 0.3),
      );
}

