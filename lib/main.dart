import 'init/index.dart';
import 'packages/index.dart';

void main() async {
  await _initDependencies();
  runApp(const MainApplication());
}

Future<void> _initDependencies() async {
  WidgetsFlutterBinding.ensureInitialized();

  AccessTokenStorage accessTokenStorage = AccessTokenStorage();
  final accessToken = await accessTokenStorage.getAccessToken();
  Config.accessToken = accessToken;

  final refreshToken = await accessTokenStorage.getRefreshToken();
  Config.refreshToken = refreshToken;

  // Register AccessTokenStorage in GetIt
  sl.registerSingleton<AccessTokenStorage>(accessTokenStorage);

  // Wire the token-refresh interceptor now that the router is available.
  accessTokenStorage.init(
    onSessionExpired: () => router.go(AppRouter.auth),
  );

  await _initDataSource();
  String? countryCode = await _initCountryCode();
  if (countryCode == null) {
    if (Platform.localeName == 'vi') {
      countryCode = 'VN';
    } else {
      countryCode = 'US';
    }
  }
  Config.countryCode = countryCode;
}

Future<void> _initDataSource() async {
  sl.registerLazySingleton<AppEvent>(() => AppEvent.instance());
  sl.registerSingleton(await SharedPreferences.getInstance());
  sl.registerSingleton<Local>(Repository.local);

  final Repository repository = await Repository.createRepository(
    appEvent: sl.get<AppEvent>(),
    local: sl.get<Local>(),
  );

  sl.registerSingleton<Repository>(repository);
}

Future<String?> _initCountryCode() async {
  final countryIpResponse = await CountryIp.find();
  return countryIpResponse?.countryCode;
}
