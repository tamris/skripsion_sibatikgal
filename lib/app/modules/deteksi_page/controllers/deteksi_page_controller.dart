import 'package:batikara/app/data/config/app_config.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/service/deteksi_service.dart';

class DeteksiPageController extends GetxController {
  var selectedImagePath = ''.obs;
  var isDetected = false.obs;
  var isLoading = false.obs;

  var motifName = ''.obs;
  var filosofi = ''.obs;
  var confidence = ''.obs;

  var historyList = <dynamic>[].obs;
  var isLoadingHistory = false.obs;

  // State loading step
  var loadingStep = 0.obs;

  final ImagePicker _picker = ImagePicker();

  // =========================
  // PICK IMAGE
  // =========================

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      selectedImagePath.value = image.path;

      isDetected.value = false;
      isLoading.value = true;

      // Step 1
      loadingStep.value = 0;

      // API berjalan di background
      final apiResponseFuture = DeteksiService.uploadImage(
        image.path,
      );

      // =========================
      // ARTIFICIAL LOADING UX
      // =========================

      await Future.delayed(
        const Duration(milliseconds: 1200),
      );

      // Step 2
      loadingStep.value = 1;

      await Future.delayed(
        const Duration(milliseconds: 1500),
      );

      // Step 3
      loadingStep.value = 2;

      await Future.delayed(
        const Duration(milliseconds: 1200),
      );

      // Tunggu response asli
      final result = await apiResponseFuture;

      if (result != null) {
        // Step 4
        loadingStep.value = 3;

        await Future.delayed(
          const Duration(milliseconds: 800),
        );

        motifName.value = result['nama'] ?? 'Tidak Diketahui';

        filosofi.value = result['makna'] ?? 'Makna tidak ditemukan.';

        confidence.value = result['confidence'] ?? '0%';

        isDetected.value = true;

        // Refresh history
        fetchHistory();
      } else {
        Get.snackbar(
          "Deteksi Gagal",
          "Gagal mendeteksi gambar. Silakan coba ulangi lagi.",
        );
      }

      isLoading.value = false;
    }
  }

  // =========================
  // FETCH HISTORY
  // =========================

  Future<void> fetchHistory() async {
    try {
      isLoadingHistory.value = true;

      final result = await DeteksiService.getHistory();

      if (result != null && result['data'] != null) {
        final List<dynamic> rawData = result['data'];

        final formattedData = rawData.map((item) {
          final String rawImagePath = item['banner_image_url'] ?? '';

          final String fullImageUrl = rawImagePath.isNotEmpty
              ? '${AppConfig.baseUrl}$rawImagePath'
              : '';

          final String relativeTime = _convertToRelativeTime(
            item['created_at'],
          );

          return {
            ...item,
            'full_image_url': fullImageUrl,
            'waktu_relatif': relativeTime,
          };
        }).toList();

        historyList.assignAll(
          formattedData,
        );
      }
    } catch (e) {
      print(
        "Error pada controller fetchHistory: $e",
      );
    } finally {
      isLoadingHistory.value = false;
    }
  }

  Future<void> deleteSelectedHistory(List<dynamic> ids) async {
    try {
      isLoadingHistory.value = true;

      // Eksekusi semua request DELETE secara bersamaan di background
      final futures =
          ids.map((id) => DeteksiService.deleteHistory(id.toString()));
      await Future.wait(futures);

      // Setelah selesai hapus di server, tarik data history terbaru yang bersih
      await fetchHistory();
    } catch (e) {
      print("Error mass delete history pada controller: $e");
    } finally {
      isLoadingHistory.value = false;
    }
  }

  // =========================
  // RELATIVE TIME
  // =========================

  String _convertToRelativeTime(
    String? createdAtStr,
  ) {
    if (createdAtStr == null || createdAtStr.isEmpty) {
      return 'Baru saja';
    }

    try {
      DateTime dateTime = DateTime.parse(
        createdAtStr,
      ).toLocal();

      DateTime now = DateTime.now();

      Duration difference = now.difference(dateTime);

      if (difference.inSeconds < 60) {
        return 'Baru saja';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes} menit lalu';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} jam lalu';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} hari lalu';
      } else if (difference.inDays < 30) {
        int weeks = (difference.inDays / 7).floor();

        return '$weeks minggu lalu';
      } else {
        List<String> months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'Mei',
          'Jun',
          'Jul',
          'Agu',
          'Sep',
          'Okt',
          'Nov',
          'Des'
        ];

        return '${dateTime.day} ${months[dateTime.month - 1]}';
      }
    } catch (e) {
      return 'Baru saja';
    }
  }

  @override
  void onInit() {
    super.onInit();

    fetchHistory();
  }
}
