import 'package:get/get.dart';

import '../controllers/chatbot_page_controller.dart';

class ChatbotPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatbotPageController>(
      () => ChatbotPageController(),
    );
  }
}
