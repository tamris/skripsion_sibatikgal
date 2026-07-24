import 'package:batikara/app/modules/deteksi_page/views/detail_history_view.dart';
import 'package:batikara/app/modules/deteksi_page/views/hasil_deteksi_view.dart';
import 'package:batikara/app/modules/deteksi_page/views/riwayat_deteksi.dart';
import 'package:batikara/app/modules/deteksi_page/widget/deteksi_shared_components.dart';
import 'package:batikara/app/modules/deteksi_page/widget/idle_view.dart';
import 'package:batikara/app/modules/deteksi_page/widget/loading_stepper.view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Impor cache gambar premium
import 'package:shimmer_animation/shimmer_animation.dart'; // Impor paket shimmer andalanmu
import '../controllers/deteksi_page_controller.dart';

class DeteksiPageView extends GetView<DeteksiPageController> {
  const DeteksiPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DeteksiColors.cKrem,
      body: SafeArea(
        child: Obx(() {
          // ==========================================
          // KONDISI 1: HALAMAN FULL HASIL DETEKSI (DESAIN BARU)
          // ==========================================
          if (controller.isDetected.value && !controller.isLoading.value) {
            return HasilDeteksiView(controller: controller);
          }

          // ==========================================
          // KONDISI 2 & 3: HALAMAN UTAMA (IDLE / LOADING STEPPER)
          // Memiliki Header Fitur & Komponen Riwayat Deteksi di bawah
          // ==========================================
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- HEADER UTAMA ---
                Text(
                  'Fitur AI',
                  style: GoogleFonts.lora(
                    fontSize: 14,
                    color: DeteksiColors.cBrown,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Deteksi Motif',
                  style: GoogleFonts.lora(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: DeteksiColors.cDark,
                  ),
                ),
                const SizedBox(height: 24),

                // Switch antara Loading Stepper atau Tampilan Idle awal
                controller.isLoading.value
                    ? LoadingStepperView(
                        controller: controller,
                        colorPrimary: DeteksiColors.cDark,
                        textDark: DeteksiColors.cDark,
                      )
                    : IdleView(
                        controller: controller,
                        colorPrimary: DeteksiColors.cDark,
                        colorCardBg: DeteksiColors.cKremChip,
                        colorSecondaryBg: DeteksiColors.cKremChip,
                        textDark: DeteksiColors.cDark,
                      ),
                const SizedBox(height: 28),

                // --- SECTION RIWAYAT DETEKSI ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Riwayat Deteksi',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: DeteksiColors.cDark,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(() => const RiwayatDeteksiView());
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Lihat semua',
                            style: GoogleFonts.poppins(
                              color: DeteksiColors.cBrown,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: DeteksiColors.cBrown,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // --- LIST KARTU RIWAYAT ---
                _buildHistorySection(
                  cardWidthCalc(context),
                  DeteksiColors.cDark,
                  DeteksiColors.cKremChip,
                  DeteksiColors.cDark,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // Helper hitung lebar kartu riwayat biar ga numpuk kodenya
  double cardWidthCalc(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return (screenWidth - 48.0 - 24.0) / 3;
  }

  Widget _buildHistorySection(
    double cardWidth,
    Color colorPrimary,
    Color colorSecondaryBg,
    Color textDark,
  ) {
    // 1. STATE LOADING UTAMA SECTION: Menggunakan Horizontal Skeleton Shimmer Premium
    if (controller.isLoadingHistory.value) {
      return _buildHistoryShimmer(cardWidth, colorPrimary);
    }

    if (controller.historyList.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Belum ada riwayat deteksi.',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    final displayedHistory = controller.historyList.take(3).toList();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(displayedHistory.length, (index) {
        final item = displayedHistory[index];
        final String namaMotif = item['nama_motif'] ?? 'Batik';
        final String tanggal = item['waktu_relatif'] ?? 'Baru saja';
        final String fullImageUrl = item['full_image_url'] ?? '';

        return InkWell(
          onTap: () {
            Get.to(
              () => DetailHistoryView(
                historyData: {
                  'nama_motif': namaMotif,
                  'waktu_relatif': tanggal,
                  'full_image_url': fullImageUrl,
                  'makna': item['makna'],
                  'confidence': item['confidence'],
                },
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: cardWidth,
            margin: EdgeInsets.only(
              right: index == displayedHistory.length - 1 ? 0 : 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorPrimary.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  // 2. FIXED INTERNAL IMAGE: Menggunakan CachedNetworkImage + Shimmer Internal
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    color: colorSecondaryBg.withValues(alpha: 0.4),
                    child: fullImageUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: fullImageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer(
                              color: const Color(0xFFFAF7F2),
                              colorOpacity: 0.5,
                              duration: const Duration(milliseconds: 1200),
                              child: Container(color: const Color(0xFFE6DFD5)),
                            ),
                            errorWidget: (c, e, s) => Center(
                              child: Icon(
                                Icons.broken_image_outlined,
                                color: colorPrimary,
                                size: 24,
                              ),
                            ),
                          )
                        : Center(
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: colorPrimary,
                              size: 24,
                            ),
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        namaMotif,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tanggal,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ================= INDUSTRIAL STANDARD: HORIZONTAL REPEAT SKELETON SHIMMER =================
  Widget _buildHistoryShimmer(double cardWidth, Color colorPrimary) {
    const shimmerBg = Color(0xFFEFECE6);
    const maskColor = Color(0xFFE2DDD5);

    return Shimmer(
      color: const Color(0xFFFAF7F2),
      colorOpacity: 0.5,
      duration: const Duration(milliseconds: 1200),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(3, (index) {
          return Container(
            width: cardWidth,
            margin: EdgeInsets.only(right: index == 2 ? 0 : 12),
            decoration: BoxDecoration(
              color: shimmerBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorPrimary.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Topeng Thumbnail Gambar Atas Kartu
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: maskColor,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(15)),
                  ),
                ),
                // Topeng Area Teks Info Bawah Kartu
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 55,
                        height: 12,
                        decoration: BoxDecoration(
                          color: maskColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 40,
                        height: 10,
                        decoration: BoxDecoration(
                          color: maskColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
