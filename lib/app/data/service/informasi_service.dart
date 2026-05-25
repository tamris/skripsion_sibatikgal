import 'package:dio/dio.dart';
import '../config/app_config.dart';

class InformasiService {
  static final Dio _dio = Dio();
  static const String _endpoint = '/api/informasi';

  // Ambil semua data informasi (dengan pagination & search)
  static Future<Response> fetchAllInformasi({String search = '', int page = 1}) async {
    try {
      final response = await _dio.get(
        '${AppConfig.baseUrl}$_endpoint',
        queryParameters: {'q': search, 'page': page},
      );
      return response;
    } on DioException catch (e) {
      return e.response!;
    }
  }

  // --- TAMBAHKAN FUNGSI INI: Ambil daftar kategori unik dari server ---
  static Future<Response> fetchCategories() async {
    try {
      final response = await _dio.get('${AppConfig.baseUrl}$_endpoint/categories');
      return response;
    } on DioException catch (e) {
      return e.response!;
    }
  }

  // Ambil detail informasi berdasarkan ID
  static Future<Response> fetchDetail(String id) async {
    try {
      return await _dio.get('${AppConfig.baseUrl}$_endpoint/$id');
    } on DioException catch (e) {
      return e.response!;
    }
  }
}