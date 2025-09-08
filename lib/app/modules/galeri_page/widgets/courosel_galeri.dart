import 'package:batikara/app/modules/galeri_page/controllers/galeri_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GalleryCarousel extends GetView<GaleriPageController> {
  const GalleryCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final banners = controller.banners;

    // kalau kosong, kembalikan container kosong
    if (banners.isEmpty) {
      return const SizedBox.shrink();
    }

    // total virtual: head(1) + real(n) + tail(1)
    final totalVirtual = banners.length + 2; // CHANGED

    String assetForVirtualIndex(int i) {
      // NEW
      if (i == 0) return banners.last; // tail clone
      if (i == banners.length + 1) return banners.first; // head clone
      return banners[i - 1]; // real item
    }

    return Column(
      children: [
        SizedBox(
          height: 190,
          child: PageView.builder(
            controller: controller.pageC,
            // WRAP LOGIC: geser ke halaman “real” saat nabrak clone
            onPageChanged: (vi) {
              // CHANGED
              if (vi == 0) {
                // dari tail clone snap ke real terakhir
                controller.jumpSilently(banners.length);
              } else if (vi == banners.length + 1) {
                // dari head clone snap ke real pertama
                controller.jumpSilently(1);
              } else {
                // update indikator (real index = vi - 1)
                controller.onBannerChanged(vi - 1);
              }
            },
            itemCount: totalVirtual, // CHANGED
            itemBuilder: (_, i) {
              final img = assetForVirtualIndex(i); // NEW
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 11),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7EFE9),
                      image: DecorationImage(
                        image: AssetImage(img), // CHANGED
                        fit: BoxFit.cover,
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
          child: Obx(() => _CarouselDots(
                length: banners.length,
                index: controller.currentBanner.value,
              )),
        )
      ],
    );
  }
}

// Widget _CarouselDots tetap sama
class _CarouselDots extends StatelessWidget {
  final int length;
  final int index;
  const _CarouselDots({required this.length, required this.index});

  @override
  Widget build(BuildContext context) {
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
            color: const Color.fromARGB(255, 138, 90, 68)
                .withOpacity(active ? 0.9 : 0.4),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }
}
