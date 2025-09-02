import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuickAction {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  QuickAction({required this.icon, required this.label, this.onTap});
}

class NewsItem {
  final String title;
  final String subtitle;
  final String image; // asset / url
  NewsItem({required this.title, required this.subtitle, required this.image});
}

class HomeController extends GetxController {
  // greeting/user
  final userName = 'Rizqi Pratama'.obs;
  final greeting = 'Sugeng Enjing'.obs;

  // Search
  final searchC = TextEditingController();

  // Carousel
  final PageController pageC = PageController(viewportFraction: 0.98);

  final currentBanner = 0.obs;
  final banners = <String>[
    'assets/images/news4.png',
    'assets/images/news2.png',
    'assets/images/news3.png',
  ].obs;

  // Quick actions
  late final actions = <QuickAction>[
    QuickAction(
        icon: Icons.style,
        label: 'Galeri Batik',
        onTap: () => Get.toNamed('/gallery')),
    QuickAction(
        icon: Icons.center_focus_strong,
        label: 'Deteksi',
        onTap: () => Get.toNamed('/detect')),
    QuickAction(
        icon: Icons.map_outlined,
        label: 'Peta',
        onTap: () => Get.toNamed('/mapping')),
    QuickAction(
        icon: Icons.info_outline,
        label: 'Informasi',
        onTap: () => Get.toNamed('/news')),
  ];

  // Browser / news
  final news = <NewsItem>[
    NewsItem(
      title: '100 Pohon untuk Tegal',
      subtitle: '220 pohon terkumpul',
      image: 'assets/images/news5.png',
    ),
    NewsItem(
      title: 'Festival Batik Tegalan',
      subtitle: 'Pekan Budaya 2025',
      image: 'assets/images/news2.png',
    ),
    NewsItem(
      title: 'Workshop Membatik',
      subtitle: 'Bersama pengrajin lokal',
      image: 'assets/images/news3.png',
    ),
  ].obs;

  void onBannerChanged(int i) => currentBanner.value = i;

  @override
  void onClose() {
    pageC.dispose();
    searchC.dispose();
    super.onClose();
  }
}
