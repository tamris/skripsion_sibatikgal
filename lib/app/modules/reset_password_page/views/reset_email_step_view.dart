import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/reset_password_page_controller.dart';

class ResetEmailStepView extends GetView<ResetPasswordPageController> {
  const ResetEmailStepView({super.key});
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
            'Lupa Kata Sandi?',
            style:
                GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Masukkan alamat email Anda untuk menerima kode verifikasi pengaturan ulang kata sandi.',
            style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 40),
          Text('Email',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          TextField(
            controller: controller.emailC,
            decoration: InputDecoration(
              hintText: 'Masukkan email Anda',
              hintStyle: GoogleFonts.poppins(color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black12),
              ),
            ),
            style: GoogleFonts.poppins(),
          ),
          const SizedBox(height: 40),
          _buildButton(label: 'Kirim Kode', onTap: () => controller.sendOtp()),
        ],
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
                  borderRadius: BorderRadius.circular(12)),
            ),
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
