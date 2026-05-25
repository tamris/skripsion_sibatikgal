import 'dart:io';
import 'package:batikara/app/data/service/galeri_service.dart';
import 'package:batikara/app/modules/galeri_page/views/galeri_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:batikara/app/modules/deteksi_page/controllers/deteksi_page_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HasilDeteksiView extends StatelessWidget {
  final DeteksiPageController controller;
  final Color colorPrimary;
  final Color colorCardBg;
  final Color textDark;

  const HasilDeteksiView({
    super.key,
    required this.controller,
    required this.colorPrimary,
    required this.colorCardBg,
    required this.textDark,
  });

  Future<void> _openDetectedMotifDetail() async {
    final String detectedMotifName = controller.motifName.value.trim();
    if (detectedMotifName.isEmpty) {
      Get.snackbar(
        'Motif tidak tersedia',
        'Hasil deteksi belum memiliki nama motif yang valid.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    final batik = await GaleriService.fetchBatikByMotifName(detectedMotifName);

    if (Get.isDialogOpen ?? false) {
      Get.back();
    }

    if (batik == null) {
      Get.snackbar(
        'Detail tidak ditemukan',
        'Motif "$detectedMotifName" belum tersedia di data galeri.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.to(() => GaleriDetailView(batik: batik));
  }

  @override
  Widget build(BuildContext context) {
    // Tombol lingkaran tipis untuk top bar sesuai desain
    final decorationTopButton = BoxDecoration(
      color: colorCardBg,
      borderRadius: BorderRadius.circular(14),
    );

    return Column(
      children: [
        // --- 1. CUSTOM TOP BAR (SIMETRIS KIRI & KANAN) ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Tombol Back Kiri
              Container(
                decoration: decorationTopButton,
                child: IconButton(
                  onPressed: () {
                    controller.selectedImagePath.value = '';
                    controller.isDetected.value = false;
                  },
                  icon: Icon(Icons.arrow_back, color: textDark, size: 20),
                ),
              ),
              // Judul Tengah
              Text(
                'Hasil Deteksi',
                style: GoogleFonts.lora(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
              // Tombol Share Kanan
              Container(
                decoration: decorationTopButton,
                child: IconButton(
                  onPressed: () {
                    // Fitur share data skripsi
                  },
                  icon: Icon(Icons.share_outlined, color: textDark, size: 20),
                ),
              ),
            ],
          ),
        ),

        const Divider(height: 1, color: Color(0xFFEFE7DD)),

        // --- INTERNALS SCROLLABLE CONTENT ---
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- 2. WADAH GAMBAR DENGAN ACCURACY FLOATING BADGE ---
                Container(
                  width: double.infinity,
                  height: 280,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    image: DecorationImage(
                      image: FileImage(
                        File(controller.selectedImagePath.value),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // --- 3. TAG KATEGORI BATIK ---
                // Container(
                //   padding: const EdgeInsets.symmetric(
                //     horizontal: 12,
                //     vertical: 6,
                //   ),
                //   decoration: BoxDecoration(
                //     color: colorCardBg,
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                //   child: Text(
                //     'Klasik', // Bisa dinamis dari DB kalau ada field kategorinya nanti bro
                //     style: GoogleFonts.poppins(
                //       fontSize: 11,
                //       color: textDark.withValues(alpha: 0.6),
                //       fontWeight: FontWeight.w500,
                //     ),
                //   ),
                // ),
                const SizedBox(height: 8),

                // --- 4. NAMA MOTIF & TIMESTAMP ---
                Text(
                  controller.motifName.value,
                  style: GoogleFonts.lora(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: textDark.withValues(alpha: 0.5),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Terdeteksi pada ${controller.historyList.isNotEmpty ? controller.historyList[0]['waktu_relatif'] : 'Baru saja'}',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: textDark.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                const Divider(),
                const SizedBox(height: 16),

                // --- 5. MAKNA SINGKAT TEXT ---
                Text(
                  'Makna Singkat',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  controller.filosofi.value,
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.mulish(
                    fontSize: 16,
                    color: textDark.withValues(alpha: 0.7),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),

                // --- 6. ACTION BUTTONS (PERSIS SAMA SEPERTI BAWAH DESAIN LU) ---
                Row(
                  children: [
                    // Tombol Lihat Detail Motif (Cokelat Tua)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _openDetectedMotifDetail,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: Text(
                          'Lihat Detail Motif',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Tombol Deteksi Ulang (Krem Lembut Berborder)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          controller.selectedImagePath.value = '';
                          controller.isDetected.value = false;
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: colorCardBg,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          side: BorderSide(
                            color: colorPrimary.withValues(alpha: 0.2),
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: Text(
                          'Deteksi Ulang',
                          style: GoogleFonts.poppins(
                            color: textDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}