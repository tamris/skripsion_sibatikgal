import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  var secondsRemaining = 30.obs;
  var enableResend = false.obs;
  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  void startTimer() {
    secondsRemaining.value = 30;
    enableResend.value = false;
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        enableResend.value = true;
        t.cancel();
      }
    });
  }

  void verifyOtp() {
    String code =
        otp1.text + otp2.text + otp3.text + otp4.text + otp5.text + otp6.text;
    if (code.length == 6) {
      Get.offAllNamed(
          '/login-page'); // Ganti dengan rute tujuan setelah verifikasi
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
