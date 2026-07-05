import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InformasiSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  const InformasiSearchBar({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    // Palet warna premium konsisten Batikara
    const darkBrown = Color(0xFF1C1308); // Cokelat gelap utama
    const textMuted = Color(0xFF7A7062); // Warna teks sekunder
    const borderColor = Color(0xFFE6DFD5); // Garis tepi tipis premium

    return Padding(
      // Padding disesuaikan agar pas diletakkan di atas atau bawah chip kategori
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: TextField(
        onChanged: onChanged,
        cursorColor: darkBrown,
        style: GoogleFonts.poppins(
          fontSize: 15,
          color: darkBrown,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Cari informasi artikel...',
          hintStyle: GoogleFonts.poppins(
            color: textMuted.withOpacity(0.5),
            fontSize: 14,
          ),
          filled: true,
          fillColor: Colors
              .white, // Menggunakan putih solid bersih di atas kanvas krem
          prefixIcon: Icon(
            Icons.search_rounded,
            color: textMuted.withOpacity(0.7),
            size: 20,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 20),

          // Border saat idle (pasif)
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: borderColor, width: 1.0),
          ),

          // Border saat aktif mengetik (focused)
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: darkBrown, width: 1.5),
          ),
        ),
      ),
    );
  }
}
