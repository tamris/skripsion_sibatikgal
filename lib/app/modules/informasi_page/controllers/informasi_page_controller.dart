import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';

class InformasiPageController extends GetxController {
  final HomeController home = Get.find<HomeController>();

  // Kalau nanti butuh filter / search, bisa bikin di sini
  RxList get news => home.news;
}
