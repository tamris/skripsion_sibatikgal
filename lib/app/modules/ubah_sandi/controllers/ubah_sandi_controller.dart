import 'package:get/get.dart';

class UbahSandiController extends GetxController {
  // State untuk visibilitas password
  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  void togglePasswordVisibility() => isPasswordHidden.value = !isPasswordHidden.value;
  void toggleConfirmPasswordVisibility() => isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;

  void simpanSandi() {
    // Logika simpan sandi di sini
    print("Sandi berhasil diubah");
  }
}