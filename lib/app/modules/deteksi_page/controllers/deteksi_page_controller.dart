import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DeteksiPageController extends GetxController {
  // Simpan file gambar yang dipilih
  var selectedImagePath = ''.obs;
  var isDetected = false.obs;

  // Data dummy hasil deteksi
  var motifName = 'Poci Tahu Aci'.obs;
  var filosofi =
      'Motif poci merepresentasikan Tegal sebagai daerah yang sangat identik dengan tradisi minum teh menggunakan poci tanah liat (teh poci). Benda ini memiliki kedekatan emosional dan menjadi ikon khas wilayah tersebut, sama halnya dengan tahu aci.'
          .obs;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      selectedImagePath.value = image.path;
      // Simulasi loading deteksi
      isDetected.value = true;
    }
  }

  void resetDetection() {
    selectedImagePath.value = '';
    isDetected.value = false;
  }
}
