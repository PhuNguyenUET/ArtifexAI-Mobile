import '../../generated/assets.dart';
import '../../init/routes.dart';
import '../../packages/index.dart';
import 'home_controller.dart';
import 'home_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController _controller;

  HomeController _createController(BuildContext context) {
    _controller = HomeController();
    return _controller;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: _createController,
      child: BlocBuilder<HomeController, HomeState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColor.backgroundLight1,
            body: SafeArea(
              child: Column(
                children: [
                  _buildTopBar(context, state),
                  Expanded(child: _buildBody(context, state)),
                  _buildBottomNav(context, state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ─── Top Bar ─────────────────────────────────────────────────────────────────

  Widget _buildTopBar(BuildContext context, HomeState state) {
    final titles = {
      HomeTab.albums: 'My Albums',
      HomeTab.projects: 'My Projects',
      HomeTab.profile: 'Profile',
    };
    return Container(
      height: AppStyleConstant.appBarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: AppColor.backgroundWhite,
        border: Border(bottom: BorderSide(color: AppColor.borderDivider)),
      ),
      child: Row(
        children: [
          Image.asset(Assets.imgLaunch2, height: 30, width: 30),
          const SizedBox(width: 10),
          Text(
            titles[state.activeTab]!,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColor.textTitle,
            ),
          ),
          const Spacer(),
          if (state.activeTab == HomeTab.albums)
            _buildIconButton(Icons.add, () {}),
          if (state.activeTab == HomeTab.projects)
            _buildIconButton(Icons.add, () {}),
          if (state.activeTab == HomeTab.profile)
            _buildIconButton(Icons.settings_outlined, () {}),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppColor.backgroundLight2,
          borderRadius: BorderRadius.circular(AppStyleConstant.mediumRounding),
        ),
        child: Icon(icon, size: 20, color: AppColor.textLabel),
      ),
    );
  }

  // ─── Body ─────────────────────────────────────────────────────────────────────

  Widget _buildBody(BuildContext context, HomeState state) {
    switch (state.activeTab) {
      case HomeTab.albums:
        return _buildAlbumsSection(context, state);
      case HomeTab.projects:
        return _buildProjectsSection(context, state);
      case HomeTab.profile:
        return _buildProfileSection(context, state);
    }
  }

  // ─── Albums ───────────────────────────────────────────────────────────────────

  Widget _buildAlbumsSection(BuildContext context, HomeState state) {
    if (state.albumsLoading) return _buildLoadingGrid();

    if (state.albumsError != null) {
      return _buildError(state.albumsError!, () {
        context.read<HomeController>().fetchAlbums();
      });
    }

    if (state.albums.isEmpty) {
      return _buildEmpty(
        icon: Icons.photo_library_outlined,
        title: 'No Albums Yet',
        subtitle: 'Create your first album to organise\nyour generated artwork.',
        actionLabel: 'Create Album',
        onAction: () {},
      );
    }

    return RefreshIndicator(
      color: AppColor.primary,
      onRefresh: () => context.read<HomeController>().fetchAlbums(),
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.82,
        ),
        itemCount: state.albums.length,
        itemBuilder: (context, i) => _AlbumCard(album: state.albums[i]),
      ),
    );
  }

  // ─── Projects ─────────────────────────────────────────────────────────────────

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
        onAction: () {},
      );
    }

    return RefreshIndicator(
      color: AppColor.primary,
      onRefresh: () => context.read<HomeController>().fetchProjects(),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: state.projects.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) => _ProjectCard(project: state.projects[i]),
      ),
    );
  }

  // ─── Profile ──────────────────────────────────────────────────────────────────

  Widget _buildProfileSection(BuildContext context, HomeState state) {
    if (state.profileLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColor.primary));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 8),
          _buildAvatar(state),
          const SizedBox(height: 16),
          Text(
            _displayName(state),
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColor.textTitle,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            state.user?.email ?? '',
            style: GoogleFonts.inter(fontSize: 14, color: AppColor.textSubtitle),
          ),
          const SizedBox(height: 8),
          if (state.user?.emailValidated == true)
            _buildBadge('Verified', Icons.verified, AppColor.alertSuccess, AppColor.alertSuccessBackground)
          else
            _buildBadge('Unverified', Icons.warning_amber_outlined, AppColor.alertWarning, AppColor.alertWarningBackground),
          const SizedBox(height: 28),
          _buildStatsRow(state),
          const SizedBox(height: 28),
          _buildProfileMenuSection(context, state),
        ],
      ),
    );
  }

  Widget _buildAvatar(HomeState state) {
    final initials = _getInitials(state);
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColor.gradientStart3, AppColor.gradientEnd3],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [AppStyleConstant.shadow],
      ),
      child: Center(
        child: Text(
          initials,
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String label, IconData icon, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
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
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColor.backgroundWhite,
        borderRadius: BorderRadius.circular(AppStyleConstant.largeRounding),
        boxShadow: [AppStyleConstant.shadow],
      ),
      child: Row(
        children: [
          _buildStatItem('Albums', state.albums.length.toString()),
          _buildStatDivider(),
          _buildStatItem('Projects', state.projects.length.toString()),
          _buildStatDivider(),
          _buildStatItem('Role', state.user?.role ?? '–'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColor.primary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 12, color: AppColor.textSubtitle),
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(width: 1, height: 36, color: AppColor.borderDivider);
  }

  Widget _buildProfileMenuSection(BuildContext context, HomeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMenuGroup([
          _buildMenuItem(Icons.person_outline, 'Edit Profile', () {}),
          _buildMenuItem(Icons.lock_outline, 'Change Password', () {}),
          _buildMenuItem(Icons.notifications_outlined, 'Notifications', () {}),
        ]),
        const SizedBox(height: 12),
        _buildMenuGroup([
          _buildMenuItem(Icons.help_outline, 'Help & Support', () {}),
          _buildMenuItem(Icons.info_outline, 'About', () {}),
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
        color: AppColor.backgroundWhite,
        borderRadius: BorderRadius.circular(AppStyleConstant.largeRounding),
        boxShadow: [AppStyleConstant.shadow],
      ),
      child: Column(
        children: items.indexed.map((entry) {
          final isLast = entry.$1 == items.length - 1;
          return Column(
            children: [
              entry.$2,
              if (!isLast)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(height: 1, color: AppColor.borderDivider),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, VoidCallback onTap, {Color? color}) {
    final itemColor = color ?? AppColor.textLabel;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppStyleConstant.largeRounding),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: itemColor),
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
            if (color == null)
              const Icon(Icons.chevron_right, size: 18, color: AppColor.textSubtitle),
          ],
        ),
      ),
    );
  }

  // ─── Bottom Nav ───────────────────────────────────────────────────────────────

  Widget _buildBottomNav(BuildContext context, HomeState state) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: AppColor.backgroundWhite,
        border: Border(top: BorderSide(color: AppColor.borderDivider)),
      ),
      child: Row(
        children: [
          _buildNavItem(
            context: context,
            icon: Icons.photo_library_outlined,
            activeIcon: Icons.photo_library,
            label: 'Albums',
            tab: HomeTab.albums,
            activeTab: state.activeTab,
          ),
          _buildNavItem(
            context: context,
            icon: Icons.folder_outlined,
            activeIcon: Icons.folder,
            label: 'Projects',
            tab: HomeTab.projects,
            activeTab: state.activeTab,
          ),
          _buildNavItem(
            context: context,
            icon: Icons.person_outline,
            activeIcon: Icons.person,
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
        onTap: () => context.read<HomeController>().switchTab(tab),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? activeIcon : icon,
                key: ValueKey(isActive),
                size: 24,
                color: isActive ? AppColor.primary : AppColor.textSubtitle,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? AppColor.primary : AppColor.textSubtitle,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isActive ? 18 : 0,
              height: 3,
              decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────────

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
            const Icon(Icons.cloud_off_outlined, size: 56, color: AppColor.textSubtitle),
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
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColor.primaryBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 38, color: AppColor.primary),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColor.textTitle,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 14, color: AppColor.textSubtitle),
            ),
            const SizedBox(height: 24),
            AppFilledButton(
              onPressed: onAction,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
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

// ─── Album Card ──────────────────────────────────────────────────────────────

class _AlbumCard extends StatelessWidget {
  const _AlbumCard({required this.album});

  final AlbumDto album;

  @override
  Widget build(BuildContext context) {
    final firstPhoto = album.mediaList?.isNotEmpty == true ? album.mediaList!.first : null;
    final hasPhoto = firstPhoto?.mediaUrl != null;

    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.backgroundWhite,
          borderRadius: BorderRadius.circular(AppStyleConstant.largeRounding),
          boxShadow: [AppStyleConstant.shadow],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppStyleConstant.largeRounding),
                ),
                child: hasPhoto
                    ? AppImage(
                        asset: firstPhoto!.mediaUrl!,
                        fit: BoxFit.cover,
                      )
                    : _buildPhotoPlaceholder(album.name ?? 'Album'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    album.name ?? 'Unnamed',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColor.textTitle,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${album.mediaList?.length ?? 0} items',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColor.textSubtitle,
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

  Widget _buildPhotoPlaceholder(String name) {
    // Generate a stable gradient index from the name
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
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ),
    );
  }
}

