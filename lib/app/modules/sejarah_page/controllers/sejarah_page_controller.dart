import 'package:batikara/app/data/models/sejarah_model.dart';
import 'package:get/get.dart';

class SejarahPageController extends GetxController {
  // List data sejarah dari hardcode
  final List<SejarahModel> sejarahList = sejarahData;
  final List<String> connectors = connectorLabels;

  // Scroll controller kalau butuh track posisi
  // (opsional, bisa dipakai kalau mau animasi dot aktif saat scroll)

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}