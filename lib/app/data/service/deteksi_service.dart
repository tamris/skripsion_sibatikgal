import 'package:dio/dio.dart';
import '../provider/api_provider.dart';

class DeteksiService {
  static const String _endpoint = '/api/deteksi/predict';

  static Future<Map<String, dynamic>?> uploadImage(
    String filePath,
  ) async {
    try {
      await ApiProvider.refreshToken();
      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          filePath,
          filename: filePath.split('/').last,
        ),
      });

      final response = await ApiProvider.dio.post(
        _endpoint,
        data: formData,
      );

      if (response.statusCode == 200) {
        return response.data;
      }

      return null;
    } catch (e) {
      print("Error upload: $e");

      return null;
    }
  }

  static Future<Map<String, dynamic>?> getHistory() async {
    try {
      final response = await ApiProvider.dio.get(
        '/api/deteksi/history',
      );

      if (response.statusCode == 200) {
        return response.data;
      }

      return null;
    } catch (e) {
      print("Error get history: $e");

      return null;
    }
  }

  static Future<bool> deleteHistory(String historyId) async {
    try {
      final response = await ApiProvider.dio.delete(
        '/api/deteksi/history/$historyId',
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return true;
      }
      return false;
    } catch (e) {
      print("Error delete history ID $historyId: $e");
      return false;
    }
  }
}
