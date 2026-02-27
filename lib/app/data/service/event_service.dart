import 'package:dio/dio.dart';
import '../config/app_config.dart';

class EventService {
  static final Dio _dio = Dio();

  static Future<Response> fetchAllEvents(
      {String search = '', int page = 1}) async {
    try {
      // Endpoint sesuai event_api.py
      return await _dio.get(
        '${AppConfig.baseUrl}/api/events',
        queryParameters: {
          'q': search,
          'page': page,
        },
      );
    } on DioException catch (e) {
      return e.response!;
    }
  }

  static Future<Response> fetchEventDetail(String id) async {
    try {
      return await _dio.get('${AppConfig.baseUrl}/events/$id');
    } on DioException catch (e) {
      return e.response!;
    }
  }
}
