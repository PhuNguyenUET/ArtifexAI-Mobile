
import '../../generated/assets.dart';
import '../../init/routes.dart';
import '../../packages/app_core/utils/art_style_helper.dart';
import '../../packages/index.dart';
import '../album/album_detail/album_detail_page.dart';
import '../album/album_detail/create_album_sheet.dart';
import '../album/album_detail/gallery_page.dart';
import '../profile/edit_password_page.dart';
import '../profile/edit_profile_page.dart';
import '../profile/email_verification_page.dart';
import '../project/create_project_sheet.dart';
import '../project/project_page.dart';
import 'home_controller.dart';
import 'home_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late final HomeController _controller;
  late final PageController _pageController;
  HomeTab _previousTab = HomeTab.albums;
  bool _isProgrammaticScroll = false;
  bool _editMode = false;

  HomeController _createController(BuildContext context) {
    _controller = HomeController();
    return _controller;
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _tabIndex(_previousTab));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int _tabIndex(HomeTab tab) {
    switch (tab) {
      case HomeTab.albums:   return 0;
      case HomeTab.projects: return 1;
      case HomeTab.profile:  return 2;
    }
  }

  void _switchTab(BuildContext context, HomeTab tab) {
    if (tab == _previousTab) return;
    final fromIndex = _tabIndex(_previousTab);
    final toIndex = _tabIndex(tab);
    setState(() {
      _previousTab = tab;
      _editMode = false;
    });
    context.read<HomeController>().switchTab(tab);
    _isProgrammaticScroll = true;
    if ((toIndex - fromIndex).abs() > 1) {
      _pageController.jumpToPage(toIndex);
      _isProgrammaticScroll = false;
    } else {
      _pageController
          .animateToPage(
            toIndex,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
          )
          .then((_) => _isProgrammaticScroll = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: _createController,
      child: BlocBuilder<HomeController, HomeState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              fit: StackFit.expand,
              children: [
                const LavaBackground(),
                SafeArea(
                  child: Column(
                    children: [
                      _buildTopBar(context, state),
                      Expanded(
                        child: _buildAnimatedBody(context, state),
                      ),
                      _buildBottomNav(context, state),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, HomeState state) {
    final titles = {
      HomeTab.albums: 'My Albums',
      HomeTab.projects: 'My Projects',
      HomeTab.profile: 'Profile',
    };
    return Container(
      height: AppStyleConstant.appBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1540), Color(0xFF0F0D2E)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.40),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            Assets.img.appIcon.appIconTransparent.path,
            width: 48,
            height: 48,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 10),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(anim),
                child: child,
              ),
            ),
            child: Text(
              titles[state.activeTab]!,
              key: ValueKey(state.activeTab),
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const Spacer(),
          if (state.activeTab == HomeTab.albums) ...[
            _buildIconButton(
              _editMode ? Icons.check : Icons.remove,
              () => setState(() => _editMode = !_editMode),
              color: _editMode ? AppColor.alertSuccess : AppColor.alertError,
            ),
            const SizedBox(width: 8),
            _buildIconButton(Icons.add, () {
              setState(() => _editMode = false);
              CreateAlbumSheet.show(context);
            }),
          ],
          if (state.activeTab == HomeTab.projects) ...[
            _buildIconButton(
              _editMode ? Icons.check : Icons.remove,
              () => setState(() => _editMode = !_editMode),
              color: _editMode ? AppColor.alertSuccess : AppColor.alertError,
            ),
            const SizedBox(width: 8),
            _buildIconButton(Icons.add, () {
              setState(() => _editMode = false);
              CreateProjectSheet.show(context);
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap, {Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.22),
          borderRadius: BorderRadius.circular(AppStyleConstant.mediumRounding),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.35),
            width: 1,
          ),
        ),
        child: Icon(icon, size: 20, color: color ?? Colors.white),
      ),
    );
  }

  Widget _buildAnimatedBody(BuildContext context, HomeState state) {
    return PageView(
      controller: _pageController,
      physics: const BouncingScrollPhysics(),
      onPageChanged: (index) {
        if (_isProgrammaticScroll) return;
        final tabs = [HomeTab.albums, HomeTab.projects, HomeTab.profile];
        _switchTab(context, tabs[index]);
      },
      children: [
        _buildAlbumsSection(context, state),
        _buildProjectsSection(context, state),
        _buildProfileSection(context, state),
      ],
    );
  }

  Widget _buildAlbumsSection(BuildContext context, HomeState state) {
    final isLoading = state.albumsLoading || state.galleryLoading;

    if (isLoading) return _buildLoadingGrid();

    if (state.albumsError != null) {
      return _buildError(state.albumsError!, () {
        context.read<HomeController>().fetchAlbums();
        context.read<HomeController>().fetchGallery();
      });
    }

    return RefreshIndicator(
      color: AppColor.primary,
      onRefresh: () async {
        await Future.wait([
          context.read<HomeController>().fetchAlbums(),
          context.read<HomeController>().fetchGallery(),
        ]);
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.82,
        ),
        itemCount: state.albums.length + 1,
        itemBuilder: (context, i) {
          if (i == 0) return _GalleryCard(media: state.gallery);
          return _AlbumCard(
            key: ValueKey(state.albums[i - 1].id),
            album: state.albums[i - 1],
            editMode: _editMode,
          );
        },
      ),
    );
  }

  Widget _buildProjectsSection(BuildContext context, HomeState state) {
    if (state.projectsLoading) return _buildLoadingList();

    if (state.projectsError != null) {
      return _buildError(state.projectsError!, () {
        context.read<HomeController>().fetchProjects();
      });
    }

    if (state.projects.isEmpty) {
      return _buildEmpty(
        icon: Icons.folder_outlined,
        title: 'No Projects Yet',
        subtitle: 'Start a new project and bring\nyour game art ideas to life.',
        actionLabel: 'Create Project',
        onAction: () => CreateProjectSheet.show(context),
      );
    }

    return RefreshIndicator(
      color: AppColor.primary,
      onRefresh: () => context.read<HomeController>().fetchProjects(),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: state.projects.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) => _ProjectCard(
          key: ValueKey(state.projects[i].id),
          project: state.projects[i],
          editMode: _editMode,
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, HomeState state) {
    if (state.profileLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColor.primary));
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 28),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1A1540), Color(0xFF0F0D2E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.6),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                    gradient: const LinearGradient(
                      colors: [AppColor.gradientStart3, AppColor.gradientEnd3],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _getInitials(state),
                      style: GoogleFonts.inter(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  _displayName(state),
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  state.user?.email ?? '',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 10),
                if (state.user?.emailValidated == true)
                  _buildBadge('Verified', Icons.verified, Colors.white, Colors.white.withValues(alpha: 0.22))
                else
                  GestureDetector(
                    onTap: () async {
                      final ctrl = context.read<HomeController>();
                      final ok = await ctrl.sendVerificationEmail(
                        onError: (msg) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(msg),
                            backgroundColor: AppColor.alertError,
                            behavior: SnackBarBehavior.floating,
                          ));
                        },
                      );
                      if (ok && context.mounted) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: ctrl,
                            child: const EmailVerificationPage(),
                          ),
                        ));
                      }
                    },
                    child: _buildBadge('Unverified', Icons.warning_amber_outlined, Colors.white, Colors.white.withValues(alpha: 0.22)),
                  ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildStatsRow(state),
                const SizedBox(height: 20),
                _buildProfileMenuSection(context, state),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, IconData icon, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(HomeState state) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1740).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(AppStyleConstant.largeRounding),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [AppStyleConstant.shadow],
      ),
      child: Row(
        children: [
          _buildStatItem('Albums', state.albums.length.toString(), AppColor.gradientStart3, AppColor.gradientEnd3),
          _buildStatDivider(),
          _buildStatItem('Projects', state.projects.length.toString(), AppColor.gradientStart5, AppColor.gradientEnd5),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color c1, Color c2) {
    return Expanded(
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [c1, c2],
            ).createShader(bounds),
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 12, color: Colors.white.withValues(alpha: 0.55)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(width: 1, height: 36, color: Colors.white.withValues(alpha: 0.12));
  }

  Widget _buildProfileMenuSection(BuildContext context, HomeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMenuGroup([
          _buildMenuItem(Icons.person_outline, 'Edit Profile', () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<HomeController>(),
                child: const EditProfilePage(),
              ),
            ));
          }),
          _buildMenuItem(Icons.lock_outline, 'Change Password', () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<HomeController>(),
                child: const EditPasswordPage(),
              ),
            ));
          }),
        ]),
        const SizedBox(height: 12),
        _buildMenuGroup([
          _buildMenuItem(
            Icons.logout,
            'Sign Out',
            () => context.read<HomeController>().signOut(() => context.navigateToAuth()),
            color: AppColor.alertError,
          ),
        ]),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildMenuGroup(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1740).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(AppStyleConstant.largeRounding),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [AppStyleConstant.shadow],
      ),
      child: Column(
        children: items.indexed.map((entry) {
          final isLast = entry.$1 == items.length - 1;
          return Column(
            children: [
              entry.$2,
              if (!isLast)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(height: 1, color: Colors.white.withValues(alpha: 0.08)),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, VoidCallback onTap, {Color? color}) {
    final isDestructive = color != null;
    final itemColor = color ?? Colors.white.withValues(alpha: 0.90);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppStyleConstant.largeRounding),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: isDestructive
                    ? AppColor.alertError.withValues(alpha: 0.18)
                    : Colors.white.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(AppStyleConstant.smallRounding),
              ),
              child: Icon(icon, size: 18, color: itemColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: itemColor,
                ),
              ),
            ),
            if (!isDestructive)
              Icon(Icons.chevron_right, size: 18, color: Colors.white.withValues(alpha: 0.35)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, HomeState state) {
    return Container(
      height: 68,
      decoration: BoxDecoration(
        color: const Color(0xFF0D0A1E).withValues(alpha: 0.82),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildNavItem(
            context: context,
            icon: Icons.photo_library_outlined,
            activeIcon: Icons.photo_library_rounded,
            label: 'Albums',
            tab: HomeTab.albums,
            activeTab: state.activeTab,
          ),
          _buildNavItem(
            context: context,
            icon: Icons.folder_outlined,
            activeIcon: Icons.folder_rounded,
            label: 'Projects',
            tab: HomeTab.projects,
            activeTab: state.activeTab,
          ),
          _buildNavItem(
            context: context,
            icon: Icons.person_outline_rounded,
            activeIcon: Icons.person_rounded,
            label: 'Profile',
            tab: HomeTab.profile,
            activeTab: state.activeTab,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required HomeTab tab,
    required HomeTab activeTab,
  }) {
    final isActive = tab == activeTab;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _switchTab(context, tab),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              width: isActive ? 52 : 40,
              height: isActive ? 34 : 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: isActive
                    ? const LinearGradient(
                        colors: [Color(0xFF2D2870), Color(0xFF1A1650)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
              ),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isActive ? activeIcon : icon,
                    key: ValueKey(isActive),
                    size: 22,
                    color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.45),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.45),
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.82,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => AppSkeletonWidget(
        width: double.infinity,
        height: double.infinity,
        border: BorderRadius.circular(AppStyleConstant.largeRounding),
      ),
    );
  }

  Widget _buildLoadingList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => AppSkeletonWidget(
        width: double.infinity,
        height: 88,
        border: BorderRadius.circular(AppStyleConstant.largeRounding),
      ),
    );
  }

  Widget _buildError(String message, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColor.alertError.withValues(alpha: 0.15),
                    AppColor.alertError.withValues(alpha: 0.05),
                  ],
                ),
                border: Border.all(color: AppColor.alertErrorBorder),
              ),
              child: const Icon(Icons.cloud_off_outlined, size: 32, color: AppColor.alertError),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 14, color: AppColor.textSubtitle),
            ),
            const SizedBox(height: 20),
            AppFilledButton(
              onPressed: onRetry,
              child: Text(
                'Retry',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty({
    required IconData icon,
    required String title,
    required String subtitle,
    required String actionLabel,
    required VoidCallback onAction,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _PulsingIcon(icon: icon),
            const SizedBox(height: 20),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColor.textTitle,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 14, color: AppColor.textSubtitle, height: 1.5),
            ),
            const SizedBox(height: 28),
            AppFilledButton(
              onPressed: onAction,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  actionLabel,
                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _displayName(HomeState state) {
    final first = state.user?.firstName ?? '';
    final last = state.user?.lastName ?? '';
    final full = '$first $last'.trim();
    return full.isEmpty ? (state.user?.email?.split('@').first ?? 'User') : full;
  }

  String _getInitials(HomeState state) {
    final first = state.user?.firstName;
    final last = state.user?.lastName;
    if (first != null && last != null && first.isNotEmpty && last.isNotEmpty) {
      return '${first[0]}${last[0]}'.toUpperCase();
    }
    if (first != null && first.isNotEmpty) return first[0].toUpperCase();
    final email = state.user?.email ?? 'U';
    return email[0].toUpperCase();
  }
}

class _PulsingIcon extends StatefulWidget {
  const _PulsingIcon({required this.icon});
  final IconData icon;

  @override
  State<_PulsingIcon> createState() => _PulsingIconState();
}

class _PulsingIconState extends State<_PulsingIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _ring;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: false);
    _scale = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    _ring = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _ring,
            builder: (_, __) => Opacity(
              opacity: (1 - _ring.value) * 0.5,
              child: Container(
                width: 60 + _ring.value * 40,
                height: 60 + _ring.value * 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColor.primary,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _scale,
            builder: (_, child) => Transform.scale(
              scale: _scale.value,
              child: child,
            ),
            child: Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF803DFF), Color(0xFF5B6AF0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(widget.icon, size: 34, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _GalleryCard extends StatelessWidget {
  const _GalleryCard({required this.media});

  final List<MediaDto> media;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<HomeController>(),
                child: const GalleryPage(),
              ),
            ),
          ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppStyleConstant.largeRounding),
          boxShadow: [AppStyleConstant.shadow],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppStyleConstant.largeRounding),
              child: _buildMosaic(),
            ),
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppStyleConstant.largeRounding),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.35),
                        Colors.black.withValues(alpha: 0.80),
                      ],
                      stops: const [0.40, 0.70, 1.0],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(AppStyleConstant.extraSmallRounding),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.auto_awesome, size: 11, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      'Gallery',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'All Images',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${media.length} ${media.length == 1 ? 'item' : 'items'}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMosaic() {
    final previews = media.take(4).toList();

    return IgnorePointer(
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(4, (i) {
          if (i < previews.length && previews[i].mediaUrl != null) {
            return AppImage(asset: previews[i].mediaUrl!, fit: BoxFit.cover);
          }
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColor.gradientStart3.withValues(alpha: 0.35),
                  AppColor.gradientEnd3.withValues(alpha: 0.35),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Center(
              child: Icon(Icons.image_outlined, size: 22, color: Colors.white54),
            ),
          );
        }),
      ),
    );
  }
}

