import 'package:batikara/app/data/models/batik_model.dart';
import 'package:batikara/app/data/provider/api_provider.dart';
import 'package:dio/dio.dart';

class GaleriService {
  // HAPUS: instance lokal _dio agar semua terpusat satu pintu lewat ApiProvider

  static Future<Response> fetchBatikWithPagination(
    int page,
    String search,
  ) async {
    try {
      // Menggunakan ApiProvider.dio agar otomatis diselipi token & auto-refresh token (401)
      // Path disesuaikan menjadi relatif sesuai dengan konfigurasi base URL di ApiProvider
      return await ApiProvider.dio.get(
        '/api/galeri',
        queryParameters: {
          'page': page,
          'q': search, 
        },
      );
    } on DioException catch (e) {
      if (e.response != null) return e.response!;
      rethrow;
    }
  }

  // ... Batas suci logika fungsi lain di bawah tetap dipertahankan utuh ...
  static Future<Response> fetchBatikDetail(String batikId) async {
    try {
      final response = await ApiProvider.dio.get('/api/galeri/$batikId');
      return response;
    } on DioException catch (e) {
      if (e.response != null) return e.response!;
      rethrow;
    }
  }

  static Future<BatikModel?> fetchBatikByMotifName(String motifName) async {
    final normalizedQuery = motifName.trim();
    if (normalizedQuery.isEmpty) return null;

    try {
      final response = await fetchBatikWithPagination(1, normalizedQuery);
      if (response.statusCode != 200) return null;

      final dynamic data = response.data['data'];
      if (data is! List || data.isEmpty) return null;

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

  static Future<Response> toggleLikeBatik(String batikId) async {
    try {
      final response = await ApiProvider.dio.post('/api/galeri/$batikId/like');
      return response;
    } on DioException catch (e) {
      if (e.response != null) return e.response!;
      rethrow;
    }
  }

  static Future<Response> getSavedItems() async {
    try {
      final response = await ApiProvider.dio.get('/api/user/saved');
      return response;
    } on DioException catch (e) {
      if (e.response != null) return e.response!;
      rethrow;
    }
  }
}