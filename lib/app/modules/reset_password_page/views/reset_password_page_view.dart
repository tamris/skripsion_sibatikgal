import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/reset_password_page_controller.dart';
import 'reset_email_step_view.dart';
import 'reset_otp_step_view.dart';
import 'reset_new_password_step_view.dart';

class ResetPasswordPageView extends GetView<ResetPasswordPageController> {
  const ResetPasswordPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Logika kembali bertahap
            if (controller.currentStep.value > 0) {
              controller.currentStep.value--;
            } else {
              Get.back();
            }
          },
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          // Menampilkan view yang berbeda berdasarkan step saat ini
          switch (controller.currentStep.value) {
            case 0:
              return const ResetEmailStepView();
            case 1:
              return const ResetOtpStepView();
            case 2:
              return const ResetNewPasswordStepView();
            default:
              return const ResetEmailStepView();
          }
        }),
      ),
    );
  }
}