import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../config/app_config.dart';
import '../../routes/app_pages.dart';

class ApiProvider {
  static final GetStorage storage = GetStorage();

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  static void init() {
    dio.interceptors.add(
      InterceptorsWrapper(
        // =========================
        // REQUEST
        // =========================

        onRequest: (options, handler) {
          // Jangan inject access token
          // ke endpoint refresh
          if (options.path.contains('/refresh')) {
            return handler.next(options);
          }

          final token = storage.read('token');

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },

        // =========================
        // ERROR
        // =========================

        onError: (error, handler) async {
          if (error.requestOptions.path.contains('/refresh')) {
            storage.erase();

            Get.offAllNamed(
              Routes.LOGIN_PAGE,
            );

            return handler.next(error);
          }

          // Token expired
          if (error.response?.statusCode == 401) {
            try {
              final refreshToken = storage.read(
                'refresh_token',
              );

              if (refreshToken == null) {
                storage.erase();

                Get.offAllNamed(
                  Routes.LOGIN_PAGE,
                );

                return handler.next(error);
              }

              // =========================
              // REFRESH TOKEN REQUEST
              // =========================

              final response = await dio.post(
                '/api/auth/refresh',
                options: Options(
                  headers: {
                    'Authorization': 'Bearer $refreshToken',
                  },
                ),
              );

              final newAccessToken = response.data['access_token'];

              // Simpan token baru
              storage.write(
                'token',
                newAccessToken,
              );

              // Update request lama
              error.requestOptions.headers['Authorization'] =
                  'Bearer $newAccessToken';

              // Retry request lama
              final retryResponse = await dio.fetch(
                error.requestOptions,
              );

              return handler.resolve(
                retryResponse,
              );
            } catch (e) {
              print("REFRESH ERROR: $e");

              return handler.next(error);
            }
          }

          return handler.next(error);
        },
      ),
    );
  }

  static Future<void> refreshToken() async {
    try {
      final refreshToken = storage.read('refresh_token');

      if (refreshToken == null) {
        throw Exception("Refresh token tidak ada");
      }

      final response = await dio.post(
        '/api/auth/refresh',
        options: Options(
          headers: {
            'Authorization': 'Bearer $refreshToken',
          },
        ),
      );

      final newAccessToken = response.data['access_token'];

      storage.write(
        'token',
        newAccessToken,
      );
    } catch (e) {
      storage.erase();

      Get.offAllNamed(
        Routes.LOGIN_PAGE,
      );

      rethrow;
    }
  }
}
