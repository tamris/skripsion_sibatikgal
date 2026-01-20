import 'package:batikara/app/data/config/app_config.dart';
import 'package:dio/dio.dart';

class RegisterService {
  static final Dio _dio = Dio();
  // Endpoint sesuai dengan auth_api.py dengan prefix /api/auth
  static const String _endpoint = '/api/auth/register'; 

  static Future<Response> register(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(
        '${AppConfig.baseUrl}$_endpoint',
        data: data,
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }
}