import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/reset_password_page_controller.dart';

class ResetOtpStepView extends GetView<ResetPasswordPageController> {
  const ResetOtpStepView({super.key});

  // Palet warna WAJIB sama persis dengan kode awal kamu
  static const Color cGold = Color(0xFFFBBF24); // accentGold
  static const Color cDark = Color(0xFF1C1308); // darkBrown
  static const Color cBg = Color(0xFFFAF7F2); // bgCanvas
  static const Color textMuted = Color(0xFF7A7062);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),

          // --- KETERANGAN UTAMA ---
          Text(
            'Verifikasi Kode',
            style: GoogleFonts.lora(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: cDark,
            ),
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(
                  color: textMuted, fontSize: 14, height: 1.6),
              children: [
                const TextSpan(
                    text:
                        'Kami telah mengirimkan 6-digit kode keamanan ke alamat email '),
                TextSpan(
                  text: controller.emailC.text,
                  style: GoogleFonts.poppins(
                    color: cDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),

          // --- INPUT OTP: MODEREN UNDERLINE STYLE ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _otpBox(controller.otp1, controller.fn1, controller.fn2, null),
              _otpBox(controller.otp2, controller.fn2, controller.fn3,
                  controller.fn1),
              _otpBox(controller.otp3, controller.fn3, controller.fn4,
                  controller.fn2),
              _otpBox(controller.otp4, controller.fn4, controller.fn5,
                  controller.fn3),
              _otpBox(controller.otp5, controller.fn5, controller.fn6,
                  controller.fn4),
              _otpBox(controller.otp6, controller.fn6, null, controller.fn5),
            ],
          ),
          const SizedBox(height: 54),

          // --- TOMBOL VERIFIKASI ---
          _buildButton(
              label: 'Verifikasi OTP', onTap: () => controller.verifyOtp()),
        ],
      ),
    );
  }

  // Helper OTP Box: Berubah dari Kotak Utuh menjadi Garis Bawah (Underline)
  Widget _otpBox(TextEditingController ctrl, FocusNode current, FocusNode? next,
      FocusNode? previous) {
    return SizedBox(
      width: 44,
      height: 54,
      child: TextField(
        controller: ctrl,
        focusNode: current,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        cursorColor: cDark,
        style: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: cDark,
        ),
        decoration: InputDecoration(
          counterText: "",
          // Tanpa warna background kotak agar terlihat menyatu dengan kanvas
          filled: false,
          contentPadding: const EdgeInsets.only(bottom: 8),
          // Garis bawah pasif (tipis dan pudar)
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFD1C7BD), width: 2),
          ),
          // Garis bawah aktif (berubah menjadi cokelat gelap tegas saat diisi)
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: cDark, width: 3),
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
          height: 54, // Tinggi standar sesuai halaman Ubah Sandi kamu
          child: ElevatedButton(
            onPressed: controller.isLoading.value ? null : onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: cDark,
              foregroundColor: Colors.white,
              disabledBackgroundColor:
                  const Color(0xFFD1C7BD), // Warna pasif saat loading
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    16), // Radius 16 sesuai style guide kamu
              ),
            ),
            child: controller.isLoading.value
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: cGold,
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        size: 18,
                        color: cGold,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        label,
                        style: GoogleFonts.poppins(
                          color: cGold,
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
          ),
        ));
  }
}
