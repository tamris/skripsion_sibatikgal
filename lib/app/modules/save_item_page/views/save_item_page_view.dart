import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer_animation/shimmer_animation.dart'; // Tetap mempertahankan package andalanmu
import '../controllers/save_item_page_controller.dart';
import '../../galeri_page/views/galeri_detail_view.dart';

class SaveItemPageView extends GetView<SaveItemPageController> {
  const SaveItemPageView({super.key});

  @override
  Widget build(BuildContext context) {
    // Palet warna premium konsisten Batikara
    const bgCanvas = Color(0xFFFAF7F2);
    const darkBrown = Color(0xFF1C1308);
    const textMuted = Color(0xFF7A7062);
    const accentGold = Color(0xFFFBBF24);
    const borderColor = Color(0xFFE6DFD5);

    return Scaffold(
      backgroundColor: bgCanvas,
      // ================= FIXED APP BAR PREMIUM =================
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
                child: const Icon(Icons.arrow_back_rounded,
                    color: darkBrown, size: 20),
              ),
            ),
          ),
        ),
        title: Text(
          'Item Tersimpan',
          style: GoogleFonts.lora(
            color: darkBrown,
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),
        surfaceTintColor: Colors.transparent,
      ),

      body: SafeArea(
        child: Obx(() {
          // 1. STATE LOADING MENGGUNAKAN UNIFIED SKELETON SHIMMER
          if (controller.isLoading.value) {
            return _buildShimmerLoading(borderColor);
          }

          // 2. STATE ERROR / KONEKSI GAGAL
          if (controller.isError.value) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFCE8E6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.wifi_off_rounded,
                        size: 40,
                        color: Color(0xFFC2612D),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Koneksi Internet Terputus',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: darkBrown,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Gagal menghubungkan ke studio galeri. Pastikan jaringan internet ponsel Anda aktif lalu ketuk tombol di bawah.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: textMuted,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // TOMBOL COBA LAGI
                    SizedBox(
                      width: 160,
                      height: 46,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: darkBrown,
                          foregroundColor: accentGold,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () => controller.fetchSavedItems(),
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: Text(
                          'Coba Lagi',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // 3. STATE KOSONG
          if (controller.savedBatikList.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFF2ECE0),
                      ),
                      child: const Icon(Icons.bookmark_border_rounded,
                          size: 48, color: darkBrown),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Belum ada batik disimpan',
                      style: GoogleFonts.lora(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: darkBrown),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Jelajahi galeri dan ketuk ikon hati pada motif batik yang kamu sukai.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 13, color: textMuted, height: 1.4),
                    ),
                  ],
                ),
              ),
            );
          }

          // 4. STATE BERHASIL (List Item Tersimpan)
          return RefreshIndicator(
            onRefresh: () => controller.fetchSavedItems(isRefresh: true),
            color: darkBrown,
            backgroundColor: Colors.white,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              itemCount: controller.savedBatikList.length,
              itemBuilder: (context, index) {
                final batik = controller.savedBatikList[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: borderColor, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: darkBrown.withValues(alpha: 0.03),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () =>
                            Get.to(() => GaleriDetailView(batik: batik)),
                        splashColor: darkBrown.withValues(alpha: 0.03),
                        highlightColor: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              // Image Thumbnail dengan Image Cache & Shimmer Tunggal
                              SizedBox(
                                width: 84,
                                height: 84,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: CachedNetworkImage(
                                    imageUrl: batik.image,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Shimmer(
                                      color: const Color(0xFFFAF7F2),
                                      colorOpacity: 0.5,
                                      duration:
                                          const Duration(milliseconds: 1500),
                                      child: Container(
                                          color: const Color(0xFFE6DFD5)),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      color: const Color(0xFFE6DFD5),
                                      child: const Icon(
                                          Icons.broken_image_rounded,
                                          color: textMuted,
                                          size: 22),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),

                              // Info Teks (Kategori & Judul)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF3EDE2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        batik.category,
                                        style: GoogleFonts.poppins(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: darkBrown,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      batik.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.lora(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: darkBrown,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      batik.deskripsi,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: textMuted,
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Tombol Hapus Interaktif (Unlike)
                              IconButton(
                                icon: const Icon(Icons.favorite_rounded,
                                    color: Color(0xFFD40606), size: 22),
                                onPressed: () =>
                                    controller.removeBatikFromSaved(batik),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }

  // ================= EXCELLENT: OPTIMIZED SKELETON SHIMMER LIST =================
  Widget _buildShimmerLoading(Color baseBorderColor) {
    // Membungkus seluruh baris tiruan ke dalam satu komponen Shimmer agar animasinya serempak dan rapi
    return Shimmer(
      color: const Color(0xFFFAF7F2),
      colorOpacity: 0.6,
      duration: const Duration(milliseconds: 1500),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(
                  0xFFF5F0E6), // Menggunakan abu krem solid tipis sebagai background skeleton dasar
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: baseBorderColor, width: 1),
            ),
            child: Row(
              children: [
                // Kotak Gambar Tiruan
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6DFD5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                const SizedBox(width: 16),
                // Blok Teks Tiruan
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: 50,
                          height: 14,
                          decoration: BoxDecoration(
                              color: const Color(0xFFE6DFD5),
                              borderRadius: BorderRadius.circular(6))),
                      const SizedBox(height: 10),
                      Container(
                          width: 120,
                          height: 16,
                          decoration: BoxDecoration(
                              color: const Color(0xFFE6DFD5),
                              borderRadius: BorderRadius.circular(6))),
                      const SizedBox(height: 8),
                      Container(
                          width: double.infinity,
                          height: 12,
                          decoration: BoxDecoration(
                              color: const Color(0xFFE6DFD5),
                              borderRadius: BorderRadius.circular(4))),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Lingkaran Tombol Like Tiruan
                Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                        color: const Color(0xFFE6DFD5),
                        shape: BoxShape.circle)),
              ],
            ),
          );
        },
      ),
    );
  }
}
