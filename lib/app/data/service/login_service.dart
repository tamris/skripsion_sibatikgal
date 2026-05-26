import 'package:dio/dio.dart';
import '../provider/api_provider.dart';

class LoginService {
  static const String _endpoint = '/api/auth/login';

  static Future<Response> login(
    String email,
    String password,
  ) async {
    try {
      final response = await ApiProvider.dio.post(
        _endpoint,
        data: {
          'email': email,
          'password': password,
        },
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
