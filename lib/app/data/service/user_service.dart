import 'package:dio/dio.dart';
import '../provider/api_provider.dart';

class UserService {
  // 1. Fungsi Ambil Data Profile
  static Future<Response> getProfile() async {
    try {
      final response = await ApiProvider.dio.get('/api/user/me');
      return response;
    } on DioException catch (e) {
      if (e.response != null) return e.response!;
      rethrow;
    }
  }

  static Future<Response?> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await ApiProvider.dio.post(
        '/api/user/change-password',
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
          'confirm_password': confirmPassword,
        },
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) return e.response;
      rethrow;
    } catch (e) {
      print("Error pada layer UserService changePassword: $e");
      return null;
    }
  }

  // 2. Fungsi Update Data Profile (Multipart Form Data)
  static Future<Response> updateProfile({
    required String username,
    required String gender,
    required String tanggalLahir,
    String?
        imagePath, // Path file lokal dari smartphone (bisa null kalau gak ganti foto)
  }) async {
    try {
      // Susun Map Form Data teks biasa
      Map<String, dynamic> formDataMap = {
        'username': username,
        'gender': gender,
        'tanggal_lahir': tanggalLahir,
      };

      // Jika user memilih foto baru, bungkus filenya ke MultipartFile
      if (imagePath != null && imagePath.isNotEmpty) {
        formDataMap['profile_picture'] = await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last, // Ambil nama asli filenya
        );
      }

      final formData = FormData.fromMap(formDataMap);

      final response = await ApiProvider.dio.post(
        '/api/user/me',
        data: formData,
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) return e.response!;
      rethrow;
    }
  }
}
