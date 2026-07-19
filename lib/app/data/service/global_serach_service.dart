import 'package:dio/dio.dart';
import '../provider/api_provider.dart';

class SearchService {
  static Future<Response> globalSearch(String query) async {
    try {
      // Menggunakan ApiProvider.dio agar aman, ter-inject token, & support auto-refresh
      return await ApiProvider.dio.get(
        '/api/search',
        queryParameters: {'q': query},
      );
    } on DioException catch (e) {
      if (e.response != null) return e.response!;
      rethrow;
    }
  }
}