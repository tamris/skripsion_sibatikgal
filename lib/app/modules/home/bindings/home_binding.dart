import 'package:batikara/app/modules/informasi_page/controllers/informasi_page_controller.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<InformasiPageController>(
      () => InformasiPageController(),
    );
  }
}
