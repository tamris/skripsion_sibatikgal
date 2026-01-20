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

  // Ubah: secondsRemaining ke 60 (1 menit)
  var secondsRemaining = 60.obs; 
  // Ubah: enableResend jadi true agar bisa diklik langsung saat masuk halaman
  var enableResend = true.obs; 
  var isLoading = false.obs;
  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    // JANGAN panggil startTimer() di sini agar tombol langsung aktif
  }

  void startTimer() {
    secondsRemaining.value = 60;
    enableResend.value = false; // Tombol jadi mati saat timer jalan
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        enableResend.value = true; // Tombol aktif lagi setelah 1 menit
        t.cancel();
      }
    });
  }

  void resendOtp() async {
    isLoading.value = true;
    try {
      final response = await OtpService.resendOtp(email);
      if (response.statusCode == 200) {
        Get.snackbar("Sukses", "Kode OTP baru telah dikirim");
        // Panggil startTimer HANYA setelah user klik kirim ulang
        startTimer(); 
      } else {
        Get.snackbar("Gagal", response.data['msg'] ?? "Gagal kirim ulang");
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal terhubung ke server");
    } finally {
      isLoading.value = false;
    }
  }

  void verifyOtp() async {
    String code = otp1.text + otp2.text + otp3.text + otp4.text + otp5.text + otp6.text;
    if (code.length == 6) {
      isLoading.value = true;
      try {
        final response = await OtpService.verifyOtp(email, code);
        if (response.statusCode == 200) {
          Get.snackbar("Sukses", "Verifikasi berhasil. Silakan login.");
          Get.offAllNamed(Routes.LOGIN_PAGE);
        } else {
          Get.snackbar("Verifikasi Gagal", response.data['msg'] ?? "Kode tidak valid");
        }
      } catch (e) {
        Get.snackbar("Error", "Gagal terhubung ke server");
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar("Error", "Masukkan 6 digit kode lengkap");
    }
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }
}