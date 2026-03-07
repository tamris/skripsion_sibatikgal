import 'package:dio/dio.dart';
import '../config/app_config.dart';

class GaleriService {
  static final Dio _dio = Dio();

  // Endpoint sesuai galeri_api.py
  static Future<Response> fetchAllBatiks() async {
    try {
      return await _dio.get('${AppConfig.baseUrl}/api/galeri');
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