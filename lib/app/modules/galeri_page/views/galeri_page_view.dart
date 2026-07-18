import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer_animation/shimmer_animation.dart'; // Tetap menggunakan package andalanmu
import '../controllers/galeri_page_controller.dart';
import 'galeri_detail_view.dart';

class GaleriPageView extends GetView<GaleriPageController> {
  const GaleriPageView({super.key});

  @override
  Widget build(BuildContext context) {
    // Palet warna premium konsisten Batikara global
    const bgCanvas = Color(0xFFFAF7F2);
    const darkBrown = Color(0xFF1C1308);
    const textMuted = Color(0xFF7A7062);
    const accentGold = Color(0xFFFBBF24);
    const borderColor = Color(0xFFE6DFD5);

    return Scaffold(
      backgroundColor: bgCanvas,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Header Row (Diberi padding horizontal)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Galeri Motif Batik',
                    style: GoogleFonts.lora(
                      color: darkBrown,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Obx(
                    () => Text(
                      '${controller.totalBatikCount.value} koleksi motif',
                      style: GoogleFonts.poppins(
                        color: textMuted,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ================= SINKRONISASI SEARCH BAR PREMIUM =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                onChanged: (value) => controller.searchBatik(value),
                cursorColor: darkBrown,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: darkBrown,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Cari motif batik...',
                  hintStyle: GoogleFonts.poppins(
                    color: textMuted.withOpacity(0.5),
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: textMuted.withOpacity(0.7),
                    size: 20,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:
                        const BorderSide(color: borderColor, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: darkBrown, width: 1.5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Kategori Tab - Menggunakan Scrollable Horizontal
            Obx(
              () => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: controller.categories.map((category) {
                    bool isSelected =
                        controller.selectedCategory.value == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        onTap: () => controller.filterByCategory(category),
                        borderRadius: BorderRadius.circular(14),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? darkBrown : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected ? darkBrown : borderColor,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            category == 'Semua'
                                ? category
                                : category[0].toUpperCase() +
                                    category.substring(1),
                            style: GoogleFonts.poppins(
                              color: isSelected ? accentGold : textMuted,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Grid List Motif Batik + Load More Indicator + Error & Refresh Handling
            Expanded(
              child: Obx(() {
                // 1. STATE LOADING UTAMA MENGGUNAKAN FULL SKELETON SHIMMER CARD
                if (controller.isLoading.value) {
                  return _buildGridShimmerLoading(borderColor);
                }

                // 2. STATE ERROR / LOST CONNECTION
                if (controller.isError.value) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
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
                            'Tidak Dapat Memuat Data',
                            style: GoogleFonts.poppins(
                              color: darkBrown,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Data tidak dapat dimuat saat ini. Pastikan koneksi internet Anda aktif, lalu ketuk tombol Coba Lagi.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: textMuted,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: 160,
                            height: 46,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: darkBrown,
                                foregroundColor: accentGold,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () => controller.refreshData(),
                              icon: const Icon(Icons.refresh_rounded, size: 18),
                              label: Text(
                                'Coba Lagi',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w700, fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // 3. KONDISI JIKA DATA FILTER KOSONG
                if (controller.filteredBatikList.isEmpty) {
                  return RefreshIndicator(
                    color: darkBrown,
                    backgroundColor: Colors.white,
                    onRefresh: () => controller.refreshData(),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Center(
                          child: Text(
                            'Motif tidak ditemukan',
                            style: GoogleFonts.poppins(
                              color: textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                // 4. KONDISI NORMAL (DATA BERHASIL DIMUAT DENGAN CACHED IMAGE)
                return RefreshIndicator(
                  color: darkBrown,
                  backgroundColor: Colors.white,
                  onRefresh: () => controller.refreshData(),
                  child: Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                          controller: controller.scrollController,
                          itemCount: controller.filteredBatikList.length,
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, bottom: 16.0),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.72,
                          ),
                          itemBuilder: (context, index) {
                            final batik = controller.filteredBatikList[index];

                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border:
                                    Border.all(color: borderColor, width: 1),
                                boxShadow: [
                                  BoxShadow(
                                    color: darkBrown.withValues(alpha: 0.02),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => Get.to(
                                        () => GaleriDetailView(batik: batik)),
                                    splashColor:
                                        darkBrown.withValues(alpha: 0.02),
                                    highlightColor: Colors.transparent,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Image Container Menggunakan CachedNetworkImage + Shimmer Internal
                                        Expanded(
                                          flex: 3,
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.vertical(
                                                      top: Radius.circular(19)),
                                              child: CachedNetworkImage(
                                                imageUrl: batik.image,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    Shimmer(
                                                  color:
                                                      const Color(0xFFE6DFD5),
                                                  colorOpacity: 0.4,
                                                  duration: const Duration(
                                                      milliseconds: 1200),
                                                  child: Container(
                                                      color:
                                                          Colors.transparent),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Container(
                                                  color:
                                                      const Color(0xFFE6DFD5),
                                                  child: const Icon(
                                                      Icons
                                                          .broken_image_rounded,
                                                      size: 32,
                                                      color: textMuted),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Text Info Container
                                        Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  batik.title,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.lora(
                                                    color: darkBrown,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  batik.category,
                                                  style: GoogleFonts.poppins(
                                                    color: textMuted,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Indikator Loading Tambahan di bawah saat proses Infinite Scroll jalan
                      Obx(() {
                        if (controller.isLoadMore.value) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Center(
                              child:
                                  CircularProgressIndicator(color: darkBrown),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ================= INDUSTRIAL STANDARD: INDUSTRIAL SKELETON GRID SHIMMER =================
  Widget _buildGridShimmerLoading(Color baseBorderColor) {
    const shimmerBg = Color(0xFFEFECE6); // Warna dasar dasar kerangka bodi
    const maskColor =
        Color(0xFFE2DDD5); // Warna elemen dalam topeng gambar/baris teks

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 16.0),
      itemCount: 4, // Tampilkan 4 item kotak tiruan grid
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Shimmer(
            color: const Color(0xFFFAF7F2),
            colorOpacity: 0.5,
            duration: const Duration(milliseconds: 1200),
            child: Container(
              decoration: BoxDecoration(
                color: shimmerBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: baseBorderColor, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Area Gambar Atas (Flex 3)
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: maskColor,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(19)),
                      ),
                    ),
                  ),

                  // 2. Area Teks Keterangan Bawah (Flex 2)
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Topeng baris Judul
                          Container(
                            width: 100,
                            height: 14,
                            decoration: BoxDecoration(
                              color: maskColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Topeng baris Kategori
                          Container(
                            width: 60,
                            height: 12,
                            decoration: BoxDecoration(
                              color: maskColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
