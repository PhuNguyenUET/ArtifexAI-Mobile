import 'init/index.dart';
import 'packages/index.dart';

void main() async {
  await _initDependencies();
  runApp(const MainApplication());
}

Future<void> _initDependencies() async {
  WidgetsFlutterBinding.ensureInitialized();

  final accessTokenStorage = AccessTokenStorage();
  await accessTokenStorage.getAccessToken();
  sl.registerSingleton<AccessTokenStorage>(accessTokenStorage);

  await _initDataSource(accessTokenStorage);

  String? countryCode = await _initCountryCode();
  countryCode ??= Platform.localeName.startsWith('vi') ? 'VN' : 'US';
}

Future<void> _initDataSource(AccessTokenStorage accessTokenStorage) async {
  // no-op: AccessTokenStorage already builds the repository internally.
  // Register it so controllers can resolve it via sl.
}

Future<String?> _initCountryCode() async {
  try {
    final countryIpResponse = await CountryIp.find();
    return countryIpResponse?.countryCode;
  } catch (_) {
    return null;
  }
}
