import 'package:batikara/app/data/provider/api_provider.dart';
import 'package:dio/dio.dart';
import 'package:batikara/app/data/models/mapping_model.dart';

class MappingService {
  
  // ===========================================================================
  // 1. Fungsi Ambil Data Lokasi
  // ===========================================================================
  Future<List<MappingModelData>> fetchLocations({String query = ''}) async {
    try {
      // Menggunakan ApiProvider.dio agar otomatis diselipi token jika user sudah login
      final response = await ApiProvider.dio.get(
        '/api/mappings',
        queryParameters: query.isNotEmpty ? {'q': query} : null,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = response.data;
        final List<dynamic> locationsJson = decodedData['data'];

        return locationsJson
            .map((json) => MappingModelData.fromJson(json))
            .toList();
      } else {
        throw Exception('Gagal memuat data lokasi dari server');
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Terjadi kesalahan pada jaringan');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // ===========================================================================
  // 2. Fungsi Kirim Ulasan Baru (POST)
  // ===========================================================================
  Future<Map<String, dynamic>> submitReview({
    required String mappingId,
    required int rating,
    required String comment,
  }) async {
    try {
      // Lebih bersih: Tidak perlu mengambil token manual & setting Options header lagi
      final response = await ApiProvider.dio.post(
        '/api/mappings/$mappingId/reviews',
        data: {
          'rating': rating, 
          'comment': comment,
        },
      );

      if (response.data is Map<String, dynamic>) {
        return response.data;
      }
      return {"status": "success", "message": "Ulasan diproses."};
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        "status": "error",
        "message": "Terjadi kesalahan internal aplikasi: $e",
      };
    }
  }

  // ===========================================================================
  // 3. Fungsi Update Ulasan Lama (PUT)
  // ===========================================================================
  Future<Map<String, dynamic>> updateReview({
    required String mappingId,
    required int rating,
    required String comment,
  }) async {
    try {
      // Otomatis terintegrasi silent-refresh token jika mendadak expired (401)
      final response = await ApiProvider.dio.put(
        '/api/mappings/$mappingId/reviews',
        data: {
          'rating': rating, 
          'comment': comment,
        },
      );

      if (response.data is Map<String, dynamic>) {
        return response.data;
      }
      return {"status": "success", "message": "Ulasan berhasil diperbarui!"};
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return {
        "status": "error",
        "message": "Terjadi kesalahan internal aplikasi: $e",
      };
    }
  }

  // ===========================================================================
  // KUNCI CLEAN CODE: Helper khusus untuk merapikan handling error Dio
  // ===========================================================================
  Map<String, dynamic> _handleDioError(DioException e) {
    if (e.response != null && e.response!.data != null) {
      if (e.response!.data is Map) {
        return Map<String, dynamic>.from(e.response!.data);
      } else {
        return {"status": "error", "message": e.response!.data.toString()};
      }
    }
    return {
      "status": "error",
      "message": "Gagal terhubung ke server. Pastikan server API/Flask menyala.",
    };
  }
}