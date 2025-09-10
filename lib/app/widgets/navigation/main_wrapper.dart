import 'package:batikara/app/modules/chatbot_page/views/chatbot_page_view.dart';
import 'package:batikara/app/modules/deteksi_page/controllers/deteksi_page_controller.dart';
import 'package:batikara/app/modules/deteksi_page/views/deteksi_page_view.dart';
import 'package:batikara/app/modules/galeri_page/views/galeri_page_view.dart';
import 'package:batikara/app/modules/home/views/home_view.dart';
import 'package:batikara/app/modules/pengaturan_page/controllers/pengaturan_page_controller.dart';
import 'package:batikara/app/modules/pengaturan_page/views/pengaturan_page_view.dart';
import 'package:batikara/app/widgets/navigation/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../modules/chatbot_page/controllers/chatbot_page_controller.dart';
import '../../modules/galeri_page/controllers/galeri_page_controller.dart';
import 'bottom_nav_controller.dart';

class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final BottomNavController controller = Get.put(BottomNavController());

    return Scaffold(
      body: Obx(() {
        switch (controller.currentIndex.value) {
          case 0:
            return const HomeView();
          case 1:
            Get.put(GaleriPageController());
            return const GaleriPageView();
          case 2:
            Get.put(DeteksiPageController());
            return const DeteksiPageView();
          case 3:
            Get.put(ChatbotPageController());
            return const ChatbotPageView();
          case 4:
            Get.put(PengaturanPageController());
            return const PengaturanPageView();
          default:
            return const HomeView();
        }
      }),
      bottomNavigationBar: Obx(() => BottomNav(
            currentIndex: controller.currentIndex.value,
            onTap: (index) => controller.changePage(index),
          )),
    );
  }
}
