import 'package:batikara/app/data/models/informasi_model.dart';
import 'package:get/get.dart';
import '../../../data/service/informasi_service.dart';

class InformasiPageController extends GetxController {
  // Ganti dynamic menjadi InformasiModel agar lebih aman
  var newsList = <InformasiModel>[].obs;
  var isLoading = false.obs;

  final RxString selectedCategory = 'Semua'.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadInformasi();
  }

  void loadInformasi() async {
    isLoading.value = true;
    try {
      final response =
          await InformasiService.fetchAllInformasi(search: searchQuery.value);
      if (response.statusCode == 200) {
        List data = response.data['data'];
        newsList
            .assignAll(data.map((e) => InformasiModel.fromJson(e)).toList());
      }
    } finally {
      isLoading.value = false;
    }
  }

  // PERBAIKAN DI SINI: Gunakan n.categori, bukan n['kategori']
  List<InformasiModel> get filteredNews {
    if (selectedCategory.value == 'Semua') return newsList;
    return newsList.where((n) => n.categori == selectedCategory.value).toList();
  }

  // PERBAIKAN DI SINI: Gunakan n.categori, bukan n['kategori']
  List<String> get categories {
    final all = newsList.map((n) => n.categori.toString()).toSet().toList();
    all.insert(0, 'Semua');
    return all;
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    loadInformasi();
  }

  void onCategoryChanged(String? value) {
    selectedCategory.value = value ?? 'Semua';
  }
}
  