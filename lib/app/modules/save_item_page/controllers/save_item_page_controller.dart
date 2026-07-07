import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:batikara/app/data/models/batik_model.dart';
import 'package:batikara/app/data/service/galeri_service.dart'; // Sesuaikan path service kamu

class SaveItemPageController extends GetxController {
  var isLoading = true.obs;
  var isError = false.obs;
  var savedBatikList = <BatikModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSavedItems();
  }

  // Ambil daftar batik yang di-save dari backend Flask
  Future<void> fetchSavedItems({bool isRefresh = false}) async {
    try {
      if (!isRefresh) isLoading(true);
      isError(false);

      // Panggil API GET /api/user/saved
      var response = await GaleriService.getSavedItems(); // Pastikan method ini terdaftar di GaleriService

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        List<dynamic> data = response.data['data'] ?? [];
        var batiks = data.map((json) => BatikModel.fromJson(json)).toList();
        
        savedBatikList.assignAll(batiks);
      } else {
        isError(true);
      }
    } catch (e) {
      isError(true);
      print("Error memuat item tersimpan: $e");
    } finally {
      isLoading(false);
    }
  }

  // Fungsi interaktif: Bisa unlike/remove langsung dari list ini
  Future<void> removeBatikFromSaved(BatikModel batik) async {
    try {
      // Hapus instan di lokal UI dulu (Instant Feedback)
      savedBatikList.removeWhere((element) => element.id == batik.id);

      // Tembak API POST /api/galeri/<id>/like untuk mentoggle status di MongoDB
      await GaleriService.toggleLikeBatik(batik.id!);
    } catch (e) {
      // Jika gagal, restore kembali data lokalnya
      fetchSavedItems(isRefresh: true);
      Get.snackbar(
        'Gagal', 
        'Gagal menghapus item, periksa koneksi internet.',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }
}