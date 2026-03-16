import '../../generated/assets.dart';
import '../../init/routes.dart';
import '../../packages/index.dart';
import 'auth_controller.dart';
import 'auth_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final AuthController _controller;

  AuthController _createController(BuildContext context) {
    _controller = AuthController();
    return _controller;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: _createController,
      child: BlocConsumer<AuthController, AuthState>(
        listenWhen: (prev, curr) => prev.loading && !curr.loading,
        listener: (context, state) {},
        builder: (context, state) {
          return _SplashView(controller: _controller);
        },
      ),
    );
  }
}

class _SplashView extends StatefulWidget {
  const _SplashView({required this.controller});
  final AuthController controller;

  @override
  State<_SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<_SplashView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _rotate;
  late final Animation<double> _ringScale;
  late final Animation<double> _ringOpacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _rotate = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.linear),
    );

    _ringScale = Tween<double>(begin: 1.0, end: 1.6).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );

    _ringOpacity = Tween<double>(begin: 0.7, end: 0.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => _checkAuth());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _checkAuth() async {
    await widget.controller.checkAuthOnStartup(
      onAuthenticated: () {
        if (mounted) context.go(AppRouter.home);
      },
      onUnauthenticated: () {
        if (mounted) context.go(AppRouter.auth);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const LavaBackground(),
          Center(
            child: SizedBox(
              width: 140,
              height: 140,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Expanding pulse ring
                  AnimatedBuilder(
                    animation: _ctrl,
                    builder: (_, __) => Transform.scale(
                      scale: _ringScale.value,
                      child: Opacity(
                        opacity: _ringOpacity.value,
                        child: Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColor.primary,
                              width: 2.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Rotating arc
                  AnimatedBuilder(
                    animation: _rotate,
                    builder: (_, child) => RotationTransition(
                      turns: _rotate,
                      child: child,
                    ),
                    child: SizedBox(
                      width: 110,
                      height: 110,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white.withValues(alpha: 0.55),
                        ),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                  ),
                  // App icon in the centre
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.primary.withValues(alpha: 0.5),
                          blurRadius: 24,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        Assets.img.appIcon.appIconTransparent.path,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

