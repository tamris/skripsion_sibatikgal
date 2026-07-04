import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/otp_verifikasi_controller.dart';

class OtpVerifikasiView extends GetView<OtpVerifikasiController> {
  const OtpVerifikasiView({super.key});

  @override
  Widget build(BuildContext context) {
    // Palet warna disamakan persis dengan tema utama kamu
    const Color cGold = Color(0xFFFBBF24); // accentGold
    const Color cDark = Color(0xFF1C1308); // darkBrown
    const Color cBg = Color(0xFFFAF7F2); // bgCanvas
    const Color textMuted = Color(0xFF7A7062);

    return Scaffold(
      backgroundColor: cBg,
      body: SafeArea(
        child: Column(
          children: [
            // ================= CUSTOM APP BAR =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: cDark,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Verifikasi Akun',
                    style: GoogleFonts.lora(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: cDark,
                    ),
                  ),
                ],
              ),
            ),

            // ================= SCROLLABLE CONTENT =================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    // --- KETERANGAN UTAMA ---
                    Text(
                      'Masukkan 6-digit kode',
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
                                  'Kami telah mengirimkan kode verifikasi ke email '),
                          TextSpan(
                            text: controller.email,
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
                        _otpBox(context, controller.otp1, controller.fn1,
                            controller.fn2, null, cDark),
                        _otpBox(context, controller.otp2, controller.fn2,
                            controller.fn3, controller.fn1, cDark),
                        _otpBox(context, controller.otp3, controller.fn3,
                            controller.fn4, controller.fn2, cDark),
                        _otpBox(context, controller.otp4, controller.fn4,
                            controller.fn5, controller.fn3, cDark),
                        _otpBox(context, controller.otp5, controller.fn5,
                            controller.fn6, controller.fn4, cDark),
                        _otpBox(context, controller.otp6, controller.fn6, null,
                            controller.fn5, cDark),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // --- TIMER & KIRIM ULANG (REAKTIF) ---
                    Obx(() => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tidak menerima kode?",
                              style: GoogleFonts.poppins(
                                  color: textMuted, fontSize: 13),
                            ),
                            const SizedBox(height: 4),
                            controller.enableResend.value
                                ? GestureDetector(
                                    onTap: () => controller.resendOtp(),
                                    child: Text(
                                      'Kirim ulang kode',
                                      style: GoogleFonts.poppins(
                                        color: cDark,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  )
                                : Text(
                                    "Kirim ulang dalam ${controller.secondsRemaining.value} detik",
                                    style: GoogleFonts.poppins(
                                      color: textMuted,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                          ],
                        )),
                    const SizedBox(height: 48),

                    // --- TOMBOL VERIFIKASI ---
                    SizedBox(
                      width: double.infinity,
                      height: 54, // Sesuai standardisasi tinggi 54 halaman lain
                      child: ElevatedButton(
                        onPressed: () => controller.verifyOtp(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cDark,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(16), // Radius 16
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.check_circle_outline_rounded,
                              size: 18,
                              color: cGold,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Verifikasi',
                              style: GoogleFonts.poppins(
                                color: cGold,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper OTP Box: Berubah dari Kotak Utuh menjadi Garis Bawah (Underline Style)
  Widget _otpBox(BuildContext context, TextEditingController ctrl,
      FocusNode current, FocusNode? next, FocusNode? previous, Color cDark) {
    return SizedBox(
      width: 44, // Diatur pas agar fleksibel di layar smartphone kecil
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
          filled: false,
          contentPadding: const EdgeInsets.only(bottom: 8),
          // Garis bawah pasif halus
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFD1C7BD), width: 2),
          ),
          // Garis bawah tegas cokelat gelap ketika fokus mengetik
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: cDark, width: 3),
          ),
        ),
        onChanged: (value) {
          if (value.length == 1 && next != null) {
            next.requestFocus();
          }
          if (value.isEmpty && previous != null) {
            previous.requestFocus();
          }
        },
      ),
    );
  }
}
