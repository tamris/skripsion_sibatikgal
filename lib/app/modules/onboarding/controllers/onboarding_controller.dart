import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingContent {
  final String title;
  final String image;
  final String desc;
  OnboardingContent(
      {required this.title, required this.image, required this.desc});
}

class OnboardingController extends GetxController {
  final pageC = PageController();
  final currentPage = 0.obs;

  final bgColors = const [
    Color(0xffF7F5F2),
    Color(0xffF7F5F2),
    Color(0xffF7F5F2),
  ];

  final contents = <OnboardingContent>[
    OnboardingContent(
      title: "Jelajahi Keindahan Batik Tegalan",
      image: "assets/images/slide1.png",
      desc:
          "Mengenal lebih dekat warisan budaya \nTegalan melalui keindahan batiknya.",
    ),
    OnboardingContent(
      title: "Scan & Kenali Motif Batik Tegalan",
      image: "assets/images/slide2.png",
      desc:
          "Cukup satu klik, motif batik langsung \nterdeteksi lengkap dengan filosofinya.",
    ),
    OnboardingContent(
      title: "Eksplorasi Motif & Lokasi Pengrajin",
      image: "assets/images/slide3.png",
      desc: "Lihat katalog motif batik & temuakn pengrajin atau toko terdekat.",
    ),
  ];

  void onChanged(int i) => currentPage.value = i;

  void next() {
    if (currentPage.value < contents.length - 1) {
      pageC.nextPage(
          duration: const Duration(milliseconds: 220), curve: Curves.easeInOut);
    } else {
      start();
    }
  }

  void skipToEnd() => pageC.jumpToPage(contents.length - 1);

  void start() {
    // TODO: tulis seen_onboarding kalau pakai GetStorage
    Get.offAllNamed('/home');
  }

  @override
  void onClose() {
    pageC.dispose();
    super.onClose();
  }
}
