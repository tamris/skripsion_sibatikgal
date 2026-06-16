import 'package:get/get.dart';

import '../controllers/mapping_page_controller.dart';

class MappingPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MappingPageController>(
      () => MappingPageController(),
    );
  }
}
