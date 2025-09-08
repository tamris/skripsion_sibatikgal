import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileUserView extends StatelessWidget {
  const ProfileUserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text(
          'User Profile',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 8),
              // Foto profil dengan ikon edit
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 68,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: const AssetImage(
                        'assets/images/avatar.png'), // ganti dengan path foto profil
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 2)
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt,
                            size: 20, color: Color(0xFF8A5A44)),
                        onPressed: () {}, // aksi ganti foto
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Form input
              const _ProfileTextField(label: 'Nama', hint: 'Rizqi Pratama'),
              const SizedBox(height: 16),

              const _ProfileTextField(
                  label: 'E-Mail',
                  hint: 'johndoe@gmail.com',
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              const _ProfileTextField(
                  label: 'Jenis Kelamin',
                  hint: 'Laki-laki',
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              const _ProfileTextField(
                  label: 'Tanggal Lahir',
                  hint: '12 Desember 1998',
                  keyboardType: TextInputType.datetime),
              const SizedBox(height: 32),
              // Tombol save
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8A5A44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    'SAVE',
                    style: GoogleFonts.mulish(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextInputType? keyboardType;
  const _ProfileTextField({
    required this.label,
    required this.hint,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Mulish',
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Color(0xFF8A5A44),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontFamily: 'Mulish',
              color: Colors.grey,
              fontSize: 15,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFF2D3A6E), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
