import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/otp_verifikasi_controller.dart';

class OtpVerifikasiView extends GetView<OtpVerifikasiController> {
  const OtpVerifikasiView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color cGold = Color(0xFFFFD264);
    const Color cDark = Color(0xFF1A1208);
    const Color cBg = Color(0xFFF9F8F4);

    return Scaffold(
      backgroundColor: cBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Masukkan 6-digit kode',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8), // Jarak dipersempit dari 12 ke 8
              RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
                  children: [
                    const TextSpan(
                        text:
                            'Kami telah mengirimkan kode verifikasi ke email '),
                    TextSpan(
                      text: controller
                          .email, // Ambil email dinamis dari controller
                      style: const TextStyle(
                        color: Color(0xFF4285F4),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                  height: 30), // Jarak ke box dipersempit dari 50 ke 30

              // Baris 6 Kotak OTP - Box diperbesar dan sejajar kiri
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _otpBox(context, controller.otp1, controller.fn1,
                      controller.fn2, null),
                  const SizedBox(width: 8),
                  _otpBox(context, controller.otp2, controller.fn2,
                      controller.fn3, controller.fn1),
                  const SizedBox(width: 8),
                  _otpBox(context, controller.otp3, controller.fn3,
                      controller.fn4, controller.fn2),
                  const SizedBox(width: 8),
                  _otpBox(context, controller.otp4, controller.fn4,
                      controller.fn5, controller.fn3),
                  const SizedBox(width: 8),
                  _otpBox(context, controller.otp5, controller.fn5,
                      controller.fn6, controller.fn4),
                  const SizedBox(width: 8),
                  _otpBox(context, controller.otp6, controller.fn6, null,
                      controller.fn5),
                ],
              ),

              const SizedBox(height: 15),

              // Timer & Kirim Ulang
              Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tidak menerima kode?",
                        style: GoogleFonts.poppins(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      controller.enableResend.value
                          ? GestureDetector(
                              onTap: () => controller.resendOtp(),
                              child: Text(
                                'Kirim ulang kode',
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF8D5D46),
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            )
                          : Text(
                              "Kirim ulang dalam ${controller.secondsRemaining.value} detik",
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF8D5D46),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ],
                  )),

              const SizedBox(height: 60),

              // Tombol Verifikasi
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () => controller.verifyOtp(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cDark,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                  ),
                  child: Text(
                    'Verifikasi',
                    style: GoogleFonts.poppins(
                      color: cGold,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _otpBox(BuildContext context, TextEditingController ctrl,
      FocusNode current, FocusNode? next, FocusNode? previous) {
    return SizedBox(
      width: 50, // Sebelumnya 45
      height: 65, // Sebelumnya 60
      child: TextField(
        controller: ctrl,
        focusNode: current,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: GoogleFonts.poppins(
            fontSize: 24, // Ukuran font diperbesar sedikit agar pas dengan box
            fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: "",
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF8D5D46), width: 2),
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
