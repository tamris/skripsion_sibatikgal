import 'package:batikara/app/data/models/batik_model.dart';
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

  static Future<BatikModel?> fetchBatikByMotifName(String motifName) async {
    final normalizedQuery = motifName.trim();
    if (normalizedQuery.isEmpty) {
      return null;
    }

    try {
      final response = await fetchBatikWithPagination(1, normalizedQuery);

      if (response.statusCode != 200) {
        return null;
      }

      final dynamic data = response.data['data'];
      if (data is! List || data.isEmpty) {
        return null;
      }

      final batiks = data
          .map((json) => BatikModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();

      for (final batik in batiks) {
        if (batik.title.toLowerCase() == normalizedQuery.toLowerCase()) {
          return batik;
        }
      }

      return batiks.first;
    } on DioException {
      return null;
    }
  }
}
