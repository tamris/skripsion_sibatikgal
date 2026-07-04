import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/login_page_controller.dart';

class LoginPageView extends GetView<LoginPageController> {
  const LoginPageView({super.key});

  @override
  Widget build(BuildContext context) {
    // Palet warna disamakan persis dengan bahasa desain utama kamu
    const Color cGold = Color(0xFFFBBF24); // accentGold
    const Color cDark = Color(0xFF1C1308); // darkBrown
    const Color cBg = Color(0xFFFAF7F2); // bgCanvas
    const Color textMuted = Color(0xFF7A7062);

    return Scaffold(
      backgroundColor: cBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),

              // --- HEADER SECTION (Clean Minimalist Typography) ---
              Text(
                'Halo,',
                style: GoogleFonts.lora(
                  fontSize: 36,
                  fontWeight: FontWeight.w400,
                  color: textMuted,
                ),
              ),
              Text(
                'Login Sekarang',
                style: GoogleFonts.lora(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: cDark,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 44),

              // --- FIELD INPUT: EMAIL ---
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
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: cDark,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Masukkan email Anda',
                  hintStyle: GoogleFonts.poppins(
                    color: textMuted.withValues(alpha: 0.4),
                    fontSize: 14,
                  ),
                  filled: false, // Menyatu dengan kanvas latar belakang
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
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
              ),
              const SizedBox(height: 24),

              // --- FIELD INPUT: PASSWORD ---
              Text(
                'Password',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  color: cDark,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Obx(() => TextField(
                    controller: controller.passwordC,
                    obscureText: controller.isPasswordHidden.value,
                    cursorColor: cDark,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: cDark,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Masukkan password Anda',
                      hintStyle: GoogleFonts.poppins(
                        color: textMuted.withValues(alpha: 0.4),
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
                      prefixIconConstraints:
                          const BoxConstraints(minWidth: 0, minHeight: 0),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordHidden.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: textMuted.withValues(alpha: 0.6),
                          size: 20,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                      border: const UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFD1C7BD), width: 2),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFD1C7BD), width: 2),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: cDark, width: 3),
                      ),
                    ),
                  )),

              // --- LUPA KATA SANDI BUTTON ---
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Get.toNamed('/reset-password-page');
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: Text(
                    'Lupa kata sandi?',
                    style: GoogleFonts.poppins(
                      color: cDark,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // --- TOMBOL LOGIN UTAMA ---
              Obx(() => SizedBox(
                    width: double.infinity,
                    height: 54, // Tinggi standar kokoh sesuai kodenya
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () => controller.login(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cDark,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: const Color(0xFFD1C7BD),
                        elevation: 0, // Datar/flat sesuai alur minimalis
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
                          : Text(
                              'Login',
                              style: GoogleFonts.poppins(
                                color: cGold,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  )),
              const SizedBox(height: 30),

              // --- DIVIDER "atau" ---
              Row(
                children: [
                  Expanded(
                      child: Divider(
                          color:
                              const Color(0xFFD1C7BD).withValues(alpha: 0.5))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'atau',
                      style:
                          GoogleFonts.poppins(color: textMuted, fontSize: 13),
                    ),
                  ),
                  Expanded(
                      child: Divider(
                          color:
                              const Color(0xFFD1C7BD).withValues(alpha: 0.5))),
                ],
              ),
              const SizedBox(height: 30),

              // --- TOMBOL GOOGLE MODEREN ---
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
                        placeholderBuilder: (context) => const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
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
                        side: const BorderSide(
                            color: Color(0xFFE6DFD5), width: 1.5),
                      ),
                    ),
                  )),
              const SizedBox(height: 60),

              // --- FOOTER: BELUM PUNYA AKUN? ---
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum punya akun? ',
                      style:
                          GoogleFonts.poppins(color: textMuted, fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed('/regsiter-page'),
                      child: Text(
                        'Daftar',
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
}
