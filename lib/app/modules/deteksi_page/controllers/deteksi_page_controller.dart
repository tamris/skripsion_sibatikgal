import 'package:batikara/app/data/config/app_config.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get_storage/get_storage.dart';
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

  // State untuk melacak langkah pemrosesan (0 sampai 3)
  var loadingStep = 0.obs; 

  final ImagePicker _picker = ImagePicker();
  final storage = GetStorage();

  String _getStoredToken() {
    return storage.read('token') ?? '';
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      selectedImagePath.value = image.path;
      isDetected.value = false;
      isLoading.value = true; 
      loadingStep.value = 0; // Langkah 1: Gambar diterima

      final token = _getStoredToken();

      // 1. Tembak API ke Backend secara asinkronus (berjalan di background)
      // Jadi selagi API loading, kita bisa mainin animasi delay di bawahnya
      final apiResponseFuture = DeteksiService.uploadImage(image.path, token);

      // 2. --- TRICK ARTIFICIAL DELAY UNTUK UX SLOW MOTION ---
      
      // Jeda 1.2 detik di langkah "Gambar diterima"
      await Future.delayed(const Duration(milliseconds: 1200));
      loadingStep.value = 1; // Pindah ke langkah 2: Pra-pemrosesan gambar

      // Jeda 1.5 detik di langkah "Pra-pemrosesan gambar" (Biar kesannya AI lagi konversi citra)
      await Future.delayed(const Duration(milliseconds: 1500));
      loadingStep.value = 2; // Pindah ke langkah 3: Mendeteksi motif...

      // Jeda 1.2 detik di langkah "Mendeteksi motif..."
      await Future.delayed(const Duration(milliseconds: 1200));

      // 3. Tunggu hingga response asli dari API benar-benar selesai
      final result = await apiResponseFuture;

      if (result != null) {
        loadingStep.value = 3; // Pindah ke langkah terakhir: Menyiapkan hasil
        
        // Kasih jeda tipis semenit sebelum ngebuka hasil deteksi biar mulus
        await Future.delayed(const Duration(milliseconds: 800));

        motifName.value = result['nama'] ?? 'Tidak Diketahui';
        filosofi.value = result['makna'] ?? 'Makna tidak ditemukan.';
        confidence.value = result['confidence'] ?? '0%';
        isDetected.value = true;

        fetchHistory(); // Segarkan riwayat deteksi di bawah
      } else {
        Get.snackbar("Error", "Gagal mendeteksi gambar.");
      }

      isLoading.value = false; // Matikan loading screen, UI otomatis pindah ke hasil/idle
    }
  }

  Future<void> fetchHistory() async {
    try {
      isLoadingHistory.value = true;
      final token = _getStoredToken();
      final result = await DeteksiService.getHistory(token);

      if (result != null && result['data'] != null) {
        final List<dynamic> rawData = result['data'];
        
        final formattedData = rawData.map((item) {
          final String rawImagePath = item['banner_image_url'] ?? '';
          final String fullImageUrl = rawImagePath.isNotEmpty 
              ? '${AppConfig.baseUrl}$rawImagePath' 
              : '';

          final String relativeTime = _convertToRelativeTime(item['created_at']);

          return {
            ...item,
            'full_image_url': fullImageUrl,
            'waktu_relatif': relativeTime,
          };
        }).toList();

        historyList.assignAll(formattedData);
      }
    } catch (e) {
      print("Error pada controller fetchHistory: $e");
    } finally {
      isLoadingHistory.value = false;
    }
  }

  String _convertToRelativeTime(String? createdAtStr) {
    if (createdAtStr == null || createdAtStr.isEmpty) return 'Baru saja';
    try {
      DateTime dateTime = DateTime.parse(createdAtStr).toLocal();
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
        List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
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