import 'package:batikara/app/data/config/app_config.dart';
import 'package:dio/dio.dart';

class LoginService {
  static final Dio _dio = Dio();
  // Sesuaikan prefix jika kamu menggunakan /api/auth di app.py
  static const String _endpoint = '/api/auth/login'; 

  static Future<Response> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '${AppConfig.baseUrl}$_endpoint',
        data: {
          'email': email,
          'password': password,
        },
      );
      return response;
    } on DioException catch (e) {
      // Mengembalikan response error dari server (401, 403, dll)
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }
}