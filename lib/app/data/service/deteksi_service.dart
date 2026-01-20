import 'package:dio/dio.dart' as dio;
import '../config/app_config.dart';

class DeteksiService {
  static final dio.Dio _dio = dio.Dio();
  // Sesuaikan prefix jika kamu mendaftarkannya di app.py (misal: /api/deteksi)
  static const String _endpoint = '/api/deteksi/predict'; 

  static Future<Map<String, dynamic>?> uploadImage(String filePath) async {
    try {
      // Membuat form data untuk mengirim file
      dio.FormData formData = dio.FormData.fromMap({
        'image': await dio.MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        ),
      });

      final response = await _dio.post(
        '${AppConfig.baseUrl}$_endpoint',
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data; // Mengembalikan json (nama, makna, dll)
      }
      return null;
    } catch (e) {
      print("Error upload: $e");
      return null;
    }
  }
}