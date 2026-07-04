import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/regsiter_page_controller.dart';

class RegsiterPageView extends GetView<RegsiterPageController> {
  const RegsiterPageView({super.key});

  @override
  Widget build(BuildContext context) {
    // Palet warna disamakan persis dengan bahasa desain pilihanmu
    const Color cGold = Color(0xFFFBBF24); // accentGold
    const Color cDark = Color(0xFF1C1308); // darkBrown
    const Color cBg = Color(0xFFFAF7F2);   // bgCanvas
    const Color textMuted = Color(0xFF7A7062);
    const Color strengthGreen = Color(0xFF1E6F3B);
    const Color errorOrange = Color(0xFFC2612D);

    return Scaffold(
      backgroundColor: cBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              
              // Header: Buat Akun Baru (Layout Minimalis)
              Text(
                'Buat Akun Baru',
                style: GoogleFonts.lora(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: cDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Silakan lengkapi data di bawah ini untuk mendaftar.',
                style: GoogleFonts.poppins(color: textMuted, fontSize: 14),
              ),
              const SizedBox(height: 36),

              // --- Field Username ---
              Text('Username',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: cDark, fontSize: 14)),
              const SizedBox(height: 4),
              _buildTextField(
                  hint: 'Masukkan username Anda', 
                  controller: controller.usernameC,
                  icon: Icons.person_outline_rounded,
                  cDark: cDark,
                  textMuted: textMuted),
              const SizedBox(height: 24),

              // --- Field Email ---
              Text('Email',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: cDark, fontSize: 14)),
              const SizedBox(height: 4),
              _buildTextField(
                  hint: 'Masukkan email Anda', 
                  controller: controller.emailC,
                  icon: Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress,
                  cDark: cDark,
                  textMuted: textMuted),
              const SizedBox(height: 24),

              // --- Field Password ---
              Text('Password',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: cDark, fontSize: 14)),
              const SizedBox(height: 4),
              Obx(() => _buildTextField(
                    hint: 'Masukkan password',
                    controller: controller.passwordC,
                    isPassword: true,
                    obscureText: controller.isPasswordHidden.value,
                    onToggle: controller.togglePasswordVisibility,
                    icon: Icons.lock_open_outlined,
                    cDark: cDark,
                    textMuted: textMuted,
                  )),
              const SizedBox(height: 8),

              // ================= LOGIKA DINAMIS: INDIKATOR KEKUATAN PASSWORD =================
              AnimatedBuilder(
                animation: controller.passwordC,
                builder: (context, child) {
                  final text = controller.passwordC.text;
                  if (text.isEmpty) return const SizedBox.shrink();

                  int strength = 0;
                  if (text.length < 6) {
                    strength = 1;
                  } else if (text.length >= 6 && text.length < 10) {
                    strength = 2;
                  } else {
                    strength = 3;
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
                          Expanded(child: Container(height: 4, decoration: BoxDecoration(color: bar1, borderRadius: BorderRadius.circular(2)))),
                          const SizedBox(width: 4),
                          Expanded(child: Container(height: 4, decoration: BoxDecoration(color: bar2, borderRadius: BorderRadius.circular(2)))),
                          const SizedBox(width: 4),
                          Expanded(child: Container(height: 4, decoration: BoxDecoration(color: bar3, borderRadius: BorderRadius.circular(2)))),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        labelText,
                        style: GoogleFonts.poppins(color: labelColor, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              ),

              // --- Field Konfirmasi Password ---
              Text('Konfirmasi Password',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: cDark, fontSize: 14)),
              const SizedBox(height: 4),
              Obx(() => _buildTextField(
                    hint: 'Ulangi password baru',
                    controller: controller.confirmPasswordC,
                    isPassword: true,
                    obscureText: controller.isConfirmPasswordHidden.value,
                    onToggle: controller.toggleConfirmPasswordVisibility,
                    icon: Icons.lock_open_outlined,
                    cDark: cDark,
                    textMuted: textMuted,
                  )),
              const SizedBox(height: 12),

              // ================= LOGIKA DINAMIS: VALIDASI KECOCOKAN PASSWORD =================
              AnimatedBuilder(
                animation: Listenable.merge([controller.passwordC, controller.confirmPasswordC]),
                builder: (context, child) {
                  final pass = controller.passwordC.text;
                  final confirm = controller.confirmPasswordC.text;

                  if (pass.isEmpty || confirm.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  if (pass != confirm) {
                    return Row(
                      children: [
                        const Icon(Icons.error_outline_rounded, color: errorOrange, size: 16),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Password tidak cocok.',
                            style: GoogleFonts.poppins(color: errorOrange, fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    );
                  }

                  return Row(
                    children: [
                      const Icon(Icons.check_circle_outline_rounded, color: strengthGreen, size: 16),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Password cocok.',
                          style: GoogleFonts.poppins(color: strengthGreen, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 40),

              // Tombol Register Premium
              Obx(() => SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.register(),
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
                          child: CircularProgressIndicator(color: cGold, strokeWidth: 2.5),
                        )
                      : Text(
                          'Daftar',
                          style: GoogleFonts.poppins(
                            color: cGold,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              )),
              const SizedBox(height: 30),

              // Divider "atau"
              Row(
                children: [
                  Expanded(child: Divider(color: const Color(0xFFD1C7BD).withOpacity(0.5))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('atau',
                        style: GoogleFonts.poppins(color: textMuted, fontSize: 13)),
                  ),
                  Expanded(child: Divider(color: const Color(0xFFD1C7BD).withOpacity(0.5))),
                ],
              ),
              const SizedBox(height: 30),

              // Tombol Google Moderen
              Obx(() => SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton.icon(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.loginWithGoogle(),
                  icon: SvgPicture.asset(
                    'assets/images/Google.svg',
                    height: 20,
                    placeholderBuilder: (context) =>
                        const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                  label: Text(
                    'Lanjutkan dengan Google',
                    style: GoogleFonts.poppins(
                      color: cDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    side: const BorderSide(color: Color(0xFFE6DFD5), width: 1.5),
                  ),
                ),
              )),
              const SizedBox(height: 48),

              // Footer: Sudah punya akun? Login
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Sudah punya akun? ', style: GoogleFonts.poppins(color: textMuted, fontSize: 14)),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Text(
                        'Login',
                        style: GoogleFonts.poppins(
                          color: cDark,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget TextField Gaya Underline Elegan
  Widget _buildTextField({
    required String hint,
    TextEditingController? controller,
    required IconData icon,
    required Color cDark,
    required Color textMuted,
    bool isPassword = false,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    VoidCallback? onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      cursorColor: cDark,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(fontSize: 15, color: cDark, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: textMuted.withOpacity(0.4), fontSize: 14),
        filled: false,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(right: 8, bottom: 4),
          child: Icon(icon, color: textMuted, size: 20),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                    obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: textMuted.withOpacity(0.6),
                    size: 20),
                onPressed: onToggle,
              )
            : null,
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD1C7BD), width: 2),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFD1C7BD), width: 2),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: cDark, width: 3),
        ),
      ),
    );
  }
}