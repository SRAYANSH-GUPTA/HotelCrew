import 'env.dart';

class AppEnv {
  static String get backendBaseUrl {
    final baseUrl = Env.backendUrl.trim();
    return baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
  }

  static String api(String path) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return '$backendBaseUrl$normalizedPath';
  }

  static Uri apiUri(String path) => Uri.parse(api(path));

  static String endpoint(String envKey, String path) {
    return api(path);
  }
}
