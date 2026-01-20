import 'package:batikara/app/data/service/register_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:batikara/app/routes/app_pages.dart';


class RegsiterPageController extends GetxController {
  // Controller untuk menangkap input teks
  final usernameC = TextEditingController();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  final confirmPasswordC = TextEditingController();

  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;
  var isLoading = false.obs;

  void togglePasswordVisibility() => isPasswordHidden.value = !isPasswordHidden.value;
  void toggleConfirmPasswordVisibility() => isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;

  void register() async {
    final username = usernameC.text.trim();
    final email = emailC.text.trim();
    final password = passwordC.text.trim();
    final confirmPassword = confirmPasswordC.text.trim();

    // Validasi sederhana
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Semua field wajib diisi");
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar("Error", "Konfirmasi password tidak cocok");
      return;
    }

    isLoading.value = true;
    try {
      final response = await RegisterService.register({
        'username': username,
        'email': email,
        'password': password,
      });

      if (response.statusCode == 201) {
        Get.snackbar("Sukses", response.data['msg']);
        // Pindah ke OTP dengan mengirim email sebagai argument
        Get.toNamed(Routes.OTP_VERIFIKASI, arguments: email);
      } else {
        Get.snackbar("Gagal", response.data['msg'] ?? "Terjadi kesalahan");
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal terhubung ke server");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    usernameC.dispose();
    emailC.dispose();
    passwordC.dispose();
    confirmPasswordC.dispose();
    super.onClose();
  }
}