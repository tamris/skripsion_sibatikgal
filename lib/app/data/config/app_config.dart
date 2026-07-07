import 'package:dio/dio.dart';

class AppConfig {
  static const String primaryBaseUrl = 'http://146.190.83.155:5000';
  static const String fallbackBaseUrl =
      'https://sincerely-generous-monkfish.ngrok-free.app';

  static String _baseUrl = primaryBaseUrl;

  static String get baseUrl => _baseUrl;

  static Future<void> init() async {
    _baseUrl = await _resolveBaseUrl();
  }

  static Future<String> _resolveBaseUrl() async {
    for (final candidate in <String>[
      primaryBaseUrl,
      fallbackBaseUrl,
    ]) {
      if (await _isReachable(candidate)) {
        return candidate;
      }
    }

    return primaryBaseUrl;
  }

  static Future<bool> _isReachable(String baseUrl) async {
    try {
      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 3),
          receiveTimeout: const Duration(seconds: 3),
          validateStatus: (_) => true,
        ),
      );

      await dio.getUri(Uri.parse('$baseUrl/'));
      return true;
    } catch (_) {
      return false;
    }
  }
}
