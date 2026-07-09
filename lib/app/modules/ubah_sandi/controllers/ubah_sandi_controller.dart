import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/service/user_service.dart';

class UbahSandiController extends GetxController {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isOldPasswordHidden = true.obs;
  var isNewPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  // State tingkat kekuatan password: 0 = kosong, 1 = lemah, 2 = cukup kuat, 3 = kuat
  var passwordStrength = 0.obs;
  var isConfirmPasswordNotEmpty = false.obs;
  var isPasswordMatch = true.obs;

  // State baru untuk menampung kondisi loading request internet
  var isLoading = false.obs;

  void toggleOldPasswordVisibility() =>
      isOldPasswordHidden.value = !isOldPasswordHidden.value;
  void toggleNewPasswordVisibility() =>
      isNewPasswordHidden.value = !isNewPasswordHidden.value;
  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;

  @override
  void onInit() {
    super.onInit();

    newPasswordController.addListener(() {
      calculatePasswordStrength(newPasswordController.text);
      checkPasswordMatch();
    });

    confirmPasswordController.addListener(() {
      isConfirmPasswordNotEmpty.value =
          confirmPasswordController.text.isNotEmpty;
      checkPasswordMatch();
    });
  }

  void calculatePasswordStrength(String value) {
    if (value.isEmpty) {
      passwordStrength.value = 0;
    } else if (value.length < 6) {
      passwordStrength.value = 1; // Lemah
    } else if (value.length <= 9) {
      passwordStrength.value = 2; // Cukup kuat (Sesuai mockup)
    } else {
      passwordStrength.value = 3; // Sangat Kuat
    }
  }

  void checkPasswordMatch() {
    if (newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      isPasswordMatch.value = true;
    } else {
      isPasswordMatch.value =
          newPasswordController.text == confirmPasswordController.text;
    }
  }

  // =====================================================================
  // SINKRONISASI API: Menembak data input ke server Flask MongoDB
  // =====================================================================
  void simpanSandi() async {
    if (oldPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar('Gagal', 'Semua field wajib diisi');
      return;
    }
    if (passwordStrength.value < 2) {
      Get.snackbar('Gagal', 'Kata sandi terlalu lemah');
      return;
    }
    if (!isPasswordMatch.value) {
      Get.snackbar('Gagal', 'Konfirmasi kata sandi tidak cocok');
      return;
    }

    try {
      isLoading.value = true;

      // Eksekusi pengiriman data ke backend melalui UserService
      final response = await UserService.changePassword(
        currentPassword: oldPasswordController.text,
        newPassword: newPasswordController.text,
        confirmPassword: confirmPasswordController.text,
      );

      if (response != null && response.statusCode == 200) {
        // Jika sukses ganti kata sandi di server
        Get.back(); // Kembali ke halaman pengaturan profil
        Get.snackbar(
          'Sukses',
          response.data['msg'] ?? 'Kata sandi berhasil diperbarui',
          backgroundColor: const Color(0xFF1C1308),
          colorText: const Color(0xFFFBBF24),
          snackPosition: SnackPosition.BOTTOM,
        );

        // Bersihkan controller input setelah berhasil
        oldPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
      } else {
        // Jika gagal (Misal: Password lama salah atau bad request karakter)
        String errorMsg = response?.data['msg'] ?? 'Terjadi kesalahan sistem';
        Get.snackbar(
          'Gagal Mengubah Sandi',
          errorMsg,
          backgroundColor: const Color(0xFFC2612D),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Tidak dapat terhubung ke server');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
