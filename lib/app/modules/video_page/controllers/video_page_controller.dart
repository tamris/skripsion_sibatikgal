import 'package:flutter/material.dart';
import 'package:batikara/app/data/service/video_service.dart';
import 'package:get/get.dart';
import '../../../data/models/video_model.dart';

class VideoPageController extends GetxController {
  final RxList<VideoModel> allVideos = <VideoModel>[].obs;
  final RxList<VideoModel> filteredVideos = <VideoModel>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isError = false.obs; // Tambah state error terkontrol global
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

  Future<void> fetchVideos() async {
    isLoading.value = true;
    isError.value = false; // Reset state error setiap kali mulai fetch data
    try {
      final response = await VideoService.fetchAllVideos(
        search: searchQuery.value,
      );

      if (response.statusCode == 200) {
        final List data = response.data['data'] ?? [];
        allVideos.value = data.map((e) => VideoModel.fromJson(e)).toList();

        final uniqueKategori = allVideos
            .map((v) => v.kategori ?? '')
            .where((k) => k.isNotEmpty)
            .toSet()
            .toList()
          ..sort();
        kategoriList.value = ['Semua', ...uniqueKategori];

        _applyFilter();
        isError.value = false;
      } else {
        isError.value = true;
      }
    } catch (e) {
      print("Gagal memuat video di Beranda: $e");
      isError.value = true; // Set true agar memicu render layout pesan error di UI
    } finally {
      isLoading.value = false;
    }
  }

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

  void onSearch(String query) {
    searchQuery.value = query;
    fetchVideos();
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    fetchVideos();
  }
}