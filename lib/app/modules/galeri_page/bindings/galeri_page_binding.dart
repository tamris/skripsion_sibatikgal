import 'package:get/get.dart';

import '../controllers/galeri_page_controller.dart';

class GaleriPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GaleriPageController>(
      () => GaleriPageController(),
    );
  }
}
