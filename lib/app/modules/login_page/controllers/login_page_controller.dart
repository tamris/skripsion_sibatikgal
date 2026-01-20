import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:batikara/app/routes/app_pages.dart';
import '../../../data/service/login_service.dart';

class LoginPageController extends GetxController {
  // Controller untuk input text
  final emailC = TextEditingController();
  final passwordC = TextEditingController();

  var isPasswordHidden = true.obs;
  var isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void login() async {
    final email = emailC.text.trim();
    final password = passwordC.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Email dan password tidak boleh kosong");
      return;
    }

    isLoading.value = true;
    try {
      final response = await LoginService.login(email, password);

      if (response.statusCode == 200) {
        // Simpan token (bisa pakai GetStorage) lalu pindah ke Home
        // Contoh: storage.write('token', response.data['access_token']);
        Get.offAllNamed(Routes.HOME);
      } else if (response.statusCode == 403) {
        // User belum verifikasi OTP
        Get.snackbar("Verifikasi", response.data['msg']);
        // Arahkan ke halaman OTP jika perlu
        Get.toNamed(Routes.OTP_VERIFIKASI, arguments: email);
      } else {
        // Email atau password salah
        Get.snackbar(
            "Login Gagal", response.data['msg'] ?? "Terjadi kesalahan");
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal terhubung ke server");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailC.dispose();
    passwordC.dispose();
    super.onClose();
  }
}
