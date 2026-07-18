import 'package:batikara/app/data/provider/api_provider.dart';
import '../models/studio_model.dart';


class StudioService {
  // HAPUS: final Dio _dio = Dio(); -> Diganti menggunakan ApiProvider.dio secara global

  // 💡 1. FETCH LIST MOTIF BATIK
  Future<List<StudioBatikModel>> fetchCanvasList() async {
    try {
      // Menggunakan ApiProvider.dio dengan path relatif
      final response = await ApiProvider.dio.get('/api/studio/canvas-list');

      if (response.statusCode == 200) {
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

  // Parameter tokenJwt tetap ada agar tidak mengubah logika pemanggilan dari luar
  Future<List<StudioBatikModel>> fetchMySavedDrafts(String tokenJwt) async {
    try {
      // Menggunakan ApiProvider.dio. 
      // Interceptor ApiProvider akan otomatis menimpa tokenJwt jika ada token baru hasil refresh.
      final response = await ApiProvider.dio.get('/api/studio/my-drafts');

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
      final response = await ApiProvider.dio.get(
        '/api/studio/get-draft',
        queryParameters: {'batik_id': batikId},
      );

      if (response.statusCode == 200) {
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
      final response = await ApiProvider.dio.post(
        '/api/studio/save-draft',
        data: {"batik_id": batikId, "canvas_json": canvasJson},
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Eror menyimpan draf ke database: $e');
    }
  }
}