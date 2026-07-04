import 'package:get/get.dart';

import '../controllers/faqs_page_controller.dart';

class FaqsPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FaqsPageController>(
      () => FaqsPageController(),
    );
  }
}
