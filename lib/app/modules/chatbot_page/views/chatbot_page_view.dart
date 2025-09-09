import 'package:batikara/app/modules/galeri_page/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/chatbot_page_controller.dart';

class ChatbotPageView extends GetView<ChatbotPageController> {
  const ChatbotPageView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatbotPageView'),
        centerTitle: true,
      ),
      bottomNavigationBar: const GaleriBottomNav(currentIndex: 3),
      body: const Center(
        child: Text(
          'ChatbotPageView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
