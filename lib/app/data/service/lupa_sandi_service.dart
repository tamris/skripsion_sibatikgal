import 'package:batikara/app/data/config/app_config.dart';
import 'package:dio/dio.dart';

class LupaSandiService {
  static final Dio _dio = Dio();
  static const String _baseEndpoint = '/api/auth';

  // 1. Kirim OTP ke Email
  static Future<Response> forgotPassword(String email) async {
    try {
      return await _dio.post('${AppConfig.baseUrl}$_baseEndpoint/forgot-password', data: {'email': email});
    } on DioException catch (e) {
      return e.response!;
    }
  }

  // 2. Verifikasi OTP Reset
  static Future<Response> verifyResetOtp(String email, String otp) async {
    try {
      return await _dio.post('${AppConfig.baseUrl}$_baseEndpoint/verify-reset-otp', data: {'email': email, 'otp': otp});
    } on DioException catch (e) {
      return e.response!;
    }
  }

  // 3. Simpan Password Baru
  static Future<Response> resetPassword(String email, String otp, String newPassword) async {
    try {
      return await _dio.post('${AppConfig.baseUrl}$_baseEndpoint/reset-password', data: {
        'email': email,
        'otp': otp,
        'new_password': newPassword,
      });
    } on DioException catch (e) {
      return e.response!;
    }
  }
}