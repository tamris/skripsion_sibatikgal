import 'package:batikara/app/modules/home/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/galeri_page_controller.dart';

class GaleriPageView extends GetView<GaleriPageController> {
  const GaleriPageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const HomeBottomNav(
        currentIndex: 1,
      ),
      appBar: AppBar(
        title: const Text('GaleriPageView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'GaleriPageView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
