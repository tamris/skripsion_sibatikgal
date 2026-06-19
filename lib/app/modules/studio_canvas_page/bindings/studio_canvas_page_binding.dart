import 'package:get/get.dart';

import '../controllers/studio_canvas_page_controller.dart';

class StudioCanvasPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StudioCanvasPageController>(
      () => StudioCanvasPageController(),
    );
  }
}
