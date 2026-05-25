import 'package:batikara/app/data/models/informasi_model.dart';
import 'package:get/get.dart';
import '../../../data/service/informasi_service.dart';
import 'package:share_plus/share_plus.dart';

class InformasiPageController extends GetxController {
  var newsList = <InformasiModel>[].obs;
  var isLoading = false.obs;
  var isLoadMoreLoading = false.obs;
  var isError = false.obs; // Kita maksimalkan state ini
  var errorMessage = ''.obs;

  final RxString selectedCategory = 'Semua'.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadInformasi();
  }

  void loadInformasi() async {
    isLoading.value = true;
    isError.value = false; // Reset state error setiap kali reload
    errorMessage.value = '';

    try {
      final response = await InformasiService.fetchAllInformasi(
        search: searchQuery.value,
      );

      if (response.statusCode == 200) {
        List data = response.data['data'];
        newsList.assignAll(
          data.map((e) => InformasiModel.fromJson(e)).toList(),
        );
      } else {
        // Handle jika status code bukan 200 (misal 500 atau 404)
        isError.value = true;
        errorMessage.value =
            'Gagal memuat data dari server (${response.statusCode}).';
      }
    } catch (e) {
      // Terjadi jika ada masalah lain (misal server down/timeout)
      isError.value = true;
      errorMessage.value =
          'Tidak ada koneksi internet. Pastikan Anda terhubung ke jaringan.';
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

  List<InformasiModel> getRelatedItems(
    String currentInfoId,
    String? currentCategory,
  ) {
    // 1. Ambil artikel dengan KATEGORI YANG SAMA (selain yang sedang dibuka)
    List<InformasiModel> related = newsList
        .where(
          (item) =>
              item.id != currentInfoId && item.categori == currentCategory,
        )
        .take(3)
        .toList();

    // 2. Jika slot belum terpenuhi 3 item, kita isi sisanya dengan kategori lain
    if (related.length < 3) {
      int sisaSlot = 3 - related.length;

      // Ambil id artikel yang sudah masuk ke list 'related' agar tidak dobel
      List<String?> existingIds = related.map((e) => e.id).toList();
      existingIds.add(
        currentInfoId,
      ); // Masukkan juga ID artikel yang sedang dibuka

      // Cari artikel dari KATEGORI APA SAJA untuk memenuhi sisa slot
      List<InformasiModel> topUpItems = newsList
          .where((item) => !existingIds.contains(item.id))
          .take(sisaSlot)
          .toList();

      // Gabungkan artikel kategori sama dengan artikel top-up campuran
      related.addAll(topUpItems);
    }

    return related;
  }

  // --- FUNGSI BARU: LOGIKA SHARE ---
  void shareArtikel(InformasiModel info) {
    final String shareText =
        '''
📢 *${info.title}*
Kategori: ${info.categori ?? 'Umum'}

${info.deskripsi != null && info.deskripsi!.length > 150 ? '${info.deskripsi!.substring(0, 300)}...' : info.deskripsi}

Baca selengkapnya di Aplikasi Sistem Informasi Batik Tegalan.
''';

    Share.share(shareText, subject: info.title);
  }
}