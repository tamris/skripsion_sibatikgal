import 'package:batikara/app/data/models/batik_model.dart';
import 'package:batikara/app/data/provider/api_provider.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart'; // <--- 1. PASTIKAN IMPORT INI ADA
import '../config/app_config.dart';

class GaleriService {
  static final Dio _dio = Dio(); // Menggunakan instance lokal agar bersih

  static Future<Response> fetchBatikWithPagination(
    int page,
    String search,
  ) async {
    try {
      // 2. KUNCI UTAMA: Ambil token yang bener-bener fresh tepat saat fungsi ini dipanggil
      final storage = GetStorage();
      String? token = storage.read('token'); // Sesuaikan key storage token loginmu

      // 3. Rakit header secara dinamis
      Map<String, dynamic> headers = {};
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      // 4. Tembak menggunakan baseUrl lengkap dan sertakan hantaran header token
      return await _dio.get(
        '${AppConfig.baseUrl}/api/galeri',
        queryParameters: {
          'page': page,
          'q': search, 
        },
        options: Options(headers: headers), // <--- JAMINAN MUTLAK TOKEN TERKIRIM KANTONG FLASK
      );
    } on DioException catch (e) {
      return e.response!;
    }
  }

  // ... Batas suci logika fungsi lain di bawah jangan diubah ...
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