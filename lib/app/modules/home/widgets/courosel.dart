import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeCarousel extends GetView<HomeController> {
  const HomeCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final banners = controller.banners;
    return Column(
      children: [
        SizedBox(
          height: 190,
          child: PageView.builder(
            controller: controller.pageC,
            onPageChanged: controller.onBannerChanged,
            itemCount: banners.length,
            itemBuilder: (_, i) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 11),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7EFE9),
                      image: DecorationImage(
                        image: AssetImage(banners[i]),
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

// Widget _CarouselDots tidak perlu diubah sama sekali
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
