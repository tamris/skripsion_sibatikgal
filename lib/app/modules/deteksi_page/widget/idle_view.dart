import 'package:batikara/app/modules/deteksi_page/controllers/deteksi_page_controller.dart';
import 'package:batikara/app/modules/deteksi_page/widget/deteksi_shared_components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    required this.colorCardBg,
    required this.colorSecondaryBg,
    required this.textDark,
    required this.colorPrimary,
  });

  @override
  Widget build(BuildContext context) {
    // Observable khusus untuk status expand/collapse panduan deteksi
    final isGuideExpanded = false.obs;

    return Column(
      children: [
        // --- 1. KONTAINER UTAMA BESAR (BINGKAI & TOMBOL MENYATU DI SINI) ---
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: DeteksiColors.cDark, // Warna hitam gelap sesuai mockup
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Area Bingkai Lensa Kamera Internal
              Container(
                width: double.infinity,
                height: 280,
                color: Colors.transparent,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Garis Siku Bingkai Kamera Emas/Kuning
                    Positioned.fill(
                      child: CustomPaint(
                        painter: CameraFramePainter(
                          color: DeteksiColors.cGold.withValues(
                            alpha: 0.8,
                          ), // Siku warna emas khas mockup
                        ),
                      ),
                    ),
                    // Lingkaran Target Tengah Modul AI
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFEFE7DD).withValues(alpha: 0.1),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: DeteksiColors.cBorder.withValues(
                                alpha: 0.15,
                              ),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Icon & Instruksi Tengah Lensa
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.photo_camera_outlined,
                          size: 36,
                          color: DeteksiColors.cBorder.withValues(alpha: 0.4),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Arahkan ke motif',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: DeteksiColors.cBorder.withValues(alpha: 0.5),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // --- TOMBOL AKSI SEKARANG MENYATU DI DALAM KONTAINER ---
              Row(
                children: [
                  // Tombol Upload Galeri (Abu-abu Gelap Transparan)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          controller.pickImage(ImageSource.gallery),
                      icon: const Icon(
                        Icons.image_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                      label: Text(
                        'Upload Galeri',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFF2C2318,
                        ), // Warna tombol gelap serasi
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Tombol Buka Kamera (Kuning Emas Cerah)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => controller.pickImage(ImageSource.camera),
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Color(0xFF1A1208),
                        size: 20,
                      ),
                      label: Text(
                        'Buka Kamera',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF1A1208),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFFFCD36A,
                        ), // Warna Kuning Emas Mockup
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // --- 2. DROPDOWN PANDUAN DETEKSI (PADA BAGIAN BAWAH KONTAINER) ---
        Obx(() {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: textDark.withValues(alpha: 0.06),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // Header Panel Panduan
                InkWell(
                  onTap: () => isGuideExpanded.toggle(),
                  borderRadius: BorderRadius.circular(22),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colorSecondaryBg.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.lightbulb_outline,
                            color: DeteksiColors.cGold,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            'Panduan Deteksi',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: textDark,
                            ),
                          ),
                        ),
                        AnimatedRotation(
                          turns: isGuideExpanded.value ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: textDark.withValues(alpha: 0.4),
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Isi Item Detail Panduan dengan Transisi Halus
                AnimatedCrossFade(
                  firstChild: const SizedBox(width: double.infinity),
                  secondChild: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      bottom: 20.0,
                    ),
                    child: Column(
                      children: [
                        const Divider(height: 1, color: DeteksiColors.cBorder),
                        const SizedBox(height: 16),
                        _buildGuideStep(
                          '1',
                          'Pastikan pencahayaan cukup & motif tidak buram',
                        ),
                        _buildGuideStep(
                          '2',
                          'Posisikan motif penuh dalam bingkai kamera',
                        ),
                        _buildGuideStep(
                          '3',
                          'Bisa pakai kamera langsung atau upload dari galeri',
                        ),
                      ],
                    ),
                  ),
                  crossFadeState: isGuideExpanded.value
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 200),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // Widget Item Baris Nomor Panduan Deteksi
  Widget _buildGuideStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: DeteksiColors.cDark,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: GoogleFonts.poppins(
                  color: DeteksiColors.cGold,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 1.0),
              child: Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: textDark.withValues(alpha: 0.75),
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- CUSTOM PAINTER: BINGKAI SIKU INDIKATOR KAMERA MOCKUP ---
class CameraFramePainter extends CustomPainter {
  final Color color;
  CameraFramePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    const double length = 24.0;

    // Siku Kiri Atas
    canvas.drawPath(
      Path()
        ..moveTo(0, length)
        ..lineTo(0, 0)
        ..lineTo(length, 0),
      paint,
    );
    // Siku Kanan Atas
    canvas.drawPath(
      Path()
        ..moveTo(size.width - length, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, length),
      paint,
    );
    // Siku Kiri Bawah
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height - length)
        ..lineTo(0, size.height)
        ..lineTo(length, size.height),
      paint,
    );
    // Siku Kanan Bawah
    canvas.drawPath(
      Path()
        ..moveTo(size.width - length, size.height)
        ..lineTo(size.width, size.height)
        ..lineTo(size.width, size.height - length),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
