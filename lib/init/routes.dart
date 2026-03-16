import '../features/index.dart';
import '../features/home/home_page.dart';
import '../packages/index.dart';

/// The route configuration.
/// state.pathParameters['userId']
/// state.uri.queryParameters['filter']

abstract class AppRouter {
  AppRouter._();

  static const String splash = '/splash';
  static const String auth = '/auth';
  static const String home = '/home';
}

extension AppNavigator on BuildContext {
  void navigateToSplash() => go(AppRouter.splash);
  void navigateToAuth() => go(AppRouter.auth);
  void navigateToHome() => go(AppRouter.home);
}

final GoRouter router = GoRouter(
  initialLocation: AppRouter.splash,
  debugLogDiagnostics: true,
  observers: [YDToast.obs()],
  routes: <RouteBase>[
    GoRoute(
      path: AppRouter.splash,
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRouter.auth,
      name: 'auth',
      builder: (context, state) => const AuthPage(),
    ),
    GoRoute(
      path: AppRouter.home,
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
  ],
);
