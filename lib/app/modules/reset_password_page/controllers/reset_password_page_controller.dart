import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:batikara/app/routes/app_pages.dart';
import '../../../data/service/lupa_sandi_service.dart';

class ResetPasswordPageController extends GetxController {
  var currentStep = 0.obs; // 0: Email, 1: OTP, 2: Sandi Baru
  var isLoading = false.obs;

  // --- Step 0: Email Controller ---
  final emailC = TextEditingController();

  // --- Step 1: OTP Controllers & Focus Nodes ---
  final otp1 = TextEditingController();
  final otp2 = TextEditingController();
  final otp3 = TextEditingController();
  final otp4 = TextEditingController();
  final otp5 = TextEditingController();
  final otp6 = TextEditingController();

  final fn1 = FocusNode();
  final fn2 = FocusNode();
  final fn3 = FocusNode();
  final fn4 = FocusNode();
  final fn5 = FocusNode();
  final fn6 = FocusNode();

  // --- Step 2: New Password Controllers ---
  final passwordC = TextEditingController();
  final confirmPasswordC = TextEditingController();

  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

  // --- Snackbar Custom (Konsisten dengan Register) ---
  void showCustomSnackbar(String title, String message,
      {bool isError = false}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor:
          isError ? const Color(0xFFFFEBEE) : const Color(0xFFFFF3E0),
      colorText: isError ? const Color(0xFFC62828) : const Color(0xFF8D5D46),
      borderRadius: 16,
      margin: const EdgeInsets.all(16),
      icon: Icon(isError ? Icons.error_outline : Icons.check_circle_outline,
          color: isError ? const Color(0xFFC62828) : const Color(0xFF8D5D46)),
    );
  }

  // --- Logic Step 0: Kirim OTP ---
  void sendOtp() async {
    if (!GetUtils.isEmail(emailC.text.trim())) {
      showCustomSnackbar("Error", "Format email tidak valid", isError: true);
      return;
    }
    isLoading.value = true;
    final res = await LupaSandiService.forgotPassword(emailC.text.trim());
    isLoading.value = false;

    if (res.statusCode == 200) {
      showCustomSnackbar("Sukses", res.data['msg']);
      currentStep.value = 1; // Pindah ke tampilan OTP
    } else {
      showCustomSnackbar("Gagal", res.data['msg'] ?? "Email tidak ditemukan",
          isError: true);
    }
  }

  // --- Logic Step 1: Verifikasi OTP ---
  void verifyOtp() async {
    // Menggabungkan 6 digit dari masing-masing controller
    String code =
        otp1.text + otp2.text + otp3.text + otp4.text + otp5.text + otp6.text;

    if (code.length < 6) {
      showCustomSnackbar("Error", "Masukkan 6 digit kode OTP", isError: true);
      return;
    }

    isLoading.value = true;
    final res = await LupaSandiService.verifyResetOtp(emailC.text.trim(), code);
    isLoading.value = false;

    if (res.statusCode == 200) {
      currentStep.value = 2; // Pindah ke tampilan Password Baru
    } else {
      showCustomSnackbar(
          "Gagal", res.data['msg'] ?? "Kode OTP salah atau kadaluarsa",
          isError: true);
    }
  }

  // --- Logic Step 2: Reset Password ---
  void handleResetPassword() async {
    if (passwordC.text.isEmpty || confirmPasswordC.text.isEmpty) {
      showCustomSnackbar("Error", "Password tidak boleh kosong", isError: true);
      return;
    }

    if (passwordC.text != confirmPasswordC.text) {
      showCustomSnackbar("Error", "Konfirmasi password tidak cocok",
          isError: true);
      return;
    }

    isLoading.value = true;
    // Menggunakan kode OTP yang sama untuk verifikasi akhir di backend
    String code =
        otp1.text + otp2.text + otp3.text + otp4.text + otp5.text + otp6.text;

    final res = await LupaSandiService.resetPassword(
        emailC.text.trim(), code, passwordC.text.trim());
    isLoading.value = false;

    if (res.statusCode == 200) {
      showCustomSnackbar("Sukses", "Kata sandi berhasil diubah");
      Get.until((route) => Get.currentRoute == Routes.LOGIN_PAGE);
    } else {
      showCustomSnackbar("Gagal", res.data['msg'] ?? "Terjadi kesalahan",
          isError: true);
    }
  }

  @override
  void onClose() {
    // Penting: Dispose semua controller dan focus node agar tidak memory leak
    emailC.dispose();
    otp1.dispose();
    otp2.dispose();
    otp3.dispose();
    otp4.dispose();
    otp5.dispose();
    otp6.dispose();
    fn1.dispose();
    fn2.dispose();
    fn3.dispose();
    fn4.dispose();
    fn5.dispose();
    fn6.dispose();
    passwordC.dispose();
    confirmPasswordC.dispose();
    super.onClose();
  }
}
