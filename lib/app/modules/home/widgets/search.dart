import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/home_controller.dart';

class HomeSearchBar extends GetView<HomeController> {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    // Palet warna premium konsisten Batikara
    const darkBrown = Color(0xFF1C1308); // Cokelat gelap utama
    const textMuted = Color(0xFF7A7062); // Warna teks sekunder
    const borderColor = Color(0xFFE6DFD5); // Garis tepi tipis premium

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: TextField(
        controller: controller.searchC,
        cursorColor: darkBrown, // Cursor disamakan dengan warna teks utama
        style: GoogleFonts.poppins(
            fontSize: 15, color: darkBrown, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: 'Cari informasi batik...',
          hintStyle: GoogleFonts.poppins(
            color: textMuted.withOpacity(0.5),
            fontSize: 14,
          ),
          filled: true,
          fillColor: Colors
              .white, // Menggunakan putih solid agar terlihat bersih di atas kanvas krem
          prefixIcon: Icon(Icons.search_rounded,
              color: textMuted.withOpacity(0.7), size: 20),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 20),

          // Enabled Border: Menggunakan warna garis tepi halus
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: borderColor, width: 1.0),
          ),

          // Focused Border: Menggunakan darkBrown yang tegas dan elegan
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: darkBrown, width: 1.5),
          ),
        ),
      ),
    );
  }
}
