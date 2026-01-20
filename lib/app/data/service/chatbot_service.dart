import 'package:batikara/app/data/config/app_config.dart';
import 'package:dio/dio.dart';

class ChatbotService {
  static final Dio _dio = Dio();
  // Sesuaikan dengan route di chatbot_api.py
  static const String _endpoint = '/api/chatbot/chat';

  static Future<String> getChatResponse(String message) async {
    try {
      final response = await _dio.post(
        '${AppConfig.baseUrl}$_endpoint',
        data: {
          'message': message
        }, // Key sesuai dengan request.get_json().get('message')
      );

      if (response.statusCode == 200) {
        // Ambil key 'reply' sesuai chatbot_api.py
        return response.data['reply'] ?? 'Maaf, tidak ada respons.';
      } else {
        return 'Server error: ${response.statusCode}';
      }
    } catch (e) {
      print('Chatbot Error: $e');
      return 'Maaf, terjadi kesalahan. Silakan coba lagi nanti.';
    }
  }
}
