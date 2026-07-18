import 'package:batikara/app/data/service/informasi_service.dart';
import 'package:batikara/app/data/service/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'; // <--- Tambahkan import GetStorage

import '../../../data/models/informasi_model.dart';

class QuickAction {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  QuickAction({required this.icon, required this.label, this.onTap});
}

class HomeController extends GetxController {
  // Instance GetStorage
  final storage = GetStorage();

  var isLoading = false.obs;
  var isError = false.obs;

  // greeting/user
  final text = 'Jelajahi & deteksi motif batik hari ini'.obs;
  var greeting = ''.obs;
  var username = ''.obs; // <--- Tambah Rx variable untuk menampung Nama
  var profilePictureUrl =
      ''.obs; // <--- Tambah Rx variable untuk URL Foto Profil

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

  // informasi / news
  // informasi / news
  void fetchLatestNews() async {
    isLoadingNews.value = true;
    isError.value =
        false; // <--- 1. Reset status error ke false setiap kali mulai ambil data
    try {
      final response = await InformasiService.fetchAllInformasi(page: 1);
      if (response.statusCode == 200) {
        List data = response.data['data'];
        // Ambil 3-4 berita saja untuk di Beranda
        news.assignAll(
            data.map((e) => InformasiModel.fromJson(e)).take(4).toList());
        isError.value = false; // <--- Pastikan tetap false kalau sukses
      } else {
        isError.value = true; // <--- Jaga-jaga kalau response server bukan 200
      }
    } catch (e) {
      print("Gagal memuat berita di Beranda: $e");
      isError.value =
          true; // <--- 2. INI YANG PENTING! Set true agar UI mendeteksi error dan memunculkan message
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
    updateGreetingAndProfile(); // <--- Ganti loadGreeting() lama dengan fungsi gabungan baru
    fetchLatestNews();
  }

  void syncUserProfileFromServer() async {
    try {
      final response = await UserService.getProfile();
      if (response.statusCode == 200 && response.data['status'] == true) {
        final userData = response.data['user'];

        // Tulis ulang ke GetStorage agar tersimpan permanen
        storage.write('user_data', userData);

        // Perbarui variable reaktif secara realtime di halaman Beranda
        username.value = userData['username'] ?? '';
        profilePictureUrl.value = userData['profile_picture'] ?? '';

        // Paksa refresh UI reaktif
        profilePictureUrl.refresh();
      }
    } catch (e) {
      print("Background sync profile gagal: $e");
    }
  }

  // =========================================================
  // FIX LOGIC: UPDATE GREETING & AMBIL DATA PROFILE DARI LOCAL
  // =========================================================
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
