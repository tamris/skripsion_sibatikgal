import 'package:dio/dio.dart';
import 'package:batikara/app/data/config/app_config.dart';
import '../models/studio_model.dart';

class StudioService {
  final Dio _dio = Dio();

  // 💡 1. FETCH LIST MOTIF BATIK
  Future<List<StudioBatikModel>> fetchCanvasList() async {
    try {
      final response = await _dio.get(
        '${AppConfig.baseUrl}/api/studio/canvas-list',
      );

      if (response.statusCode == 200) {
        // Dio otomatis melakukan json decode, jadi langsung ambil List data-nya
        final List<dynamic> batikList = response.data['data'];
        return batikList
            .map((item) => StudioBatikModel.fromJson(item))
            .toList();
      } else {
        throw Exception('Gagal memuat list sketsa dari server');
      }
    } catch (e) {
      throw Exception('Eror koneksi list studio: $e');
    }
  }

  Future<List<StudioBatikModel>> fetchMySavedDrafts(String tokenJwt) async {
    try {
      final response = await _dio.get(
        '${AppConfig.baseUrl}/api/studio/my-drafts',
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $tokenJwt",
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> draftList = response.data['data'];
        return draftList
            .map((item) => StudioBatikModel.fromJson(item))
            .toList();
      } else {
        throw Exception('Gagal memuat draf dari server');
      }
    } catch (e) {
      throw Exception('Eror koneksi draf: $e');
    }
  }

  // 💡 2. LOAD USER CANVAS DRAFT (Berbasis JWT & Batik ID)
  Future<dynamic> loadUserCanvasDraft(String batikId, String tokenJwt) async {
    try {
      final response = await _dio.get(
        '${AppConfig.baseUrl}/api/studio/get-draft',
        queryParameters: {'batik_id': batikId},
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $tokenJwt",
          },
        ),
      );

      if (response.statusCode == 200) {
        // Langsung kembalikan datanya (bisa berupa List atau Map sesuai struktur Flask)
        return response.data['canvas_json'];
      }
      return null;
    } catch (e) {
      throw Exception('Eror load draf dari database: $e');
    }
  }

  // 💡 3. SAVE CANVAS DRAFT TO DATABASE (Berbasis JWT & Batik ID)
  Future<bool> saveCanvasDraft(
    String batikId,
    String canvasJson,
    String tokenJwt,
  ) async {
    try {
      final response = await _dio.post(
        '${AppConfig.baseUrl}/api/studio/save-draft',
        data: {"batik_id": batikId, "canvas_json": canvasJson},
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization":
                "Bearer $tokenJwt", // 🔒 Token JWT dilempar via header
          },
        ),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Eror menyimpan draf ke database: $e');
    }
  }
}