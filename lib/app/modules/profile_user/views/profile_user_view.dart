import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../controllers/profile_user_controller.dart';

class ProfileUserView extends GetView<ProfileUserController> {
  const ProfileUserView({super.key});

  @override
  Widget build(BuildContext context) {
    const bgCanvas = Color(0xFFFAF7F2);
    const darkBrown = Color(0xFF1C1308);
    const textMuted = Color(0xFF7A7062);
    const accentGold = Color(0xFFFBBF24);
    const borderColor = Color(0xFFE6DFD5);

    return Scaffold(
      backgroundColor: bgCanvas,
      appBar: AppBar(
        backgroundColor: bgCanvas,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Center(
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.all(10),
                child: const Icon(Icons.arrow_back_rounded,
                    color: darkBrown, size: 20),
              ),
            ),
          ),
        ),
        title: Text(
          'Profil Pengguna',
          style: GoogleFonts.lora(
            color: darkBrown,
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Obx(() {
          // --- INOVASI: GANTI LOADING CIRCLE DENGAN PREMIUM SHIMMER LAYOUT ---
          if (controller.isLoading.value) {
            return _buildShimmerLoading(borderColor);
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),

                      // --- FOTO PROFIL STACK REAKTIF ---
                      Center(
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: borderColor, width: 2),
                              ),
                              child: CircleAvatar(
                                radius: 56,
                                backgroundColor: const Color(0xFFF2ECE0),
                                backgroundImage: controller
                                        .selectedLocalPath.value.isNotEmpty
                                    ? FileImage(File(
                                            controller.selectedLocalPath.value))
                                        as ImageProvider
                                    : (controller
                                            .profilePictureUrl.value.isNotEmpty
                                        ? NetworkImage(
                                            controller.profilePictureUrl.value)
                                        : const AssetImage(
                                                'assets/images/avatar.png')
                                            as ImageProvider),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () => controller.pickImageFromGallery(),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: darkBrown,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 6,
                                        offset: Offset(0, 3),
                                      )
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_outlined,
                                    size: 16,
                                    color: accentGold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      _ProfileTextField(
                        label: 'Username',
                        controller: controller.usernameC,
                        icon: Icons.person_outline_rounded,
                        darkBrown: darkBrown,
                        textMuted: textMuted,
                        borderColor: borderColor,
                      ),
                      const SizedBox(height: 20),

                      _ProfileTextField(
                        label: 'E-Mail',
                        controller: controller.emailC,
                        icon: Icons.mail_outline_rounded,
                        readOnly: true,
                        keyboardType: TextInputType.emailAddress,
                        darkBrown: darkBrown,
                        textMuted: textMuted,
                        borderColor: borderColor,
                      ),
                      const SizedBox(height: 20),

                      // --- PILIHAN JENIS KELAMIN REAKTIF ---
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jenis Kelamin',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: darkBrown,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: ['Laki-laki', 'Perempuan'].map((gender) {
                              final isSelected =
                                  controller.selectedGender.value == gender;

                              return Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.selectedGender.value = gender;
                                    controller.genderC.text = gender;
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    margin: EdgeInsets.only(
                                      right: gender == 'Laki-laki' ? 6 : 0,
                                      left: gender == 'Perempuan' ? 6 : 0,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    decoration: BoxDecoration(
                                      color:
                                          isSelected ? darkBrown : Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: isSelected
                                            ? darkBrown
                                            : borderColor,
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          gender == 'Laki-laki'
                                              ? Icons.male_rounded
                                              : Icons.female_rounded,
                                          size: 18,
                                          color: isSelected
                                              ? accentGold
                                              : textMuted,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          gender,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: isSelected
                                                ? FontWeight.w700
                                                : FontWeight.w500,
                                            color: isSelected
                                                ? Colors.white
                                                : darkBrown,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // --- PREMIUM PICKER TANGGAL LAHIR ---
                      GestureDetector(
                        onTap: () => controller.chooseTanggalLahir(context),
                        child: AbsorbPointer(
                          child: _ProfileTextField(
                            label: 'Tanggal Lahir',
                            controller: controller.tanggalLahirC,
                            icon: Icons.calendar_today_outlined,
                            darkBrown: darkBrown,
                            textMuted: textMuted,
                            borderColor: borderColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),

              // ================= BOTTOM PANEL SIMPAN =================
              Container(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
                decoration: BoxDecoration(
                  color: bgCanvas,
                  boxShadow: [
                    BoxShadow(
                      color: darkBrown.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: controller.isSaving.value
                      ? null
                      : () => controller.saveProfileChanges(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkBrown,
                    foregroundColor: accentGold,
                    minimumSize: const Size(double.infinity, 52),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: controller.isSaving.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: accentGold,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle_outline_rounded,
                                size: 18, color: accentGold),
                            const SizedBox(width: 8),
                            Text(
                              'Simpan Perubahan',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: accentGold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  // Widget Pembantu untuk Membentuk Kerangka Boneka Shimmer yang Rapi
  Widget _buildShimmerLoading(Color baseBorderColor) {
    return Shimmer(
      duration: const Duration(milliseconds: 1200),
      interval: const Duration(milliseconds: 200),
      color: const Color(0xFFE6DFD5),
      colorOpacity: 1,
      enabled: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Bulatan tiruan avatar
            Center(
              child: Container(
                width: 112,
                height: 112,
                decoration: const BoxDecoration(
                  color: const Color.fromARGB(255, 226, 226, 226),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(height: 44),
            // List bar berulang meniru form input
            ...List.generate(4, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kotak Label
                    Container(
                      width: 90,
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 226, 226, 226),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Kotak Input Field
                    Container(
                      width: double.infinity,
                      height: 54,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 226, 226, 226),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _ProfileTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final bool readOnly;
  final TextInputType? keyboardType;
  final Color darkBrown;
  final Color textMuted;
  final Color borderColor;

  const _ProfileTextField({
    required this.label,
    required this.controller,
    required this.icon,
    required this.darkBrown,
    required this.textMuted,
    required this.borderColor,
    this.readOnly = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: darkBrown,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: keyboardType,
          cursorColor: darkBrown,
          style: GoogleFonts.poppins(
            fontSize: 15,
            color: readOnly ? textMuted.withOpacity(0.8) : darkBrown,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: 'Belum diisi...',
            hintStyle: GoogleFonts.poppins(
              color: textMuted.withOpacity(0.4),
              fontSize: 14,
            ),
            filled: true,
            fillColor: readOnly ? const Color(0xFFF4F0E6) : Colors.white,
            prefixIcon: Icon(icon, color: textMuted.withOpacity(0.6), size: 18),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: readOnly ? Colors.transparent : borderColor,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: readOnly ? Colors.transparent : darkBrown,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
