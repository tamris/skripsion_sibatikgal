import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UbahSandiController extends GetxController {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  var isOldPasswordHidden = true.obs;
  var isNewPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  // State baru untuk tingkat kekuatan password: 0 = kosong, 1 = lemah, 2 = cukup kuat, 3 = kuat
  var passwordStrength = 0.obs;
  var isConfirmPasswordNotEmpty = false.obs;
  var isPasswordMatch = true.obs;

  void toggleOldPasswordVisibility() => isOldPasswordHidden.value = !isOldPasswordHidden.value;
  void toggleNewPasswordVisibility() => isNewPasswordHidden.value = !isNewPasswordHidden.value;
  void toggleConfirmPasswordVisibility() => isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;

  @override
  void onInit() {
    super.onInit();
    
    newPasswordController.addListener(() {
      calculatePasswordStrength(newPasswordController.text);
      checkPasswordMatch();
    });

    confirmPasswordController.addListener(() {
      isConfirmPasswordNotEmpty.value = confirmPasswordController.text.isNotEmpty;
      checkPasswordMatch();
    });
  }

  // Mengukur kekuatan sandi berdasarkan panjang teks inputan
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
    if (newPasswordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
      isPasswordMatch.value = true; 
    } else {
      isPasswordMatch.value = newPasswordController.text == confirmPasswordController.text;
    }
  }

  void simpanSandi() {
    if (oldPasswordController.text.isEmpty || newPasswordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
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
    print("Sandi berhasil diubah");
  }

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}