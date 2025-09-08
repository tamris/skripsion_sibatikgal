import 'dart:async';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GaleriPageController extends GetxController {
  // Query pencarian
  final RxString searchQuery = ''.obs;
  final count = 0.obs;
  final currentBanner = 0.obs;

  void onSearchChanged(String query) {
    searchQuery.value = query;
    update();
  }

  final List<String> banners = [
    'assets/images/Sekar Jagad.jpg',
    'assets/images/Kembang Pacar.jpg',
    'assets/images/Poci Tahu Aci.jpg',
    'assets/images/Sidomulyo.jpg',
  ];

  // CHANGED: mulai dari halaman 1 (karena 0 dipakai "tail clone")
  final PageController pageC = PageController(initialPage: 1); // CHANGED

  // dipanggil saat page berubah (index real = virtualIndex - 1)
  void onBannerChanged(int index) {
    currentBanner.value = index;
  }

  // ========== Auto-play ==========
  final Duration autoPlayInterval = const Duration(seconds: 3);
  final Duration slideDuration = const Duration(milliseconds: 630);
  final Curve slideCurve = Curves.easeInOut;

  Timer? _autoTimer;

  void startAutoPlay() {
    _autoTimer?.cancel();
    if (banners.isEmpty) return;

    _autoTimer = Timer.periodic(autoPlayInterval, (_) {
      pageC.nextPage(duration: slideDuration, curve: slideCurve);
    });
  }

  void stopAutoPlay() {
    _autoTimer?.cancel();
    _autoTimer = null;
  }

  void jumpSilently(int page) {
    // NEW
    pageC.jumpToPage(page);
  }

  @override
  void onInit() {
    super.onInit();
    startAutoPlay();
  }

  @override
  void onClose() {
    stopAutoPlay();
    pageC.dispose();
    super.onClose();
  }
}
