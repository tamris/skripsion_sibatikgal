import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeCarousel extends GetView<HomeController> {
  const HomeCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final banners = controller.banners;

    // Konstanta warna premium konsisten Batikara
    const itemBgIcon = Color(0xFFF3EDE2); // Latar hangat saat gambar loading
    

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
                  borderRadius: BorderRadius.circular(
                      16), // Kembali ke radius 16 asli yang presisi
                  child: Container(
                    decoration: BoxDecoration(
                      color:
                          itemBgIcon, // Mengganti warna terracotta lama yang kaku
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
        const SizedBox(
            height: 20), // Mempertahankan jarak 20 bawaan kode asli Anda
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

class _CarouselDots extends StatelessWidget {
  final int length;
  final int index;
  const _CarouselDots({required this.length, required this.index});

  @override
  Widget build(BuildContext context) {
    // Penyelarasan warna dots agar masuk ke dalam tema global aplikasi Anda
    const darkBrown = Color(0xFF1C1308); // Dots aktif cokelat pekat
    const textMuted = Color(0xFF7A7062); // Dots pasif abu-abu pudar

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height:
              6, // Mempertahankan tinggi 6 asli agar bentuk kapsul tidak kekecilan
          width:
              active ? 18 : 6, // Mempertahankan dimensi panjang asli 18 dan 6
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            // Menghapus warna terracotta lama yang kemerahan, diganti transisi opasitas global
            color: active
                ? darkBrown.withOpacity(0.9)
                : textMuted.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }),
    );
  }
}
