import 'package:batikara/app/data/models/informasi_model.dart';
import 'package:batikara/app/data/service/informasi_service.dart';
import 'package:batikara/app/data/service/user_service.dart';
// 1. IMPORT SERVICE GALERI & MODEL BATIK KAMU
import 'package:batikara/app/data/service/galeri_service.dart';
import 'package:batikara/app/data/models/batik_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class QuickAction {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  QuickAction({required this.icon, required this.label, this.onTap});
}

class HomeController extends GetxController {
  final storage = GetStorage();

  var isLoading = false.obs;
  var isError = false.obs;

  // greeting/user
  final text = 'Jelajahi & deteksi motif batik hari ini'.obs;
  var greeting = ''.obs;
  var username = ''.obs;
  var profilePictureUrl = ''.obs;

  // Search
  final searchC = TextEditingController();

  var news = <InformasiModel>[].obs;
  var isLoadingNews = false.obs;

  // ===========================================================================
  // KUNCI RANDOM CAROUSEL: Ubah Banners Menjadi Objek List BatikModel Reaktif
  // ===========================================================================
  var randomBatikList = <BatikModel>[].obs;
  var isLoadingCarousel = false.obs;
  final PageController pageC = PageController(viewportFraction: 0.98);
  final currentBanner = 0.obs;

  // Quick actions
  late final actions = <QuickAction>[
    QuickAction(
        icon: Icons.style,
        label: 'Event',
        onTap: () => Get.toNamed('/event-page')),
    QuickAction(
        icon: Icons.videocam_outlined,
        label: 'Video',
        onTap: () => Get.toNamed('/video-page')),
    QuickAction(
        icon: Icons.brush_outlined,
        label: 'Batik Art',
        onTap: () => Get.toNamed('/studio-canvas-page')),
    QuickAction(
        icon: Icons.history_edu_outlined,
        label: 'Sejarah',
        onTap: () => Get.toNamed('/sejarah-page')),
  ];

  @override
  void onInit() {
    super.onInit();
    updateGreetingAndProfile();
    fetchLatestNews();
    fetchRandomBatik(); // <-- Jalankan fungsi ambil batik random saat init
  }

  // ===========================================================================
  // LOGIKA RANDOM: Ambil Data Dari API Galeri Lalu Acak (.shuffle())
  // ===========================================================================
  void fetchRandomBatik() async {
    try {
      isLoadingCarousel(true);
      // Panggil service pagination halaman 1 tanpa query teks
      final response = await GaleriService.fetchBatikWithPagination(1, '');

      if (response.statusCode == 200) {
        List data = response.data['data'] ?? [];
        var batiks = data.map((e) => BatikModel.fromJson(e)).toList();

        // Acak urutan batik yang didapat
        batiks.shuffle();

        // Ambil maksimal 3 atau 5 batik saja untuk dipajang di Carousel banner
        randomBatikList.assignAll(batiks.take(5).toList());
      }
    } catch (e) {
      print("Gagal memuat batik untuk carousel: $e");
    } finally {
      isLoadingCarousel(false);
    }
  }

  void fetchLatestNews() async {
    isLoadingNews.value = true;
    isError.value = false;
    try {
      final response = await InformasiService.fetchAllInformasi(page: 1);
      if (response.statusCode == 200) {
        List data = response.data['data'];
        news.assignAll(
            data.map((e) => InformasiModel.fromJson(e)).take(4).toList());
        isError.value = false;
      } else {
        isError.value = true;
      }
    } catch (e) {
      print("Gagal memuat berita di Beranda: $e");
      isError.value = true;
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

  void syncUserProfileFromServer() async {
    try {
      final response = await UserService.getProfile();
      if (response.statusCode == 200 && response.data['status'] == true) {
        final userData = response.data['user'];
        storage.write('user_data', userData);
        username.value = userData['username'] ?? '';
        profilePictureUrl.value = userData['profile_picture'] ?? '';
        profilePictureUrl.refresh();
      }
    } catch (e) {
      print("Background sync profile gagal: $e");
    }
  }

  void updateGreetingAndProfile() {
    final hour = DateTime.now().hour;
    if (hour < 11) {
      greeting.value = "Sugeng Enjing";
    } else if (hour < 15) {
      greeting.value = "Sugeng Siang";
    } else if (hour < 18) {
      greeting.value = "Sugeng Sonten";
    } else {
      greeting.value = "Sugeng Dalu";
    }

    final userData = storage.read('user_data');
    if (userData != null) {
      username.value = userData['username'] ?? '';
      profilePictureUrl.value = userData['profile_picture'] ?? '';
    }
  }
}
