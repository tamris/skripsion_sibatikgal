import 'package:flutter/material.dart';
import 'package:batikara/app/data/models/batik_model.dart'; // Pastikan path model kamu benar
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart'; // 1. IMPORT PACKAGE SHARE_PLUS Di SINI

class BatikAppBar extends StatelessWidget {
  final BatikModel batik; // 2. TERIMA DATA BATIK DI SINI
  final Color buttonColor;
  final Color textDark;

  const BatikAppBar({
    super.key,
    required this.batik, // Wajib diisi saat dipanggil
    required this.buttonColor,
    required this.textDark,
  });

  // 3. FUNGSI SHARE BERSTANDAR BEST PRACTICE
  void _shareBatikContent() {
    // Menyusun teks estetik yang akan dikirim ke aplikasi lain
    final String shareMessage =
        '''
✨ *Kamus Batik Tegalan* ✨

*Motif:* ${batik.title}
*Kategori:* ${batik.category}
*Teknik:* ${batik.technique}

*Makna & Filosofi:*
${batik.deskripsi}

Yuk pelajari dan lestarikan kebudayaan lokal Batik Tegalan lewat aplikasi Kamus Batik!
''';

    // Eksekusi share teks
    Share.share(shareMessage, subject: 'Berbagi Motif ${batik.title}');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Row(
          children: [
            _buildCircleButton(
              icon: Icons.arrow_back,
              color: textDark,
              onPressed: () => Get.back(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Detail Motif',
                textAlign: TextAlign.center,
                style: GoogleFonts.lora(
                  color: buttonColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // 4. HUBUNGKAN FUNGSI KE TOMBOL SHARE
            _buildCircleButton(
              icon: Icons.share_outlined,
              color: buttonColor,
              onPressed: _shareBatikContent, // Panggil fungsi share saat diklik
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: buttonColor.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: 20,
        icon: Icon(icon, color: color),
        onPressed: onPressed,
      ),
    );
  }
}