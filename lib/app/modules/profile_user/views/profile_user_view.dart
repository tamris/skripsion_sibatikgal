import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileUserView extends StatelessWidget {
  const ProfileUserView({super.key});

  @override
  Widget build(BuildContext context) {
    // Palette warna premium konsisten Batikara
    const bgCanvas = Color(0xFFFAF7F2);
    const darkBrown = Color(0xFF1C1308);
    const textMuted = Color(0xFF7A7062);
    const accentGold = Color(0xFFFBBF24);
    const borderColor = Color(0xFFE6DFD5);

    return Scaffold(
      backgroundColor: bgCanvas,
      // ================= FIXED APP BAR =================
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
                child: const Icon(Icons.arrow_back, color: darkBrown, size: 20),
              ),
            ),
          ),
        ),
        title: Text(
          'Profil Pengguna',
          style: GoogleFonts.lora(
            color: darkBrown,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),

      // ================= BODY CONTENT =================
      body: SafeArea(
        child: Column(
          children: [
            // Konten Form yang Scrollable
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 12),

                    // --- FOTO PROFIL STACK ---
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: const Color(0xFFE6DFD5), width: 2),
                            ),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: const Color(0xFFF2ECE0),
                              backgroundImage:
                                  const AssetImage('assets/images/avatar.png'),
                              // Fallback jika asset kosong
                            ),
                          ),
                          // Tombol Ganti Foto Kustom
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: GestureDetector(
                              onTap: () {}, // Aksi ganti foto
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  color: darkBrown,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                        offset: Offset(0, 2))
                                  ],
                                ),
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  size: 18,
                                  color: accentGold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 36),

                    // --- FORM INPUT PROFILE ---
                    _ProfileTextField(
                      label: 'Nama Lengkap',
                      hint: 'Rizqi Pratama',
                      icon: Icons.person_outline_rounded,
                      darkBrown: darkBrown,
                      textMuted: textMuted,
                      borderColor: borderColor,
                    ),
                    const SizedBox(height: 20),

                    _ProfileTextField(
                      label: 'E-Mail',
                      hint: 'johndoe@gmail.com',
                      icon: Icons.mail_outline_rounded,
                      keyboardType: TextInputType.emailAddress,
                      darkBrown: darkBrown,
                      textMuted: textMuted,
                      borderColor: borderColor,
                    ),
                    const SizedBox(height: 20),

                    _ProfileTextField(
                      label: 'Jenis Kelamin',
                      hint: 'Laki-laki',
                      icon: Icons.wc_rounded,
                      darkBrown: darkBrown,
                      textMuted: textMuted,
                      borderColor: borderColor,
                    ),
                    const SizedBox(height: 20),

                    _ProfileTextField(
                      label: 'Tanggal Lahir',
                      hint: '12 Desember 1998',
                      icon: Icons.calendar_today_outlined,
                      keyboardType: TextInputType.datetime,
                      darkBrown: darkBrown,
                      textMuted: textMuted,
                      borderColor: borderColor,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ================= BOTTOM BUTTON SIMPAN =================
            Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              color: bgCanvas, // Agar transisi scroll rapi di belakang button
              child: ElevatedButton(
                onPressed: () {
                  // Aksi simpan profile
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      darkBrown, // Menggunakan warna gelap utama biar kontras
                  foregroundColor: accentGold,
                  minimumSize: const Size(double.infinity, 54),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
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
        ),
      ),
    );
  }
}

// ================= CUSTOM INPUT COMPONENT =================
class _ProfileTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final Color darkBrown;
  final Color textMuted;
  final Color borderColor;

  const _ProfileTextField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.darkBrown,
    required this.textMuted,
    required this.borderColor,
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
          keyboardType: keyboardType,
          cursorColor: darkBrown,
          style: GoogleFonts.poppins(
              fontSize: 15, color: darkBrown, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
                color: textMuted.withOpacity(0.5), fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(icon, color: textMuted.withOpacity(0.7), size: 20),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: borderColor, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: borderColor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: darkBrown, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
