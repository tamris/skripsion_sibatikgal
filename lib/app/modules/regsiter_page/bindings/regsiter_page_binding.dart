import 'package:get/get.dart';

import '../controllers/regsiter_page_controller.dart';

class RegsiterPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegsiterPageController>(
      () => RegsiterPageController(),
    );
  }
}
