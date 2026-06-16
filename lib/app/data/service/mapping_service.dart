import 'package:dio/dio.dart';
import 'package:batikara/app/data/config/app_config.dart';
import 'package:batikara/app/data/models/mapping_model.dart';
import 'package:get_storage/get_storage.dart';

class MappingService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  final _storage = GetStorage();

  Future<List<MappingModelData>> fetchLocations({String query = ''}) async {
    try {
      final response = await _dio.get(
        '/api/mappings',
        queryParameters: {'q': query},
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
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> submitReview({
    required String mappingId,
    required int rating,
    required String comment,
  }) async {
    try {
      String? token = _storage.read('token');

      final response = await _dio.post(
        '${AppConfig.baseUrl}/api/mappings/$mappingId/reviews',
        data: {'rating': rating, 'comment': comment},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.data is Map<String, dynamic>) {
        return response.data;
      }
      return {"status": "success", "message": "Ulasan diproses."};
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null) {
        if (e.response!.data is Map) {
          return Map<String, dynamic>.from(e.response!.data);
        } else {
          return {"status": "error", "message": e.response!.data.toString()};
        }
      }
      return {
        "status": "error",
        "message": "Gagal terhubung ke server. Pastikan server Flask menyala.",
      };
    } catch (e) {
      return {
        "status": "error",
        "message": "Terjadi kesalahan internal aplikasi: $e",
      };
    }
  }

  // ===========================================================================
  // KUNCI BEST PRACTICE: Endpoint PUT untuk Update Review Lama User
  // ===========================================================================
  Future<Map<String, dynamic>> updateReview({
    required String mappingId,
    required int rating,
    required String comment,
  }) async {
    try {
      String? token = _storage.read('token');

      final response = await _dio.put(
        '${AppConfig.baseUrl}/api/mappings/$mappingId/reviews',
        data: {'rating': rating, 'comment': comment},
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.data is Map<String, dynamic>) {
        return response.data;
      }
      return {"status": "success", "message": "Ulasan berhasil diperbarui!"};
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null) {
        if (e.response!.data is Map) {
          return Map<String, dynamic>.from(e.response!.data);
        } else {
          return {"status": "error", "message": e.response!.data.toString()};
        }
      }
      return {
        "status": "error",
        "message": "Gagal terhubung ke server. Pastikan server Flask menyala.",
      };
    } catch (e) {
      return {
        "status": "error",
        "message": "Terjadi kesalahan internal aplikasi: $e",
      };
    }
  }
}