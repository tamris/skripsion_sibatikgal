import 'package:batikara/app/data/models/batik_model.dart';
import 'package:batikara/app/modules/galeri_page/widgets/batik_action_buttons.dart';
import 'package:batikara/app/modules/galeri_page/widgets/batik_app_bar.dart';
import 'package:batikara/app/modules/galeri_page/widgets/batik_hero_image.dart';
import 'package:batikara/app/modules/galeri_page/widgets/batik_info_panel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GaleriDetailView extends StatelessWidget {
  final BatikModel batik;
  const GaleriDetailView({super.key, required this.batik});

  @override
  Widget build(BuildContext context) {
    const Color textDark = Color(0xFF3E2723);
    const Color categoryLabelBg = Color(0xFFF0EAD8);
    const Color buttonColor = Color(0xFF1A1208);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Top Bar Navigasi
            BatikAppBar(
              batik: batik, // <-- OPER DATA BATIK KE SINI
              buttonColor: buttonColor,
              textDark: textDark,
            ),
            const SizedBox(height: 4),
            const Divider(),
            const SizedBox(height: 10),

            // 2. Wadah Gambar Melengkung
            BatikHeroImage(batik: batik),
            const SizedBox(height: 10),

            // Konten Teks & Detail
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label Kategori
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: categoryLabelBg,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      batik.category,
                      style: GoogleFonts.lora(
                        color: buttonColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Judul Motif
                  Text(
                    batik.title,
                    style: GoogleFonts.lora(
                      color: textDark,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Makna Deskripsi
                  Text(
                    batik.deskripsi,
                    textAlign: TextAlign.justify,
                    style: GoogleFonts.mulish(
                      color: textDark.withValues(alpha: 0.7),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),

                  // 3. Panel Metadata Teknik, Filosofi & Warna Dominan
                  BatikInfoPanel(batik: batik, textDark: textDark),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),

                  // Sejarah Singkat Section
                  Text(
                    'Sejarah Singkat',
                    style: GoogleFonts.lora(
                      color: textDark.withValues(alpha: 0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: categoryLabelBg,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      border: Border(
                        left: BorderSide(color: buttonColor, width: 4),
                      ),
                    ),
                    child: Text(
                      batik.history,
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.mulish(
                        color: textDark,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),

                  // 4. Tombol Aksi Bawah
                  BatikActionButtons(batik: batik),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}