import 'package:batikara/app/data/config/app_config.dart';
import 'package:dio/dio.dart';

class OtpService {
  static final Dio _dio = Dio();
  static const String _baseEndpoint = '/api/auth'; 

  // Memanggil endpoint /verify-otp
  static Future<Response> verifyOtp(String email, String otp) async {
    try {
      final response = await _dio.post(
        '${AppConfig.baseUrl}$_baseEndpoint/verify-otp',
        data: {'email': email, 'otp': otp},
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) return e.response!;
      rethrow;
    }
  }

  // Memanggil endpoint /resend-otp
  static Future<Response> resendOtp(String email) async {
    try {
      final response = await _dio.post(
        '${AppConfig.baseUrl}$_baseEndpoint/resend-otp',
        data: {'email': email},
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) return e.response!;
      rethrow;
    }
  }
}