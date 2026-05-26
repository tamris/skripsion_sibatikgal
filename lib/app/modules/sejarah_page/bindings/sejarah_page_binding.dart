import 'package:get/get.dart';

import '../controllers/sejarah_page_controller.dart';

class SejarahPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SejarahPageController>(
      () => SejarahPageController(),
    );
  }
}
