import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/reset_password_page_controller.dart';

class ResetEmailStepView extends GetView<ResetPasswordPageController> {
  const ResetEmailStepView({super.key});

  // Konstanta warna diselaraskan penuh dengan palet hangat kamu
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

          // --- KETERANGAN UTAMA (Layout Terpusat Kiri, Serasi dengan OTP Pilihanmu) ---
          Text(
            'Lupa Kata Sandi?',
            style: GoogleFonts.lora(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: cDark,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Masukkan alamat email Anda untuk menerima kode verifikasi pengaturan ulang kata sandi.',
            style: GoogleFonts.poppins(
              color: textMuted,
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 48),

          // --- FIELD INPUT: MODEREN UNDERLINE EMAIL ---
          Text(
            'Email',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              color: cDark,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller.emailC,
            cursorColor: cDark,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Masukkan email Anda',
              hintStyle: GoogleFonts.poppins(
                color: textMuted.withOpacity(0.4),
                fontSize: 14,
              ),
              // Menggunakan false agar bersih tanpa kotak putih belakang, menyatu dengan kanvas
              filled: false,
              prefixIcon: const Padding(
                padding: EdgeInsets.only(right: 8, bottom: 4),
                child: Icon(
                  Icons.mail_outline_rounded,
                  color: textMuted,
                  size: 20,
                ),
              ),
              prefixIconConstraints:
                  const BoxConstraints(minWidth: 0, minHeight: 0),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              // Garis bawah pasif (tipis dan pudar) senada dengan kotak OTP pasif
              border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFD1C7BD), width: 2),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFD1C7BD), width: 2),
              ),
              // Garis bawah aktif (tegas cokelat gelap saat mulai mengetik)
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: cDark, width: 3),
              ),
            ),
            style: GoogleFonts.poppins(
              fontSize: 15,
              color: cDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 54),

          // --- TOMBOL KIRIM KODE ---
          _buildButton(label: 'Kirim Kode', onTap: () => controller.sendOtp()),
        ],
      ),
    );
  }

  Widget _buildButton({required String label, required VoidCallback onTap}) {
    return Obx(() => SizedBox(
          width: double.infinity,
          height: 54, // Tinggi standar kokoh sesuai halaman sebelumnya
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
                    16), // Lengkungan radius 16 sesuai style guide
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
                        Icons.send_rounded,
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
