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

  void togglePasswordVisibility() =>
      isPasswordHidden.value = !isPasswordHidden.value;
  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;

  void showCustomSnackbar(String title, String message,
      {bool isError = false}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: isError ? Color(0xFFFFEBEE) : Color(0xFFFFF3E0),
      colorText: isError ? Color(0xFFC62828) : Color(0xFF8D5D46),
      borderRadius: 16,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      icon: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isError
              ? Color(0xFFC62828).withOpacity(0.1)
              : Color(0xFF8D5D46).withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isError
              ? Icons.error_outline_rounded
              : Icons.check_circle_outline_rounded,
          color: isError ? Color(0xFFC62828) : Color(0xFF8D5D46),
          size: 24,
        ),
      ),
      shouldIconPulse: false,
      duration: Duration(seconds: 3),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInCirc,
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
      ],
      titleText: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: isError ? Color(0xFFC62828) : Color(0xFF8D5D46),
        ),
      ),
      messageText: Text(
        message,
        style: TextStyle(
          fontSize: 14,
          color: isError ? Color(0xFFD32F2F) : Color(0xFF6D4C41),
          height: 1.4,
        ),
      ),
    );
  }

  void register() async {
    final username = usernameC.text.trim();
    final email = emailC.text.trim();
    final password = passwordC.text.trim();
    final confirmPassword = confirmPasswordC.text.trim();

    // Validasi sederhana
    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      showCustomSnackbar("Error", "Semua field wajib diisi", isError: true);
      return;
    }

    if (password != confirmPassword) {
      showCustomSnackbar("Error", "Konfirmasi password tidak cocok",
          isError: true);
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
        showCustomSnackbar("Sukses", response.data['msg']);
        // Pindah ke OTP dengan mengirim email sebagai argument
        Get.toNamed(Routes.OTP_VERIFIKASI, arguments: email);
      } else {
        showCustomSnackbar("Gagal", response.data['msg'] ?? "Terjadi kesalahan",
            isError: true);
      }
    } catch (e) {
      showCustomSnackbar("Error", "Gagal terhubung ke server", isError: true);
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
