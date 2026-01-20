// lib/app/modules/deteksi_page/controllers/deteksi_page_controller.dart

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/service/deteksi_service.dart';

class DeteksiPageController extends GetxController {
  var selectedImagePath = ''.obs;
  var isDetected = false.obs;
  var isLoading = false.obs; // Tambahkan loading state

  var motifName = ''.obs;
  var filosofi = ''.obs;
  var confidence = ''.obs;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    
    if (image != null) {
      selectedImagePath.value = image.path;
      isDetected.value = false;
      isLoading.value = true; // Mulai loading

      // Panggil Service untuk deteksi asli
      final result = await DeteksiService.uploadImage(image.path);

      if (result != null) {
        motifName.value = result['nama'] ?? 'Tidak Diketahui';
        filosofi.value = result['makna'] ?? 'Makna tidak ditemukan.';
        confidence.value = result['confidence'] ?? '0%';
        isDetected.value = true;
      } else {
        Get.snackbar("Error", "Gagal mendeteksi gambar.");
      }
      
      isLoading.value = false; // Selesai loading
    }
  }

  void resetDetection() {
    selectedImagePath.value = '';
    isDetected.value = false;
    isLoading.value = false;
  }
}