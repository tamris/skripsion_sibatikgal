import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/deteksi_page_controller.dart';

class DeteksiPageView extends GetView<DeteksiPageController> {
  const DeteksiPageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DeteksiPageView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DeteksiPageView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
