import 'package:get/get.dart';

import '../controllers/tentang_aplikasi_page_controller.dart';

class TentangAplikasiPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TentangAplikasiPageController>(
      () => TentangAplikasiPageController(),
    );
  }
}
