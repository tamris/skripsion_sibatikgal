import 'package:get/get.dart';

import '../controllers/deteksi_page_controller.dart';

class DeteksiPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeteksiPageController>(
      () => DeteksiPageController(),
    );
  }
}
