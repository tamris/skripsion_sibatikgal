import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/batik_model.dart';
import '../../../data/service/galeri_service.dart';

class GaleriPageController extends GetxController {
  var batikList = <BatikModel>[].obs;
  var filteredBatik = <BatikModel>[].obs;
  var isLoading = false.obs;
  
  // Ubah banners jadi RxList agar bisa diupdate dinamis
  final RxList<String> banners = <String>[].obs;
  
  final RxString searchQuery = ''.obs;
  final currentBanner = 0.obs;
  final PageController pageC = PageController(initialPage: 1);

  Timer? _autoTimer;

  @override
  void onInit() {
    super.onInit();
    fetchBatiks(); // Ambil data saat init
  }

  Future<void> fetchBatiks() async {
    isLoading.value = true;
    try {
      final response = await GaleriService.fetchAllBatiks();
      if (response.statusCode == 200) {
        List data = response.data['data'];
        batikList.assignAll(data.map((e) => BatikModel.fromJson(e)).toList());
        filteredBatik.assignAll(batikList);
        
        // SETELAH DATA ADA, BUAT BANNER ACAK
        _generateBanners();
        
        // Mulai autoplay setelah banner siap
        startAutoPlay();
      }
    } catch (e) {
      print("Error Fetch Galeri: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _generateBanners() {
    if (batikList.isEmpty) return;
    
    // Ambil copy dari list lalu acak
    List<BatikModel> shuffled = List<BatikModel>.from(batikList)..shuffle();
    
    // Ambil 4 gambar pertama hasil acak untuk dijadikan banner
    banners.value = shuffled.take(4).map((e) => e.image).toList();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredBatik.assignAll(batikList);
    } else {
      filteredBatik.assignAll(
        batikList.where((b) => b.title.toLowerCase().contains(query.toLowerCase())).toList()
      );
    }
  }

  // ========== Logic Auto-play Carousel ==========
  void startAutoPlay() {
    _autoTimer?.cancel();
    if (banners.isEmpty) return;
    _autoTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (pageC.hasClients) {
        pageC.nextPage(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void onBannerChanged(int index) => currentBanner.value = index;

  @override
  void onClose() {
    _autoTimer?.cancel();
    pageC.dispose();
    super.onClose();
  }
}