class _AlbumCard extends StatefulWidget {
  const _AlbumCard({
    super.key,
    required this.album,
    required this.editMode,
  });

  final AlbumDto album;
  final bool editMode;

  @override
  State<_AlbumCard> createState() => _AlbumCardState();
}

class _AlbumCardState extends State<_AlbumCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _exitCtrl;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _exitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitCtrl, curve: Curves.easeIn),
    );
    _opacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitCtrl, curve: const Interval(0.3, 1.0)),
    );
  }

  @override
  void dispose() {
    _exitCtrl.dispose();
    super.dispose();
  }

  Future<void> _deleteWithAnimation(BuildContext context) async {
    final homeCtrl = context.read<HomeController>();
    homeCtrl.deleteAlbum(
      widget.album.id ?? 0,
      onSuccess: () async {
        if (!context.mounted) return;
        await _exitCtrl.forward();
      },
      onError: (msg) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(child: Text(msg, style: const TextStyle(color: Colors.white))),
          ]),
          backgroundColor: AppColor.alertError,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 4),
        ));
      },
    );
  }

  void _confirmDelete(BuildContext context) {
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
            24, 20, 24, MediaQuery.of(sheetCtx).padding.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                  color: AppColor.spaceBorder,
                  borderRadius: BorderRadius.circular(2)),
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
            Text('Delete Album',
                style: GoogleFonts.inter(
                    fontSize: 17, fontWeight: FontWeight.w700,
                    color: AppColor.spaceTextPrimary)),
            const SizedBox(height: 8),
            Text(
              'This album will be permanently deleted. Images inside will not be affected.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: 13, color: AppColor.spaceTextSecondary, height: 1.5),
            ),
            const SizedBox(height: 24),
            Row(children: [
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
                    _deleteWithAnimation(context);
                  },
                  active: AppColor.alertError,
                  buttonStyle: YDButtonStyle.defaultSolidStyle.copyWith(
                    backgroundColor: const MaterialStatePropertyAll(AppColor.alertError),
                    foregroundColor: const MaterialStatePropertyAll(Colors.black),
                  ),
                  child: Text('Delete',
                      style: GoogleFonts.inter(
                          fontSize: 14, fontWeight: FontWeight.w600,
                          color: Colors.black)),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final firstPhoto = widget.album.mediaList?.isNotEmpty == true
        ? widget.album.mediaList!.first
        : null;
    final hasPhoto = firstPhoto?.mediaUrl != null;
    final name = widget.album.name ?? 'Unnamed';
    final count = widget.album.mediaList?.length ?? 0;

    return AnimatedBuilder(
      animation: _exitCtrl,
      builder: (context, child) => Transform.scale(
        scale: _scale.value,
        alignment: Alignment.center,
        child: Opacity(opacity: _opacity.value, child: child),
      ),
      child: GestureDetector(
        onTap: widget.editMode
            ? () => _confirmDelete(context)
            : () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<HomeController>(),
                    child: AlbumDetailPage(album: widget.album),
                  ),
                )),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppStyleConstant.largeRounding),
                boxShadow: [AppStyleConstant.shadow],
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppStyleConstant.largeRounding),
                    child: hasPhoto
                        ? AppImage(asset: firstPhoto!.mediaUrl!, fit: BoxFit.cover)
                        : _buildPhotoPlaceholder(name),
                  ),
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppStyleConstant.largeRounding),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.35),
                              Colors.black.withValues(alpha: 0.80),
                            ],
                            stops: const [0.40, 0.70, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12, right: 12, bottom: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                                fontSize: 13, fontWeight: FontWeight.w600,
                                color: Colors.white)),
                        const SizedBox(height: 2),
                        Text('$count ${count == 1 ? 'item' : 'items'}',
                            style: GoogleFonts.inter(
                                fontSize: 11,
                                color: Colors.white.withValues(alpha: 0.85))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (widget.editMode)
              Positioned(
                top: -8, left: -8,
                child: GestureDetector(
                  onTap: () => _confirmDelete(context),
                  child: Container(
                    width: 26, height: 26,
                    decoration: const BoxDecoration(
                        color: AppColor.alertError, shape: BoxShape.circle),
                    child: const Icon(Icons.close, size: 16, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoPlaceholder(String name) {
    final idx = name.codeUnits.fold(0, (a, b) => a + b) % 6;
    final gradients = [
      [AppColor.gradientStart1, AppColor.gradientEnd1],
      [AppColor.gradientStart2, AppColor.gradientEnd2],
      [AppColor.gradientStart3, AppColor.gradientEnd3],
      [AppColor.gradientStart4, AppColor.gradientEnd4],
      [AppColor.gradientStart5, AppColor.gradientEnd5],
      [AppColor.gradientStart6, AppColor.gradientEnd6],
    ];
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradients[idx],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: GoogleFonts.inter(
            fontSize: 36, fontWeight: FontWeight.w800,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  const _ProjectCard({
    super.key,
    required this.project,
    required this.editMode,
  });
  final ProjectDto project;
  final bool editMode;

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard>
    with TickerProviderStateMixin {
  late final AnimationController _tapCtrl;
  late final AnimationController _exitCtrl;
  late final Animation<double> _tapScale;
  late final Animation<Offset> _slideOut;
  late final Animation<double> _fadeOut;

  @override
  void initState() {
    super.initState();
    _tapCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.97,
      upperBound: 1.0,
    )..value = 1.0;
    _tapScale = _tapCtrl;

    _exitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideOut = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.2, 0.0),
    ).animate(CurvedAnimation(parent: _exitCtrl, curve: Curves.easeInCubic));
    _fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitCtrl, curve: const Interval(0.2, 1.0)),
    );
  }

  @override
  void dispose() {
    _tapCtrl.dispose();
    _exitCtrl.dispose();
    super.dispose();
  }

  Future<void> _deleteWithAnimation(BuildContext context) async {
    final homeCtrl = context.read<HomeController>();
    await _exitCtrl.forward();
    if (!context.mounted) return;
    homeCtrl.deleteProject(
      widget.project.id ?? 0,
      onError: (msg) {
        _exitCtrl.reverse();
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(child: Text(msg, style: const TextStyle(color: Colors.white))),
          ]),
          backgroundColor: AppColor.alertError,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 4),
        ));
      },
    );
  }

  void _confirmDelete(BuildContext context) {
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
            24, 20, 24, MediaQuery.of(sheetCtx).padding.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                  color: AppColor.spaceBorder,
                  borderRadius: BorderRadius.circular(2)),
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
            Text('Delete Project',
                style: GoogleFonts.inter(
                    fontSize: 17, fontWeight: FontWeight.w700,
                    color: AppColor.spaceTextPrimary)),
            const SizedBox(height: 8),
            Text(
              '"${widget.project.projectName ?? 'This project'}" will be permanently deleted and cannot be recovered.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: 13, color: AppColor.spaceTextSecondary, height: 1.5),
            ),
            const SizedBox(height: 24),
            Row(children: [
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
                    _deleteWithAnimation(context);
                  },
                  active: AppColor.alertError,
                  buttonStyle: YDButtonStyle.defaultSolidStyle.copyWith(
                    backgroundColor: const MaterialStatePropertyAll(AppColor.alertError),
                    foregroundColor: const MaterialStatePropertyAll(Colors.black),
                  ),
                  child: Text('Delete',
                      style: GoogleFonts.inter(
                          fontSize: 14, fontWeight: FontWeight.w600,
                          color: Colors.black)),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final styleMeta = ArtStyleHelper.of(widget.project.artStyle);
    final instrCount = widget.project.instructions?.length ?? 0;

    return SlideTransition(
      position: _slideOut,
      child: FadeTransition(
        opacity: _fadeOut,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTapDown: widget.editMode ? null : (_) => _tapCtrl.reverse(),
              onTapUp: widget.editMode ? null : (_) => _tapCtrl.forward(),
              onTapCancel: widget.editMode ? null : () => _tapCtrl.forward(),
              onTap: widget.editMode
                  ? null
                  : () {
                      final homeCtrl = context.read<HomeController>();
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: homeCtrl,
                          child: ProjectPage(project: widget.project),
                        ),
                      ));
                    },
              child: ScaleTransition(
                scale: _tapScale,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColor.spaceCard,
                    borderRadius: BorderRadius.circular(AppStyleConstant.largeRounding),
                    border: Border.all(color: AppColor.spaceBorder),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 68, height: 88,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(AppStyleConstant.largeRounding),
                          ),
                          gradient: LinearGradient(
                            colors: styleMeta.colors,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Icon(styleMeta.icon, size: 28,
                              color: Colors.white.withValues(alpha: 0.9)),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.project.projectName ?? 'Unnamed Project',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  fontSize: 15, fontWeight: FontWeight.w600,
                                  color: AppColor.spaceTextPrimary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(children: [
                                _buildChip(styleMeta.label, styleMeta.icon,
                                    styleMeta.colors[0]),
                                const SizedBox(width: 6),
                                _buildChip('$instrCount instructions',
                                    Icons.format_list_bulleted,
                                    const Color(0xFF5B6AF0)),
                              ]),
                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: Icon(Icons.chevron_right,
                            size: 20, color: AppColor.spaceTextSecondary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (widget.editMode)
              Positioned(
                top: -8, left: -8,
                child: GestureDetector(
                  onTap: () => _confirmDelete(context),
                  child: Container(
                    width: 26, height: 26,
                    decoration: const BoxDecoration(
                        color: AppColor.alertError, shape: BoxShape.circle),
                    child: const Icon(Icons.close, size: 16, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 4),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 10, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}

