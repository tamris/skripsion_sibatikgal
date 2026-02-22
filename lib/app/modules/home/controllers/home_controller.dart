import 'package:batikara/app/data/service/informasi_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/informasi_model.dart';

class QuickAction {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  QuickAction({required this.icon, required this.label, this.onTap});
}

class HomeController extends GetxController {
  // greeting/user
  final userName = 'Rizqi Pratama'.obs;
  var greeting = ''.obs;

  // Search
  final searchC = TextEditingController();

  var news = <InformasiModel>[].obs;
  var isLoadingNews = false.obs;

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
        label: 'Event',
        onTap: () => Get.toNamed('/galeri-page')),
    QuickAction(
        icon: Icons.center_focus_strong,
        label: 'Video',
        onTap: () => Get.toNamed('/detect')),
    QuickAction(
        icon: Icons.map_outlined,
        label: 'Peta',
        onTap: () => Get.toNamed('/mapping')),
    QuickAction(
        icon: Icons.info_outline,
        label: 'Sejarah',
        onTap: () => Get.toNamed('/news')),
  ];

  // informasi / news
  void fetchLatestNews() async {
    isLoadingNews.value = true;
    try {
      final response = await InformasiService.fetchAllInformasi(page: 1);
      if (response.statusCode == 200) {
        List data = response.data['data'];
        // Ambil 3-4 berita saja untuk di Beranda
        news.assignAll(
            data.map((e) => InformasiModel.fromJson(e)).take(4).toList());
      }
    } catch (e) {
      print("Gagal memuat berita di Beranda: $e");
    } finally {
      isLoadingNews.value = false;
    }
  }

  void onBannerChanged(int i) => currentBanner.value = i;

  @override
  void onClose() {
    pageC.dispose();
    searchC.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    loadGreeting();
    fetchLatestNews();
  }

  void loadGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) {
      greeting.value = "Sugeng Enjing!";
    } else if (hour < 15) {
      greeting.value = "Sugeng Siang!";
    } else if (hour < 18) {
      greeting.value = "Sugeng Sonten!";
    } else {
      greeting.value = "Sugeng Dalu!";
    }
  }
}
