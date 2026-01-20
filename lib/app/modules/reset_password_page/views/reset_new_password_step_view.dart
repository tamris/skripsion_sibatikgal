import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/reset_password_page_controller.dart';

class ResetNewPasswordStepView extends GetView<ResetPasswordPageController> {
  const ResetNewPasswordStepView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text('Reset Kata Sandi',
              style: GoogleFonts.poppins(
                  fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),

          // Field Password Baru sesuai gambar
          Text('Password Baru',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Obx(() => _buildPasswordField(
                controller: controller.passwordC,
                hint: '********************',
                obscure: controller.isPasswordHidden.value,
                onToggle: () => controller.isPasswordHidden.toggle(),
              )),

          const SizedBox(height: 24),

          // Field Konfirmasi Password sesuai gambar
          Text('Konfirmasi Password',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Obx(() => _buildPasswordField(
                controller: controller.confirmPasswordC,
                hint: 'Ulangi kata sandi baru',
                obscure: controller.isConfirmPasswordHidden.value,
                onToggle: () => controller.isConfirmPasswordHidden.toggle(),
              )),

          const SizedBox(height: 8),
          Text(
            'Pastikan kata sandi baru dan konfirmasi kata sandi sesuai.',
            style: GoogleFonts.poppins(color: Colors.red, fontSize: 12),
          ),

          const SizedBox(height: 60),
          _buildButton(
              label: 'Simpan', onTap: () => controller.handleResetPassword()),
        ],
      ),
    );
  }

  Widget _buildPasswordField(
      {required TextEditingController controller,
      required String hint,
      required bool obscure,
      required VoidCallback onToggle}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        prefixIcon: const Icon(Icons.lock,
            color: Colors.black), // Prefix gembok dari gambar
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility,
              color: Colors.black),
          onPressed: onToggle,
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black12)),
      ),
    );
  }

  Widget _buildButton({required String label, required VoidCallback onTap}) {
    return Obx(() => SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: controller.isLoading.value ? null : onTap,
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8D5D46),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            child: controller.isLoading.value
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(label,
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
          ),
        ));
  }
}