// ─── Project Card ─────────────────────────────────────────────────────────────

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project});

  final ProjectDto project;

  @override
  Widget build(BuildContext context) {
    final artStyle = project.artStyle?.name ?? 'Unknown';
    final instrCount = project.instructions?.length ?? 0;

    final idx = (project.projectName ?? '').codeUnits.fold(0, (a, b) => a + b) % 6;
    final gradients = [
      [AppColor.gradientStart1, AppColor.gradientEnd1],
      [AppColor.gradientStart2, AppColor.gradientEnd2],
      [AppColor.gradientStart3, AppColor.gradientEnd3],
      [AppColor.gradientStart4, AppColor.gradientEnd4],
      [AppColor.gradientStart5, AppColor.gradientEnd5],
      [AppColor.gradientStart6, AppColor.gradientEnd6],
    ];

    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.backgroundWhite,
          borderRadius: BorderRadius.circular(AppStyleConstant.largeRounding),
          boxShadow: [AppStyleConstant.shadow],
        ),
        child: Row(
          children: [
            // Coloured accent bar + icon
            Container(
              width: 72,
              height: 88,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(AppStyleConstant.largeRounding),
                ),
                gradient: LinearGradient(
                  colors: gradients[idx],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Icon(Icons.auto_awesome, size: 28, color: Colors.white),
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
                      project.projectName ?? 'Unnamed Project',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColor.textTitle,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _buildTag(artStyle, Icons.palette_outlined),
                        const SizedBox(width: 8),
                        _buildTag('$instrCount prompts', Icons.list_outlined),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.chevron_right, size: 20, color: AppColor.textSubtitle),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String label, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColor.textSubtitle),
        const SizedBox(width: 3),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 11, color: AppColor.textSubtitle),
        ),
      ],
    );
  }
}




