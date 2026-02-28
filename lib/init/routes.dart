import '../features/index.dart';
import '../packages/index.dart';

/// The route configuration.
/// state.pathParameters['userId']
/// state.uri.queryParameters['filter']

abstract class AppRouter {
  AppRouter._();

  static const String auth = '/auth';
  static const String home = '/home';
}

extension AppNavigator on BuildContext {
  void navigateToAuth() => go(AppRouter.auth);
  void navigateToHome() => go(AppRouter.home);
}

final GoRouter router = GoRouter(
  initialLocation: AppRouter.auth,
  debugLogDiagnostics: true,
  observers: [YDToast.obs()],
  routes: <RouteBase>[
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
