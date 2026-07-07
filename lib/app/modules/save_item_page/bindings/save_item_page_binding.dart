import 'package:get/get.dart';

import '../controllers/save_item_page_controller.dart';

class SaveItemPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SaveItemPageController>(
      () => SaveItemPageController(),
    );
  }
}
