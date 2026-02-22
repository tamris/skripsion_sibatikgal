import 'package:dio/dio.dart';
import '../config/app_config.dart';

class VideoService {
  static final Dio _dio = Dio();

  // Tambahkan parameter page agar sinkron dengan API Flask kamu
  static Future<Response> fetchAllVideos(
      {String search = '', int page = 1}) async {
    try {
      // Pastikan endpoint-nya /video (sesuai Flask Blueprint kamu)
      return await _dio.get(
        '${AppConfig.baseUrl}/api/video',
        queryParameters: {'q': search, 'page': page},
      );
    } on DioException catch (e) {
      return e.response!;
    }
  }
}
