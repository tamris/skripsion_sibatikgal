import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/tentang_aplikasi_page_controller.dart';

class TentangAplikasiPageView extends GetView<TentangAplikasiPageController> {
  const TentangAplikasiPageView({super.key});

  @override
  Widget build(BuildContext context) {
    // Palet warna premium Batikara yang konsisten
    const bgCanvas = Color(0xFFFAF7F2);
    const darkBrown = Color(0xFF1C1308);
    const textMuted = Color(0xFF7A7062);
    const accentGold = Color(0xFFFBBF24);
    const cardBg = Color(0xFFF2ECE0);

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
          'Tentang Aplikasi',
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
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // --- LOGO APPLIKASI BOX ---
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: darkBrown,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: darkBrown.withOpacity(0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        // Ganti dengan Image.asset jika logo berupa gambar png
                        child: const Icon(
                          Icons.auto_awesome_mosaic_rounded,
                          color: accentGold,
                          size: 48,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Nama Aplikasi & Versi
                    Text(
                      'Sibatikgal',
                      style: GoogleFonts.lora(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: darkBrown,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Versi 1.0.0',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: textMuted,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // --- DESKRIPSI KARTU ---
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: const Color(0xFFE6DFD5), width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pelestarian Budaya Lokal',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: darkBrown,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Sibatikgal merupakan sistem inovatif berbasis Computer Vision yang dirancang khusus untuk mendeteksi dan mengenali berbagai motif indah Batik Tegalan. Melalui teknologi ini, kami berkomitmen mendukung penuh pelestarian digital sekaligus mengedukasi masyarakat luas mengenai warisan kekayaan budaya lokal.',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: textMuted,
                              height: 1.6,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // --- KARTU INFO DEPLOYMENT / COPYRIGHT ---
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.verified_user_outlined,
                              color: Color(0xFF5C4D3C), size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Dikembangkan secara resmi untuk mendukung Digitalisasi Budaya Indonesia.',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF5C4D3C),
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ================= FOOTER COPYRIGHT =================
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                '© 2026 Sibatikgal. All Rights Reserved.',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: textMuted.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
