import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:batikara/app/routes/app_pages.dart';
import '../../../data/service/otp_service.dart';

class OtpVerifikasiController extends GetxController {
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

  final String email = Get.arguments ?? "user@email.com";

  var secondsRemaining = 60.obs;
  var enableResend = true.obs;
  var isLoading = false.obs;
  Timer? timer;

  @override
  void onInit() {
    super.onInit();
  }

  void startTimer() {
    secondsRemaining.value = 60;
    enableResend.value = false; // Disable resend button when timer is active
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        enableResend.value = true; // Enable button after 1 minute
        t.cancel();
      }
    });
  }

  void showCustomSnackbar(String title, String message,
      {bool isError = false, bool isSuccess = false}) {
    // Tentukan warna berdasarkan tipe notifikasi
    Color backgroundColor;
    Color textColor;
    Color iconColor;
    IconData iconData;

    if (isError) {
      backgroundColor = Color(0xFFFFEBEE);
      textColor = Color(0xFFC62828);
      iconColor = Color(0xFFC62828);
      iconData = Icons.error_outline_rounded;
    } else if (isSuccess) {
      backgroundColor = Color(0xFFE8F5E9);
      textColor = Color(0xFF2E7D32);
      iconColor = Color(0xFF2E7D32);
      iconData = Icons.check_circle_outline_rounded;
    } else {
      backgroundColor = Color(0xFFFFF3E0);
      textColor = Color(0xFF8D5D46);
      iconColor = Color(0xFF8D5D46);
      iconData = Icons.info_outline_rounded;
    }

    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: backgroundColor,
      colorText: textColor,
      borderRadius: 16,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      icon: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          iconData,
          color: iconColor,
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
          color: textColor,
        ),
      ),
      messageText: Text(
        message,
        style: TextStyle(
          fontSize: 14,
          color: textColor.withValues(alpha: 0.8),
          height: 1.4,
        ),
      ),
    );
  }

  void resendOtp() async {
    if (!enableResend.value) return;

    isLoading.value = true;
    try {
      final response = await OtpService.resendOtp(email);
      if (response.statusCode == 200) {
        showCustomSnackbar("Sukses", "Kode OTP baru telah dikirim",
            isSuccess: true);
        startTimer();
      } else {
        showCustomSnackbar(
            "Gagal", response.data['msg'] ?? "Gagal mengirim ulang OTP",
            isError: true);
      }
    } catch (e) {
      showCustomSnackbar("Error", "Gagal terhubung ke server", isError: true);
    } finally {
      isLoading.value = false;
    }
  }

  void verifyOtp() async {
    String code =
        otp1.text + otp2.text + otp3.text + otp4.text + otp5.text + otp6.text;
    if (code.length == 6) {
      isLoading.value = true;
      try {
        final response = await OtpService.verifyOtp(email, code);
        if (response.statusCode == 200) {
          showCustomSnackbar("Sukses", "Verifikasi berhasil. Silakan login.",
              isSuccess: true);
          Get.until((route) => Get.currentRoute == Routes.LOGIN_PAGE);
        } else {
          showCustomSnackbar("Verifikasi Gagal",
              response.data['msg'] ?? "Kode OTP tidak valid",
              isError: true);
        }
      } catch (e) {
        showCustomSnackbar("Error", "Gagal terhubung ke server", isError: true);
      } finally {
        isLoading.value = false;
      }
    } else {
      showCustomSnackbar("Error", "Masukkan 6 digit kode lengkap",
          isError: true);
    }
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}
