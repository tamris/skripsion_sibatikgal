import 'package:batikara/app/data/models/batik_model.dart';
import 'package:batikara/app/data/service/galeri_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GaleriPageController extends GetxController {
  final ScrollController scrollController = ScrollController();

  var isLoading = true.obs;
  var isLoadMore = false.obs;
  var isError = false.obs;
  var totalBatikCount = 0.obs;

  // 1. Tambahkan dua variabel ini di dalam class GaleriPageController
  final TextEditingController searchTextController = TextEditingController();
  var isSearching =
      false.obs; // Untuk memantau status ketikan user secara reaktif

  var batikList = <BatikModel>[].obs;
  var filteredBatikList = <BatikModel>[].obs;
  var selectedCategory = 'Semua'.obs;

  int currentPage = 1;
  bool hasMoreData = true;

  // 1. VARIABEL BARU: Menyimpan kata kunci pencarian aktif secara global
  String currentSearchQuery = '';

  List<String> get categories {
    final uniqueCategories =
        batikList.map((batik) => batik.category).toSet().toList();
    uniqueCategories.sort();
    return ['Semua', ...uniqueCategories];
  }

  @override
  void onInit() {
    fetchInitialBatikData();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        fetchNextPage();
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchTextController.dispose();
    super.onClose();
  }

  // Fungsi dipanggil saat user narik layar ke bawah atau klik tombol retry
  Future<void> refreshData() async {
    currentPage = 1;
    hasMoreData = true;
    selectedCategory.value = 'Semua';
    currentSearchQuery = '';
    searchTextController
        .clear(); // <-- Tambahkan ini agar teks di inputan bersih saat refresh
    isSearching.value = false; // <-- Reset tombol silang
    await fetchInitialBatikData(isRefresh: true);
  }

  // 2. REVISI: Mengirimkan kata kunci pencarian aktif (currentSearchQuery) ke service
  Future<void> fetchInitialBatikData({bool isRefresh = false}) async {
    try {
      if (!isRefresh) isLoading(true);
      isError(false); // Reset status error sebelum menembak API

      // Sekarang mempassing currentPage DAN currentSearchQuery ke Backend Flask
      var response = await GaleriService.fetchBatikWithPagination(
          currentPage, currentSearchQuery);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data'] ?? [];
        var batiks = data.map((json) => BatikModel.fromJson(json)).toList();

        totalBatikCount.value = _extractTotalCount(
          response.data,
          batiks.length,
        );

        batiks.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
        batikList.assignAll(batiks);

        int totalPages = response.data['meta']['total_pages'] ?? 1;
        if (currentPage >= totalPages) {
          hasMoreData = false;
        }

        applyFilter();
      } else {
        isError(true);
      }
    } catch (e) {
      isError(true);
    } finally {
      isLoading(false);
    }
  }

  // 3. REVISI: Pastikan proses Load More halaman berikutnya tetap membawa kata kunci pencarian yang sama
  void fetchNextPage() async {
    if (isLoading.value || isLoadMore.value || !hasMoreData || isError.value) {
      return;
    }

    try {
      isLoadMore(true);
      currentPage++;

      // Membawa parameter search query saat menarik data halaman selanjutnya
      var response = await GaleriService.fetchBatikWithPagination(
          currentPage, currentSearchQuery);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data'] ?? [];
        var newBatiks = data.map((json) => BatikModel.fromJson(json)).toList();

        totalBatikCount.value = _extractTotalCount(
          response.data,
          batikList.length + newBatiks.length,
        );

        if (newBatiks.isNotEmpty) {
          batikList.addAll(newBatiks);
          batikList.sort(
            (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
          );

          int totalPages = response.data['meta']['total_pages'] ?? 1;
          if (currentPage >= totalPages) {
            hasMoreData = false;
          }

          applyFilter();
        } else {
          hasMoreData = false;
        }
      }
    } catch (e) {
      print("Error load more data: $e");
    } finally {
      isLoadMore(false);
    }
  }

  void filterByCategory(String category) {
    selectedCategory.value = category;
    applyFilter();
  }

  void applyFilter() {
    if (selectedCategory.value == 'Semua') {
      filteredBatikList.assignAll(batikList);
    } else {
      filteredBatikList.assignAll(
        batikList
            .where(
              (batik) =>
                  batik.category.toLowerCase() ==
                  selectedCategory.value.toLowerCase(),
            )
            .toList(),
      );
    }
  }

  Future<bool> toggleBatikLikeStatus(BatikModel batik) async {
    try {
      // 1. Tembak API ke server
      var response = await GaleriService.toggleLikeBatik(batik.id!);

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        bool serverIsLiked = response.data['is_liked'] ?? false;

        // =========================================================
        // KUNCI UTAMA: Update langsung objek batik yang bersangkutan!
        // Ini menjamin state 'isLiked' di dalam object ikut berubah secara permanen
        // =========================================================
        batik.isLiked = serverIsLiked;

        // SINKRONISASI OPSIONAL: Tetap update list utama jika itemnya ada di sana
        int index = batikList.indexWhere((element) => element.id == batik.id);
        if (index != -1) {
          batikList[index].isLiked = serverIsLiked;
          batikList.refresh();
        }

        return serverIsLiked;
      }
      return batik.isLiked;
    } catch (e) {
      print("Error toggle like: $e");
      return batik.isLiked;
    }
  }

  // 4. ROMBAK TOTAL: Mengubah pencarian lokal menjadi pencarian berbasis request ke Server Flask
  void searchBatik(String query) {
    currentSearchQuery = query; // Simpan teks pencarian ke variabel global
    currentPage =
        1; // Reset halaman kembali ke halaman pertama untuk pencarian baru
    hasMoreData = true; // Reset status pagination data baru

    // Tembak ulang API. Flask & MongoDB akan menyaring seluruh database berdasarkan teks query ini
    fetchInitialBatikData(isRefresh: true);
  }

  int _extractTotalCount(dynamic responseData, int fallbackCount) {
    if (responseData is Map<String, dynamic>) {
      final meta = responseData['meta'];
      if (meta is Map<String, dynamic>) {
        final candidate = meta['total'] ??
            meta['total_items'] ??
            meta['total_data'] ??
            meta['count'];
        if (candidate is int) return candidate;
        if (candidate is String)
          return int.tryParse(candidate) ?? fallbackCount;
      }

      final directCandidate = responseData['total'] ??
          responseData['total_items'] ??
          responseData['total_data'] ??
          responseData['count'];
      if (directCandidate is int) return directCandidate;
      if (directCandidate is String)
        return int.tryParse(directCandidate) ?? fallbackCount;
    }

    return fallbackCount;
  }
}
