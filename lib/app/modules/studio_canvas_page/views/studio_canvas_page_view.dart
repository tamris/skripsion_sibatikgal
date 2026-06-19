import 'package:batikara/app/modules/studio_canvas_page/views/detail_studio_canvas.dart';
import 'package:batikara/app/modules/studio_canvas_page/views/studio_history_page_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/studio_canvas_page_controller.dart';

class StudioCanvasPageView extends StatelessWidget {
  const StudioCanvasPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StudioCanvasPageController());

    const Color cGold = Color(0xFFFFD264);
    const Color cDark = Color(0xFF1A1208);
    const Color cBg = Color(0xFFF9F8F4);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F8F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F8F4),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 20),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              'STUDIO',
              style: GoogleFonts.lora(
                color: Colors.grey,
                fontSize: 16,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Pilih Motif',
              style: GoogleFonts.lora(
                color: Colors.black87,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.palette_outlined,
              color: Color(0xFF1A1208),
              size: 24,
            ),
            tooltip: 'Galeri Karyaku',
            onPressed: () => Get.to(() => const StudioHistoryPageView()),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Obx(() {
        // 🟢 BEST PRACTICE: Jika loading, tampilkan halaman tiruan full bertema Shimmer
        if (controller.isLoading.value) {
          return _buildFullPageShimmer();
        }

        if (controller.isError.value) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon radar/koneksi putus yang mudah dipahami orang awam
                  Icon(
                    Icons.wifi_off_rounded,
                    size: 72,
                    color: Colors.brown.shade300,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Koneksi Internet Terputus',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: cDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Gagal menghubungkan ke studio galeri. Pastikan jaringan internet ponsel Anda aktif lalu ketuk tombol di bawah.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // TOMBOL COBA LAGI (RETRY BUTTON)
                  SizedBox(
                    width: 160,
                    height: 44,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cDark,
                        foregroundColor: cGold,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      // Memanggil kembali fungsi unduh data saat tombol ditekan
                      onPressed: () => controller.fetchBatikCanvasData(),
                      icon: const Icon(Icons.refresh_rounded, size: 18),
                      label: Text(
                        'Coba Lagi',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (controller.batikList.isEmpty) {
          return const Center(
            child: Text("Belum ada motif batik yang siap untuk studio canvas."),
          );
        }

        return Stack(
          children: [
            ListView(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
                bottom: 120,
              ),
              children: [
                // CARD BANNER: Cara Membatik
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cDark,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.info_outline,
                          color: cGold,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cara Membatik',
                              style: GoogleFonts.poppins(
                                color: cGold,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Pilih motif di bawah, lalu trace garisnya di atas kanvas. Motif akan jadi panduan sketsa yang bisa kamu ikuti.',
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // SUB-HEADER LIST
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pilih Motif',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: cDark,
                      ),
                    ),
                    Text(
                      '${controller.batikList.length} motif tersedia',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // GRID CARD BATIK ASLI (Data Sudah Siap)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: controller.batikList.length,
                  itemBuilder: (context, index) {
                    final batik = controller.batikList[index];
                    final isSelected =
                        controller.selectedBatikIndex.value == index;

                    return GestureDetector(
                      onTap: () => controller.selectBatik(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        decoration: BoxDecoration(
                          color: isSelected ? cDark : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: isSelected
                              ? null
                              : Border.all(
                                  color: Colors.grey.withValues(alpha: 0.2),
                                ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    margin: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEFECE5),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: CachedNetworkImage(
                                        imageUrl: batik.imageUrl,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Container(
                                              color: Colors.grey.shade200,
                                            ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.broken_image),
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    Positioned(
                                      top: 14,
                                      right: 14,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: cGold,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 14,
                                right: 14,
                                bottom: 14,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    batik.name,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected ? cGold : cDark,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    batik.category,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: isSelected
                                          ? Colors.white60
                                          : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),

            // FLOATING ACTION BUTTON
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 24,
                  top: 16,
                ),
                decoration: const BoxDecoration(
                  color: cBg,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: cDark.withValues(alpha: 0.25),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cDark,
                      foregroundColor: cGold,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      if (controller.currentSelectedBatik != null) {
                        Get.to(
                          () => const DetailStudioCanvas(),
                          arguments: controller.currentSelectedBatik,
                        );
                      } else {
                        Get.snackbar(
                          'Peringatan',
                          'Silakan pilih motif batik terlebih dahulu',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      }
                    },
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    label: Text(
                      'Mulai Membatik — ${controller.currentSelectedBatik?.name ?? ""}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // --- 🟢 HELPER UI: FUNGSI MEMBUAT SHIMMER SATU HALAMAN PENUH (BEST PRACTICE) ---
  Widget _buildFullPageShimmer() {
    return Shimmer(
      duration: const Duration(seconds: 2),
      interval: const Duration(milliseconds: 200),
      color: Colors.white,
      colorOpacity: 0.4,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // 1. Shimmer untuk Banner Atas (Cara Membatik)
          Container(
            width: double.infinity,
            height: 110,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          const SizedBox(height: 28),

          // 2. Shimmer untuk Sub-Header "Pilih Motif"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 100,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                width: 80,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 3. Shimmer Grid Tiruan (Bentuknya mirip persis dengan struktur Card Batik asli)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: 4, // Tampilkan 4 kotak dummy penahan ruang saat loading
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kotak Gambar Dummy
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    // Garis Teks Judul Dummy
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Container(
                        width: 100,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Garis Teks Kategori Dummy
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 14,
                        right: 14,
                        bottom: 14,
                      ),
                      child: Container(
                        width: 60,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}