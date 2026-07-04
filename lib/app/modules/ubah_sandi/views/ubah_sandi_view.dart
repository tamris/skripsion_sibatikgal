import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/ubah_sandi_controller.dart';

class UbahSandiView extends GetView<UbahSandiController> {
  const UbahSandiView({super.key});

  @override
  Widget build(BuildContext context) {
    const bgCanvas = Color(0xFFFAF7F2);
    const darkBrown = Color(0xFF1C1308);
    const textMuted = Color(0xFF7A7062);
    const accentGold = Color(0xFFFBBF24);
    const strengthGreen = Color(0xFF1E6F3B);
    const errorOrange = Color(0xFFC2612D);
    const btnGrey = Color(0xFF1C1308);

    return Scaffold(
      backgroundColor: bgCanvas,
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
                      child: const Icon(Icons.arrow_back_rounded,
                          color: darkBrown, size: 20),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Ubah Kata Sandi',
                    style: GoogleFonts.lora(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: darkBrown,
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

                    Center(
                      child: Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          color: darkBrown,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Icon(Icons.shield_outlined,
                            color: accentGold, size: 40),
                      ),
                    ),
                    const SizedBox(height: 24),

                    Text(
                      'Demi keamanan akunmu, masukkan kata sandi lama sebelum membuat yang baru.',
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: textMuted, height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),

                    // --- FIELD 1: KATA SANDI LAMA ---
                    Text(
                      'Kata Sandi Lama',
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: darkBrown),
                    ),
                    const SizedBox(height: 8),
                    Obx(() => _buildPasswordField(
                          textController: controller.oldPasswordController,
                          hint: '••••••••••••',
                          obscureText: controller.isOldPasswordHidden.value,
                          onToggle: controller.toggleOldPasswordVisibility,
                          darkBrown: darkBrown,
                          textMuted: textMuted,
                        )),
                    const SizedBox(height: 24),

                    // --- FIELD 2: KATA SANDI BARU ---
                    Text(
                      'Kata Sandi Baru',
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: darkBrown),
                    ),
                    const SizedBox(height: 8),
                    Obx(() => _buildPasswordField(
                          textController: controller.newPasswordController,
                          hint: 'Masukkan kata sandi baru',
                          obscureText: controller.isNewPasswordHidden.value,
                          onToggle: controller.toggleNewPasswordVisibility,
                          darkBrown: darkBrown,
                          textMuted: textMuted,
                        )),
                    const SizedBox(height: 8),

                    // LOGIKA DINAMIS: Bar Indikator Kekuatan Password (Hanya muncul jika diisi)
                    Obx(() {
                      final strength = controller.passwordStrength.value;
                      if (strength == 0) return const SizedBox.shrink();

                      // Setup warna bar dan teks keterangan secara reaktif
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
                                          borderRadius:
                                              BorderRadius.circular(2)))),
                              const SizedBox(width: 4),
                              Expanded(
                                  child: Container(
                                      height: 4,
                                      decoration: BoxDecoration(
                                          color: bar2,
                                          borderRadius:
                                              BorderRadius.circular(2)))),
                              const SizedBox(width: 4),
                              Expanded(
                                  child: Container(
                                      height: 4,
                                      decoration: BoxDecoration(
                                          color: bar3,
                                          borderRadius:
                                              BorderRadius.circular(2)))),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            labelText,
                            style: GoogleFonts.poppins(
                                color: labelColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      );
                    }),
                    Obx(() => SizedBox(
                        height:
                            controller.passwordStrength.value > 0 ? 24 : 0)),

                    // --- FIELD 3: KONFIRMASI KATA SANDI BARU ---
                    Text(
                      'Konfirmasi Kata Sandi Baru',
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: darkBrown),
                    ),
                    const SizedBox(height: 8),
                    Obx(() => _buildPasswordField(
                          textController: controller.confirmPasswordController,
                          hint: '••••••••••••',
                          obscureText: controller.isConfirmPasswordHidden.value,
                          onToggle: controller.toggleConfirmPasswordVisibility,
                          darkBrown: darkBrown,
                          textMuted: textMuted,
                          hasErrorBorder: !controller.isPasswordMatch.value,
                          errorColor: errorOrange,
                        )),
                    const SizedBox(height: 6),

                    // LOGIKA DINAMIS: Error Message jika password tidak cocok
                    Obx(() {
                      if (controller.isPasswordMatch.value)
                        return const SizedBox.shrink();
                      return Row(
                        children: [
                          const Icon(Icons.error_outline_rounded,
                              color: errorOrange, size: 16),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Kata sandi baru dan konfirmasi tidak cocok',
                              style: GoogleFonts.poppins(
                                  color: errorOrange,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 24),

                    // --- SYARAT KATA SANDI BOX ---
                  ],
                ),
              ),
            ),

            // ================= BOTTOM BUTTON SIMPAN (CTA BERBACKGROUND SOLID & REAKTIF) =================
            Obx(() {
              // Validasi: Form dianggap valid jika password COCOK, password baru TIDAK LEMAH, dan konfirmasi TIDAK KOSONG
              bool isFormValid = controller.isPasswordMatch.value &&
                  controller.passwordStrength.value >= 2 &&
                  controller.isConfirmPasswordNotEmpty.value;

              return Container(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                color:
                    bgCanvas, // Mencegah teks scrolling di belakang terlihat melompong
                child: ElevatedButton(
                  onPressed:
                      isFormValid ? () => controller.simpanSandi() : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isFormValid ? btnGrey : const Color(0xFFD1C7BD),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 54),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.save_outlined,
                        size: 18,
                        color: isFormValid ? accentGold : Colors.white60,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Simpan Kata Sandi',
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isFormValid ? accentGold : Colors.white60),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController textController,
    required String hint,
    required bool obscureText,
    required VoidCallback onToggle,
    required Color darkBrown,
    required Color textMuted,
    bool hasErrorBorder = false,
    Color errorColor = Colors.orange,
  }) {
    return TextField(
      controller: textController,
      obscureText: obscureText,
      cursorColor: darkBrown,
      style: GoogleFonts.poppins(
          fontSize: 15, color: darkBrown, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
            color: textMuted.withOpacity(0.4), fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(Icons.lock_open_outlined, color: textMuted, size: 20),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: textMuted.withOpacity(0.6),
            size: 20,
          ),
          onPressed: onToggle,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
              color: hasErrorBorder ? errorColor : const Color(0xFFE6DFD5),
              width: hasErrorBorder ? 1.5 : 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
              color: hasErrorBorder ? errorColor : const Color(0xFFE6DFD5),
              width: hasErrorBorder ? 1.5 : 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
              color: hasErrorBorder ? errorColor : darkBrown, width: 1.5),
        ),
      ),
    );
  }
}
