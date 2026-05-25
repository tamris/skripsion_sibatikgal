import 'package:dio/dio.dart';
import '../config/app_config.dart';

class GaleriService {
  static final Dio _dio = Dio();

  // Ditambahkan queryParameters sesuai kiriman parameter request.args dari Flask
  static Future<Response> fetchBatikWithPagination(
    int page,
    String search,
  ) async {
    try {
      return await _dio.get(
        '${AppConfig.baseUrl}/api/galeri',
        queryParameters: {
          'page': page,
          'q':
              search, // <-- Mengirimkan query pencarian ke parameter 'q' Flask kamu
        },
      );
    } on DioException catch (e) {
      return e.response!;
    }
  }

  static Future<Response> fetchBatikDetail(String id) async {
    try {
      return await _dio.get('${AppConfig.baseUrl}/api/galeri/$id');
    } on DioException catch (e) {
      return e.response!;
    }
  }
}
