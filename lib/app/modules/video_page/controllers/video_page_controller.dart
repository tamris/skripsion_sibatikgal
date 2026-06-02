import 'package:flutter/material.dart';
import 'package:batikara/app/data/service/video_service.dart';
import 'package:get/get.dart';
import '../../../data/models/video_model.dart';

class VideoPageController extends GetxController {
  final RxList<VideoModel> allVideos = <VideoModel>[].obs;
  final RxList<VideoModel> filteredVideos = <VideoModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxString selectedKategori = 'Semua'.obs;
  final RxString searchQuery = ''.obs;

  final TextEditingController searchController = TextEditingController();

  final RxList<String> kategoriList = <String>['Semua'].obs;

  @override
  void onInit() {
    super.onInit();
    fetchVideos();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // ── Fetch pakai VideoService yang udah ada ────────────────────────────────
  Future<void> fetchVideos() async {
    isLoading.value = true;
    try {
      final response = await VideoService.fetchAllVideos(
        search: searchQuery.value,
      );

      if (response.statusCode == 200) {
        final List data = response.data['data'] ?? [];
        allVideos.value = data.map((e) => VideoModel.fromJson(e)).toList();

        // Extract kategori unik dari DB, selalu awali 'Semua'
        final uniqueKategori =
            allVideos
                .map((v) => v.kategori ?? '')
                .where((k) => k.isNotEmpty)
                .toSet()
                .toList()
              ..sort();
        kategoriList.value = ['Semua', ...uniqueKategori];

        _applyFilter();
      } else {
        Get.snackbar(
          'Error',
          'Gagal memuat video',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Tidak dapat terhubung ke server',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ── Filter kategori — dilakukan di client, search sudah di-handle API ─────
  void _applyFilter() {
    List<VideoModel> result = List.from(allVideos);

    if (selectedKategori.value != 'Semua') {
      result = result
          .where((v) => v.kategori == selectedKategori.value)
          .toList();
    }

    filteredVideos.value = result;
  }

  void setKategori(String kategori) {
    selectedKategori.value = kategori;
    _applyFilter();
  }

  // Search — kirim ke API langsung biar hasil lebih akurat
  void onSearch(String query) {
    searchQuery.value = query;
    fetchVideos(); // re-fetch dengan query baru
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    fetchVideos();
  }
}