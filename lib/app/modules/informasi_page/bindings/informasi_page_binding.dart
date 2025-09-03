import 'package:batikara/app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';

import '../controllers/informasi_page_controller.dart';

class InformasiPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.lazyPut<InformasiPageController>(
      () => InformasiPageController(),
    );
  }
}
