import 'package:batikara/app/modules/deteksi_page/controllers/deteksi_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class IdleView extends StatelessWidget {
  final DeteksiPageController controller;
  final Color colorPrimary;
  final Color colorCardBg;
  final Color colorSecondaryBg;
  final Color textDark;

  const IdleView({
    super.key,
    required this.controller,
    required this.colorPrimary,
    required this.colorCardBg,
    required this.colorSecondaryBg,
    required this.textDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --- SLOT CONTAINER UTAMA (IDLE PLACEHOLDER) ---
        Container(
          width: double.infinity,
          height: 330,
          decoration: BoxDecoration(
            color: colorCardBg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: colorPrimary.withValues(alpha: 0.3),
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.photo_camera_outlined,
                size: 64,
                color: colorPrimary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  'Arahkan kamera ke motif batik atau unggah foto',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: textDark,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // --- HINT CARD INFORMASI ---
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorSecondaryBg.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(Icons.lightbulb_outline, color: colorPrimary, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Pastikan foto jelas dan pencahayaan cukup untuk hasil deteksi terbaik.',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: textDark,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // --- TOMBOL AKSI ---
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => controller.pickImage(ImageSource.camera),
                icon: const Icon(Icons.camera_alt, color: Colors.white),
                label: Text(
                  'Kamera',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => controller.pickImage(ImageSource.gallery),
                icon: Icon(Icons.image, color: colorPrimary),
                label: Text(
                  'Galeri',
                  style: GoogleFonts.poppins(
                    color: colorPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorSecondaryBg,
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
