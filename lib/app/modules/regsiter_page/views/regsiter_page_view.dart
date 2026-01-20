import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/regsiter_page_controller.dart';

class RegsiterPageView extends GetView<RegsiterPageController> {
  const RegsiterPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              // Header: Buat Akun Baru (Centered)
              Center(
                child: Text(
                  'Buat Akun Baru',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // --- Field Username ---
              Text('Username',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              _buildTextField(
                  hint: 'Username', controller: controller.usernameC),
              const SizedBox(height: 20),

              // --- Field Email ---
              Text('Email',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              _buildTextField(hint: 'Email', controller: controller.emailC),
              const SizedBox(height: 20),

              // --- Field Password ---
              Text('Password',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Obx(() => _buildTextField(
                    hint: 'Password',
                    controller: controller.passwordC,
                    isPassword: true,
                    obscureText: controller.isPasswordHidden.value,
                    onToggle: controller.togglePasswordVisibility,
                  )),
              const SizedBox(height: 20),

              // --- Field Konfirmasi Password ---
              Text('Konfirmasi Passowrd',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Obx(() => _buildTextField(
                    hint: 'Konfirmasi Password',
                    controller: controller.confirmPasswordC,
                    isPassword: true,
                    obscureText: controller.isConfirmPasswordHidden.value,
                    onToggle: controller.toggleConfirmPasswordVisibility,
                  )),

              const SizedBox(height: 40),

              // Tombol Login (Sesuai teks di gambar desainmu)
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.register(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8D5D46),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Daftar', // Sesuai desain kamu, atau ganti jadi 'Daftar'
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Divider "atau"
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade400)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text('atau',
                        style: GoogleFonts.poppins(color: Colors.grey)),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade400)),
                ],
              ),
              const SizedBox(height: 30),

              // Tombol Google
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Tambahkan logika di sini
                    print('Tombol Google ditekan!');
                  },
                  icon: SvgPicture.asset(
                    'assets/images/Google.svg', // Logo Google dari file assets lokal
                    height: 24,
                    semanticsLabel:
                        'Google Logo', // Untuk keperluan aksesibilitas
                    placeholderBuilder: (context) =>
                        const CircularProgressIndicator(), // Placeholder loading
                  ),
                  label: Text(
                    'Lanjutkan dengan Google',
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: const BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 60),

              // Footer: Sudah punya akun? Login
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Sudah punya akun? ', style: GoogleFonts.poppins()),
                    GestureDetector(
                      onTap: () => Get.back(), // Kembali ke halaman login
                      child: Text(
                        'Login',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF8D5D46),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget agar kode lebih bersih
  Widget _buildTextField(
      {required String hint,
      TextEditingController? controller,
      bool isPassword = false,
      bool obscureText = false,
      VoidCallback? onToggle}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                    obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey),
                onPressed: onToggle,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
      ),
    );
  }
}
