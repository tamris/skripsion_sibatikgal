import 'package:get/get.dart';

import '../controllers/pengaturan_page_controller.dart';

class PengaturanPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PengaturanPageController>(
      () => PengaturanPageController(),
    );
  }
}
