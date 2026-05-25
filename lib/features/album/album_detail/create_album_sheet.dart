import '../../../packages/index.dart';
import '../../home/home_controller.dart';
import '../../home/home_state.dart';

class CreateAlbumSheet extends StatelessWidget {
  const CreateAlbumSheet({super.key});

  static Future<void> show(BuildContext context) {
    final homeCtrl = context.read<HomeController>();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: homeCtrl,
        child: const CreateAlbumSheet(),
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
        child: BlocBuilder<HomeController, HomeState>(
          builder: (context, state) => _CreateAlbumBody(
            scrollController: scrollController,
            gallery: state.gallery,
            isGalleryLoading: state.galleryLoading,
          ),
        ),
      ),
    );
  }
}

class _CreateAlbumBody extends StatefulWidget {
  const _CreateAlbumBody({
    required this.scrollController,
    required this.gallery,
    required this.isGalleryLoading,
  });

  final ScrollController scrollController;
  final List<MediaDto> gallery;
  final bool isGalleryLoading;

  @override
  State<_CreateAlbumBody> createState() => _CreateAlbumBodyState();
}

class _CreateAlbumBodyState extends State<_CreateAlbumBody> {
  final _nameController = TextEditingController();
  final Set<int> _selectedIds = {};
  bool _submitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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

    if (_nameController.text.trim().isEmpty) {
      _showToast('Please enter an album name.');
      return;
    }

    setState(() => _submitting = true);

    await context.read<HomeController>().createAlbum(
      name: _nameController.text.trim(),
      mediaIds: _selectedIds.toList(),
      onError: (msg) {
        if (mounted) _showToast(msg, isError: true);
      },
    );

    if (mounted) Navigator.of(context).pop();
  }

  void _toggle(int id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Container(
      color: AppColor.spaceCard,
      child: Column(
        children: [
          _buildHeader(context),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: AppTextFormField(
              controller: _nameController,
              hintText: 'e.g. Concept Art, Portraits…',
              labelText: 'Album Name',
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              maxLength: 60,
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Row(
              children: [
                Text(
                  'Select Images',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColor.spaceTextPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                if (_selectedIds.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColor.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${_selectedIds.length} selected',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                const Spacer(),
                if (widget.gallery.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_selectedIds.length == widget.gallery.length) {
                          _selectedIds.clear();
                        } else {
                          _selectedIds.addAll(
                            widget.gallery
                                .map((m) => m.id)
                                .whereType<int>(),
                          );
                        }
                      });
                    },
                    child: Text(
                      _selectedIds.length == widget.gallery.length
                          ? 'Deselect All'
                          : 'Select All',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColor.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColor.spaceBorder),

          Expanded(child: _buildGrid()),

          Container(
            padding: EdgeInsets.fromLTRB(
                20, 12, 20, bottomInset + bottomPadding + 16),
            decoration: BoxDecoration(
              color: AppColor.spaceCard,
              border: Border(top: BorderSide(color: AppColor.spaceBorder)),
            ),
            child: AppFilledButton(
              onPressed: _submitting ? null : _submit,
              width: double.infinity,
              child: _submitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : Text(
                      _selectedIds.isEmpty
                          ? 'Create Empty Album'
                          : 'Create Album with ${_selectedIds.length} image${_selectedIds.length != 1 ? 's' : ''}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 8, 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColor.spaceBorder)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColor.primaryBackground,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.create_new_folder_outlined,
                size: 18, color: AppColor.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New Album',
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColor.spaceTextPrimary,
                  ),
                ),
                Text(
                  'Name your album and pick images to include',
                  style: GoogleFonts.inter(
                      fontSize: 12, color: AppColor.spaceTextSecondary),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close_rounded,
                size: 22, color: AppColor.spaceTextSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    if (widget.isGalleryLoading && widget.gallery.isEmpty) {
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

    if (widget.gallery.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.photo_library_outlined,
                  size: 48, color: AppColor.spaceTextSecondary),
              const SizedBox(height: 12),
              Text(
                'No images in your gallery yet.',
                style: GoogleFonts.inter(
                    fontSize: 14, color: AppColor.spaceTextSecondary),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      controller: widget.scrollController,
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: widget.gallery.length,
      itemBuilder: (context, i) {
        final item = widget.gallery[i];
        final id = item.id ?? 0;
        final isSelected = _selectedIds.contains(id);

        return GestureDetector(
          onTap: () => _toggle(id),
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(AppStyleConstant.smallRounding),
            child: Stack(
              fit: StackFit.expand,
              children: [
                item.mediaUrl != null
                    ? AppImage(
                        asset: item.mediaUrl!, fit: BoxFit.cover)
                    : Container(color: AppColor.spaceCardHigh),

                AnimatedOpacity(
                  duration: const Duration(milliseconds: 150),
                  opacity: isSelected ? 1.0 : 0.0,
                  child: Container(
                    color: AppColor.primary.withValues(alpha: 0.35),
                  ),
                ),

                Positioned(
                  top: 6,
                  right: 6,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColor.primary
                          : Colors.black.withValues(alpha: 0.35),
                      border: Border.all(
                        color: isSelected
                            ? AppColor.primary
                            : Colors.white.withValues(alpha: 0.7),
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check,
                            size: 14, color: Colors.white)
                        : null,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

