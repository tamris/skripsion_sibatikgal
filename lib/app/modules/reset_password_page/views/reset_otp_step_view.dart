import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/reset_password_page_controller.dart';

class ResetOtpStepView extends GetView<ResetPasswordPageController> {
  const ResetOtpStepView({super.key});
  static const Color cGold = Color(0xFFFFD264);
  static const Color cDark = Color(0xFF1A1208);
  static const Color cBg = Color(0xFFF9F8F4);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'Masukkan 6-digit kode',
            style:
                GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
              children: [
                const TextSpan(text: 'Kode verifikasi telah dikirim ke '),
                TextSpan(
                  text: controller.emailC.text,
                  style: GoogleFonts.poppins(
                      color: const Color(0xFF4285F4),
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Row 6 Kotak OTP - Menggunakan desain yang sama dengan pendaftaran
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _otpBox(controller.otp1, controller.fn1, controller.fn2, null),
              const SizedBox(width: 8),
              _otpBox(controller.otp2, controller.fn2, controller.fn3,
                  controller.fn1),
              const SizedBox(width: 8),
              _otpBox(controller.otp3, controller.fn3, controller.fn4,
                  controller.fn2),
              const SizedBox(width: 8),
              _otpBox(controller.otp4, controller.fn4, controller.fn5,
                  controller.fn3),
              const SizedBox(width: 8),
              _otpBox(controller.otp5, controller.fn5, controller.fn6,
                  controller.fn4),
              const SizedBox(width: 8),
              _otpBox(controller.otp6, controller.fn6, null, controller.fn5),
            ],
          ),
          const SizedBox(height: 40),
          _buildButton(
              label: 'Verifikasi OTP', onTap: () => controller.verifyOtp()),
        ],
      ),
    );
  }

  // Widget Helper OTP Box yang sudah diperbesar
  Widget _otpBox(TextEditingController ctrl, FocusNode current, FocusNode? next,
      FocusNode? previous) {
    return SizedBox(
      width: 50,
      height: 65,
      child: TextField(
        controller: ctrl,
        focusNode: current,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: "",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF8D5D46), width: 2),
          ),
        ),
        onChanged: (val) {
          if (val.length == 1 && next != null) next.requestFocus();
          if (val.isEmpty && previous != null) previous.requestFocus();
        },
      ),
    );
  }

  Widget _buildButton({required String label, required VoidCallback onTap}) {
    return Obx(() => SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: controller.isLoading.value ? null : onTap,
            style: ElevatedButton.styleFrom(
                backgroundColor: cDark,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            child: controller.isLoading.value
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    label,
                    style: GoogleFonts.poppins(
                      color: cGold,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
          ),
        ));
  }
}
