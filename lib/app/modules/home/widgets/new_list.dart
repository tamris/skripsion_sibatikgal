import 'package:batikara/app/modules/informasi_page/controllers/informasi_page_controller.dart';
import 'package:batikara/app/modules/informasi_page/views/informasi_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import '../controllers/home_controller.dart';

class HomeNewsList extends GetView<HomeController> {
  const HomeNewsList({super.key});

  @override
  Widget build(BuildContext context) {
    const darkBrown = Color(0xFF1C1308);
    const textMuted = Color(0xFF7A7062);
    const accentGold = Color(0xFFFBBF24);
    const borderColor = Color(0xFFE6DFD5);

    return Obx(() {
      // 1. KONDISI LOADING AWAL (SHIMMER UTAH KAPSUL)
      if (controller.isLoading.value) {
        return _buildShimmerLoading(borderColor);
      }

      // 2. KONDISI LOST CONNECTION (ERROR STATE PREMIUM)
      if (controller.isError.value) {
        return SliverToBoxAdapter(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
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
                // --- KALIMAT GLOBAL: COCOK UNTUK SEMUA HALAMAN/FITUR ---
                Text(
                  'Data tidak dapat dimuat saat ini. Pastikan koneksi internet Anda aktif, lalu ketuk tombol Coba Lagi.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: textMuted,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 150,
                  height: 44,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkBrown,
                      foregroundColor: accentGold,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () => controller
                        .fetchLatestNews(), // Sesuaikan fungsi panggil tiap page
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: Text(
                      'Coba Lagi',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // 3. KONDISI NORMAL BERHASIL
      return SliverList.separated(
        itemCount: controller.news.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, i) {
          final n = controller.news[i];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () {
                Get.to(
                  () => InformasiDetailPage(),
                  binding: BindingsBuilder(() {
                    Get.lazyPut(() => InformasiPageController());
                  }),
                  arguments: n,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: darkBrown.withOpacity(0.03),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: n.imageUrl ?? '',
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer(
                            color: const Color(0xFFFAF7F2),
                            colorOpacity: 0.5,
                            duration: const Duration(milliseconds: 1500),
                            child: Container(color: const Color(0xFFE6DFD5)),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: const Color(0xFFE6DFD5),
                            child: const Icon(
                              Icons.broken_image_rounded,
                              color: textMuted,
                              size: 32,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.05),
                                Colors.black.withOpacity(0.75),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 20,
                          right: 20,
                          bottom: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                n.title ?? 'Tanpa Judul',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                n.deskripsi ?? 'Deskripsi tidak tersedia',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  color: Colors.white.withOpacity(0.75),
                                  fontSize: 12,
                                  height: 1.4,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildShimmerLoading(Color baseBorderColor) {
    return Shimmer(
      color: const Color(0xFFFAF7F2),
      colorOpacity: 0.6,
      duration: const Duration(milliseconds: 1500),
      child: SliverList.separated(
        itemCount: 2,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F0E6),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: baseBorderColor, width: 1),
              ),
            ),
          );
        },
      ),
    );
  }
}
