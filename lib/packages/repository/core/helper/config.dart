import 'dart:io';

class Config {
  Config._();

  static final String _host = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  static final String baseUrl = 'http://$_host:7070/';
  static final String commonUrl = 'http://$_host:7070/';
  static String secretKey = '';
  static String accessToken = '';
  static String countryCode = 'US';
}
