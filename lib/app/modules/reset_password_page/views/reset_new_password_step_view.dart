import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/reset_password_page_controller.dart';

class ResetNewPasswordStepView extends GetView<ResetPasswordPageController> {
  const ResetNewPasswordStepView({super.key});

  // Konstanta warna diselaraskan penuh dengan palet hangat kamu
  static const Color cGold = Color(0xFFFBBF24); // accentGold
  static const Color cDark = Color(0xFF1C1308); // darkBrown
  static const Color cBg = Color(0xFFFAF7F2); // bgCanvas
  static const Color textMuted = Color(0xFF7A7062);
  static const Color strengthGreen =
      Color(0xFF1E6F3B); // strengthGreen dari code awal
  static const Color errorOrange =
      Color(0xFFC2612D); // errorOrange dari code awal

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
            'Reset Kata Sandi',
            style: GoogleFonts.lora(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: cDark,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Silakan buat kata sandi baru yang kuat untuk mengamankan kembali akun Anda.',
            style: GoogleFonts.poppins(
              color: textMuted,
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 44),

          // --- FIELD 1: PASSWORD BARU ---
          Text(
            'Password Baru',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              color: cDark,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Obx(() => _buildPasswordField(
                textController: controller.passwordC,
                hint: 'Masukkan kata sandi baru',
                obscure: controller.isPasswordHidden.value,
                onToggle: () => controller.isPasswordHidden.toggle(),
              )),
          const SizedBox(height: 8),

          // ================= LOGIKA DINAMIS: INDIKATOR KEKUATAN PASSWORD =================
          // Menggunakan AnimatedBuilder agar reaktif mendeteksi ketikan di controller.passwordC
          AnimatedBuilder(
            animation: controller.passwordC,
            builder: (context, child) {
              final text = controller.passwordC.text;
              if (text.isEmpty) return const SizedBox.shrink();

              // Menghitung kekuatan password secara sederhana berdasarkan panjang karakter
              int strength = 0;
              if (text.length < 6) {
                strength = 1; // Lemah
              } else if (text.length >= 6 && text.length < 10) {
                strength = 2; // Cukup kuat
              } else {
                strength = 3; // Sangat kuat
              }

              Color bar1 = const Color(0xFFE6DFD5);
              Color bar2 = const Color(0xFFE6DFD5);
              Color bar3 = const Color(0xFFE6DFD5);
              String labelText = '';
              Color labelColor = textMuted;

              if (strength == 1) {
                bar1 = Colors.redAccent;
                labelText = 'Terlalu pendek / Lemah';
                labelColor = Colors.redAccent;
              } else if (strength == 2) {
                bar1 = strengthGreen;
                bar2 = strengthGreen;
                labelText = 'Cukup kuat';
                labelColor = strengthGreen;
              } else if (strength == 3) {
                bar1 = strengthGreen;
                bar2 = strengthGreen;
                bar3 = strengthGreen;
                labelText = 'Sangat kuat';
                labelColor = strengthGreen;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                              height: 4,
                              decoration: BoxDecoration(
                                  color: bar1,
                                  borderRadius: BorderRadius.circular(2)))),
                      const SizedBox(width: 4),
                      Expanded(
                          child: Container(
                              height: 4,
                              decoration: BoxDecoration(
                                  color: bar2,
                                  borderRadius: BorderRadius.circular(2)))),
                      const SizedBox(width: 4),
                      Expanded(
                          child: Container(
                              height: 4,
                              decoration: BoxDecoration(
                                  color: bar3,
                                  borderRadius: BorderRadius.circular(2)))),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    labelText,
                    style: GoogleFonts.poppins(
                        color: labelColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),

          // --- FIELD 2: KONFIRMASI PASSWORD ---
          Text(
            'Konfirmasi Password',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              color: cDark,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Obx(() => _buildPasswordField(
                textController: controller.confirmPasswordC,
                hint: 'Ulangi kata sandi baru',
                obscure: controller.isConfirmPasswordHidden.value,
                onToggle: () => controller.isConfirmPasswordHidden.toggle(),
              )),
          const SizedBox(height: 12),

          // ================= LOGIKA DINAMIS: VALIDASI COCOK / TIDAK COCOK =================
          AnimatedBuilder(
            animation: Listenable.merge(
                [controller.passwordC, controller.confirmPasswordC]),
            builder: (context, child) {
              final pass = controller.passwordC.text;
              final confirm = controller.confirmPasswordC.text;

              // Jika salah satu kosong, tampilkan info standar
              if (pass.isEmpty || confirm.isEmpty) {
                return Row(
                  children: [
                    const Icon(Icons.info_outline_rounded,
                        color: textMuted, size: 15),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Pastikan kata sandi baru dan konfirmasi kata sandi sesuai.',
                        style: GoogleFonts.poppins(
                            color: textMuted,
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                );
              }

              // Jika tidak cocok, ganti warna ke errorOrange dinamis
              if (pass != confirm) {
                return Row(
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        color: errorOrange, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Kata sandi baru dan konfirmasi tidak cocok.',
                        style: GoogleFonts.poppins(
                            color: errorOrange,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                );
              }

              // Jika cocok, tampilkan status aman
              return Row(
                children: [
                  const Icon(Icons.check_circle_outline_rounded,
                      color: strengthGreen, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Kata sandi cocok.',
                      style: GoogleFonts.poppins(
                          color: strengthGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 48),

          // --- TOMBOL SIMPAN ---
          _buildButton(
              label: 'Simpan Kata Sandi',
              onTap: () => controller.handleResetPassword()),
        ],
      ),
    );
  }

  // Helper Password Field Gaya Underline
  Widget _buildPasswordField({
    required TextEditingController textController,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: textController,
      obscureText: obscure,
      cursorColor: cDark,
      style: GoogleFonts.poppins(
        fontSize: 15,
        color: cDark,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
          color: textMuted.withOpacity(0.4),
          fontSize: 14,
        ),
        filled: false,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        prefixIcon: const Padding(
          padding: EdgeInsets.only(right: 8, bottom: 4),
          child: Icon(
            Icons.lock_open_outlined,
            color: textMuted,
            size: 20,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: textMuted.withOpacity(0.6),
            size: 20,
          ),
          onPressed: onToggle,
        ),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD1C7BD), width: 2),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD1C7BD), width: 2),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: cDark, width: 3),
        ),
      ),
    );
  }

  Widget _buildButton({required String label, required VoidCallback onTap}) {
    return Obx(() => SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: controller.isLoading.value ? null : onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: cDark,
              foregroundColor: Colors.white,
              disabledBackgroundColor: const Color(0xFFD1C7BD),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
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
                        Icons.save_outlined,
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
