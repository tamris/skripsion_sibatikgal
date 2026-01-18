import 'package:batikara/app/routes/app_pages.dart';
import 'package:get/get.dart';

class LoginPageController extends GetxController {
  // State untuk melihat password
  var isPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void login() {
    // Di sini nanti tempat validasi email/password atau hit ke API
    // Jika berhasil, pindah ke Home:
    Get.offAllNamed(Routes.HOME);
  }
}
