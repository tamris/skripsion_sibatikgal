import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LogoutDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const LogoutDialog({
    super.key,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    // Palet warna premium sesuai tema utama kamu
    const darkBrown = Color(0xFF1C1308);
    const bgCanvas = Color(0xFFFAF7F0);
    const textMuted = Color(0xFF7A7062);
    const accentGold = Color(0xFFFBBF24);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: bgCanvas,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // Biar tinggi dialog pas dengan isinya
          children: [
            // Ikon Logout dengan background lingkaran soft
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF3EDE2),
              ),
              child: const Icon(
                Icons.logout_rounded,
                size: 32,
                color: darkBrown,
              ),
            ),
            const SizedBox(height: 20),

            // Judul Dialog
            Text(
              'Keluar Akun',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: darkBrown,
              ),
            ),
            const SizedBox(height: 10),

            // Deskripsi Teks
            Text(
              'Apakah kamu yakin ingin keluar dari aplikasi Sibatikgal?',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textMuted,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),

            // Baris Tombol Aksi (Batal & Keluar)
            Row(
              children: [
                // Tombol Batal
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(), // Menutup dialog
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                          color: Color(0xFFD1C7BD), width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Batal',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: darkBrown,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Tombol Konfirmasi Keluar (Solid)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back(); // Tutup dialog dulu
                      onConfirm(); // Jalankan fungsi logout dari controller
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkBrown,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Keluar',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color:
                            accentGold, // Menggunakan teks warna emas/oranye hangat
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
