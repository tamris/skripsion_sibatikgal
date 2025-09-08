import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';

class InformasiPageController extends GetxController {
  // Kategori terpilih
  final RxString selectedCategory = ''.obs;

  // Daftar kategori unik dari news
  List<String> get categories {
    final all = home.news.map((n) => n.categori).toSet().toList();
    all.insert(0, 'Semua');
    return all;
  }
  final HomeController home = Get.find<HomeController>();

  // Query pencarian
  final RxString searchQuery = ''.obs;

  // List hasil filter
  RxList filteredNews = <dynamic>[].obs;

  // Getter untuk news yang sudah difilter
  RxList get news {
    var list = home.news;
    // Filter kategori
    if (selectedCategory.value.isNotEmpty && selectedCategory.value != 'Semua') {
      list = list.where((n) => n.categori == selectedCategory.value).toList().obs;
    }
    // Filter search
    if (searchQuery.value.isNotEmpty) {
      list = list
          .where((n) => n.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
                        n.subtitle.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList()
          .obs;
    }
    return list;
  }

  // Fungsi untuk menangani perubahan search
  void onSearchChanged(String query) {
    searchQuery.value = query;
    update();
  }

  // Fungsi untuk mengubah kategori
  void onCategoryChanged(String? value) {
    selectedCategory.value = value ?? '';
    update();
  }
}
