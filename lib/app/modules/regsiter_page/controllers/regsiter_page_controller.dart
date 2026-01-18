import 'package:get/get.dart';

class RegsiterPageController extends GetxController {
  // State untuk sembunyikan password
  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  void togglePasswordVisibility() => isPasswordHidden.value = !isPasswordHidden.value;
  void toggleConfirmPasswordVisibility() => isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;

  void register() {
    // Logika pendaftaran di sini
    print("Mencoba mendaftar...");
  }
}