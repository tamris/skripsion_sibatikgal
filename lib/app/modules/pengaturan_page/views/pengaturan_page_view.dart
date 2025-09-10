import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/pengaturan_page_controller.dart';

class PengaturanPageView extends GetView<PengaturanPageController> {
  const PengaturanPageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PengaturanPageView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PengaturanPageView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
