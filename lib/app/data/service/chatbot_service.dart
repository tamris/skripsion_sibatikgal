import 'package:batikara/app/data/config/app_config.dart';
import 'package:dio/dio.dart';


class ChatbotService {
  static final Dio _dio = Dio();
  static const String _endpoint = '/get_response';
  
  static Future<String> getChatResponse(String message) async {
    try {
      final response = await _dio.post(
        '${AppConfig.baseUrl}$_endpoint',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'ngrok-skip-browser-warning': 'true', // Skip ngrok browser warning
          },
        ),
        data: {
          'message': message,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return data['answer'] ?? 'Maaf, tidak ada respons dari server.';
      } else {
        return 'Maaf, terjadi kesalahan pada server. Status: ${response.statusCode}';
      }
    } on DioException catch (e) {
      print('DioException in ChatbotService: ${e.message}');
      
      if (e.response != null) {
        // Server responded with error status
        final statusCode = e.response!.statusCode;
        if (statusCode == 400) {
          final error = e.response!.data;
          return 'Error: ${error['error'] ?? 'Bad request'}';
        }
        return 'Maaf, terjadi kesalahan pada server. Status: $statusCode';
      } else {
        // Network error or timeout
        return 'Maaf, tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
      }
    } catch (e) {
      print('Unexpected error in ChatbotService: $e');
      return 'Maaf, terjadi kesalahan yang tidak terduga.';
    }
  }
}