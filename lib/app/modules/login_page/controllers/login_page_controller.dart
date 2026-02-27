import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:batikara/app/routes/app_pages.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/service/login_service.dart';
import '../../../data/service/oauth_service.dart';

class LoginPageController extends GetxController {
  // Controller untuk input text
  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  final storage = GetStorage();
  var isPasswordHidden = true.obs;
  var isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

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
              ? Color(0xFFC62828).withValues(alpha: 0.1)
              : Color(0xFF8D5D46).withValues(alpha: 0.1),
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
          color: Colors.black.withValues(alpha: 0.1),
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

  void login() async {
    final email = emailC.text.trim();
    final password = passwordC.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showCustomSnackbar("Error", "Email dan password tidak boleh kosong",
          isError: true);
      return;
    }

    isLoading.value = true;
    try {
      final response = await LoginService.login(email, password);

      if (response.statusCode == 200) {
        storage.write('token', response.data['access_token']);
        storage.write('user_data', response.data['user']);

        showCustomSnackbar("Berhasil",
            "Selamat datang, ${response.data['user']['username']}!");
        Get.offAllNamed(Routes.HOME);
      } else if (response.statusCode == 403) {
        // User belum verifikasi OTP
        showCustomSnackbar("Verifikasi", response.data['msg']);
        // Arahkan ke halaman OTP jika perlu
        Get.toNamed(Routes.OTP_VERIFIKASI, arguments: email);
      } else {
        // Email atau password salah
        showCustomSnackbar(
            "Login Gagal", response.data['msg'] ?? "Terjadi kesalahan",
            isError: true);
      }
    } catch (e) {
      showCustomSnackbar("Error", "Gagal terhubung ke server", isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  void loginWithGoogle() async {
    try {
      isLoading.value = true;

      final result = await OauthService.signInWithGoogle();

      if (result != null) {
        // Simpan token (misal pakai GetStorage)
        // storage.write('token', result['access_token']);

        showCustomSnackbar(
            "Berhasil", "Selamat datang, ${result['user']['name']}!");
        Get.offAllNamed(Routes.HOME);
      }
    } catch (e) {
      showCustomSnackbar("Error", e.toString().replaceFirst('Exception: ', ''),
          isError: true);
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
