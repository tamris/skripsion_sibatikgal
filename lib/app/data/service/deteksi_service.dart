import 'package:dio/dio.dart' as dio;
import '../config/app_config.dart';

class DeteksiService {
  static final dio.Dio _dio = dio.Dio();
  // Sesuaikan prefix jika kamu mendaftarkannya di app.py (misal: /api/deteksi)
  static const String _endpoint = '/api/deteksi/predict'; 

  static Future<Map<String, dynamic>?> uploadImage(String filePath, String token) async {
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
        // Best practice: Kirim token JWT lewat header Authorization Bearer
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
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

  // --- TAMBAHAN BARU: FUNGSI UNTUK AMBIL RIWAYAT DETEKSI ---
  static Future<Map<String, dynamic>?> getHistory(String token) async {
    try {
      // Menyesuaikan endpoint ke /api/deteksi/history
      final String historyEndpoint = '/api/deteksi/history';

      final response = await _dio.get(
        '${AppConfig.baseUrl}$historyEndpoint',
        // Mengirim token JWT untuk identitas user di backend
        options: dio.Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data; // Mengembalikan json utama yang berisi array history
      }
      return null;
    } catch (e) {
      print("Error get history: $e");
      return null;
    }
  }
}