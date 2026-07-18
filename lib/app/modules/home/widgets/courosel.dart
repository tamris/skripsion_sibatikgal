import 'package:batikara/app/modules/galeri_page/views/galeri_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer_animation/shimmer_animation.dart'; // Impor paket shimmer andalanmu
import '../controllers/home_controller.dart';

class HomeCarousel extends GetView<HomeController> {
  const HomeCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    const itemBgIcon = Color(0xFFF3EDE2);
    const borderColor = Color(0xFFE6DFD5);

    return Obx(() {
      // 1. STATE LOADING UTAMA CAROUSEL: Menggunakan Skeleton Shimmer Standar Industri
      if (controller.isLoadingCarousel.value) {
        return _buildCarouselShimmer(borderColor);
      }

      // Jika kosong atau server error, tampilkan container kosong agar tidak crash
      if (controller.randomBatikList.isEmpty) {
        return const SizedBox.shrink();
      }

      final batiks = controller.randomBatikList;

      return Column(
        children: [
          SizedBox(
            height: 190,
            child: PageView.builder(
              controller: controller.pageC,
              onPageChanged: controller.onBannerChanged,
              itemCount: batiks.length,
              itemBuilder: (_, i) {
                final batik = batiks[i];

                // TAMBAHKAN PRINT INI UNTUK CEK DI TERMINAL
                // print(
                //     "URL GAMBAR CAROUSEL: ${AppConfig.baseUrl}/static/img/galeri/${batik.image}");
                // print("ISI ASLI FIELD IMAGE: ${batik.image}");

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 11),
                  child: GestureDetector(
                    onTap: () => Get.to(() => GaleriDetailView(batik: batik)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        decoration: BoxDecoration(
                          color: itemBgIcon,
                        ),
                        child: CachedNetworkImage(
                          imageUrl: batik.image,
                          fit: BoxFit.cover,
                          // Efek shimmer internal transparan lembut saat memuat gambar individu
                          placeholder: (context, url) => Shimmer(
                            color: const Color(0xFFE6DFD5),
                            colorOpacity: 0.4,
                            duration: const Duration(milliseconds: 1200),
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: itemBgIcon,
                            child:
                                const Icon(Icons.image_not_supported, size: 40),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: _CarouselDots(
              length: batiks.length,
              index: controller.currentBanner.value,
            ),
          )
        ],
      );
    });
  }

  // ================= INDUSTRIAL STANDARD: BANNER CAROUSEL SKELETON SHIMMER =================
  Widget _buildCarouselShimmer(Color baseBorderColor) {
    const shimmerBg = Color(0xFFEFECE6);
    const maskColor = Color(0xFFE2DDD5);

    return Shimmer(
      color: const Color(0xFFFAF7F2),
      colorOpacity: 0.5,
      duration: const Duration(milliseconds: 1200),
      child: Column(
        children: [
          // Replikasi proporsi dan layout utama PageView Carousel Box
          SizedBox(
            height: 190,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 11),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: shimmerBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: baseBorderColor, width: 1),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Replikasi deretan dummy indicator dots di bawah box carousel
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) {
                return Container(
                  height: 6,
                  width: i == 0 ? 18 : 6, // Meniru dots aktif di bagian depan
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: maskColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}

class _CarouselDots extends StatelessWidget {
  final int length;
  final int index;
  const _CarouselDots({required this.length, required this.index});

  @override
  Widget build(BuildContext context) {
    const darkBrown = Color(0xFF1C1308);
    const textMuted = Color(0xFF7A7062);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 6,
          width: active ? 18 : 6,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: active
                ? darkBrown.withValues(alpha: 0.9)
                : textMuted.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }
}
