import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeSectionTitle extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onTap;

  const HomeSectionTitle({
    super.key,
    required this.title,
    this.action,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Palet warna premium konsisten Batikara
    const darkBrown = Color(0xFF1C1308); // Cokelat gelap utama untuk judul
    const textMuted =
        Color(0xFF7A7062); // Cokelat pudar/abu-abu untuk teks aksi

    return Padding(
      // Padding diselaraskan agar jarak antar section di beranda terasa lega dan pas
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      child: Row(
        children: [
          // Judul Utama Section
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700, // Ketebalan bold yang tegas
              color: darkBrown, // Mengganti warna hitam bawaan
            ),
          ),
          const Spacer(),

          // Tombol Aksi Kanan (Misal: "Lihat Semua")
          if (action != null)
            GestureDetector(
              onTap: onTap,
              child: Text(
                action!,
                style: GoogleFonts.poppins(
                  fontSize:
                      13, // Sedikit diperkecil dari 14 agar hirarki visualnya lebih manis
                  color:
                      textMuted, // Mengganti warna terracotta lama dengan warna sekunder pudar
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration
                      .underline, // Memberikan efek underline halus sebagai penanda link klik
                ),
              ),
            ),
        ],
      ),
    );
  }
}
