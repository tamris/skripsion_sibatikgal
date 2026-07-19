import 'package:batikara/app/data/service/global_serach_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/batik_model.dart';
import '../../../data/models/informasi_model.dart';
import '../../../data/models/video_model.dart';
import '../../../data/models/event_model.dart';

class GlobalSearchController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  final TextEditingController searchC = TextEditingController();

  var isLoading = false.obs;
  var isError = false.obs;
  var queryText = ''.obs;

  // 1. Kunci Utama: Pastikan tipe data List menggunakan model asli buatanmu
  var batikResults = <BatikModel>[].obs;
  var artikelResults = <InformasiModel>[].obs;
  var videoResults = <VideoModel>[].obs;
  var eventResults = <EventModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 4, vsync: this);

    if (Get.arguments != null && Get.arguments is String) {
      String initialQuery = Get.arguments;
      searchC.text = initialQuery;
      queryText.value = initialQuery;
      fetchGlobalSearch(initialQuery);
    }
  }

  void fetchGlobalSearch(String query) async {
    final normalizedQuery = query.trim();
    if (normalizedQuery.isEmpty) return;

    queryText.value = normalizedQuery;
    isLoading(true);
    isError(false);

    try {
      print("============ START GLOBAL SEARCH DEBUG ============");
      print("Mencari keyword: $normalizedQuery");

      final response = await SearchService.globalSearch(normalizedQuery);
      print("HTTP Status Code dari Flask: ${response.statusCode}");
      print("Isi Full Response JSON: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        final resBody = response.data;

        if (resBody['status'] == 'success' && resBody['data'] != null) {
          final data = resBody['data'];

          // 1. DEBUG PARSING BATIK
          try {
            if (data['batik'] != null && data['batik'] is List) {
              print(
                  "Jumlah data batik mentah: ${(data['batik'] as List).length}");
              batikResults.assignAll((data['batik'] as List)
                  .map((e) => BatikModel.fromJson(e))
                  .toList());
              print(
                  "✅ PARSING BATIK SUCCESS! Jumlah setelah di-parse: ${batikResults.length}");
            } else {
              batikResults.clear();
            }
          } catch (eBatik) {
            print("❌ ERROR PARSING BATIK: $eBatik");
          }

          // 2. DEBUG PARSING ARTIKEL (INFORMASI)
          try {
            if (data['artikel'] != null && data['artikel'] is List) {
              print(
                  "Jumlah data artikel mentah: ${(data['artikel'] as List).length}");
              artikelResults.assignAll((data['artikel'] as List)
                  .map((e) => InformasiModel.fromJson(e))
                  .toList());
              print(
                  "✅ PARSING ARTIKEL SUCCESS! Jumlah setelah di-parse: ${artikelResults.length}");
            } else {
              artikelResults.clear();
            }
          } catch (eArtikel) {
            print("❌ ERROR PARSING ARTIKEL: $eArtikel");
          }

          // 3. DEBUG PARSING VIDEO
          try {
            if (data['video'] != null && data['video'] is List) {
              print(
                  "Jumlah data video mentah: ${(data['video'] as List).length}");
              videoResults.assignAll((data['video'] as List)
                  .map((e) => VideoModel.fromJson(e))
                  .toList());
              print(
                  "✅ PARSING VIDEO SUCCESS! Jumlah setelah di-parse: ${videoResults.length}");
            } else {
              videoResults.clear();
            }
          } catch (eVideo) {
            print("❌ ERROR PARSING VIDEO: $eVideo");
          }

          // 4. DEBUG PARSING EVENT
          try {
            if (data['event'] != null && data['event'] is List) {
              print(
                  "Jumlah data event mentah: ${(data['event'] as List).length}");
              eventResults.assignAll((data['event'] as List)
                  .map((e) => EventModel.fromJson(e))
                  .toList());
              print(
                  "✅ PARSING EVENT SUCCESS! Jumlah setelah di-parse: ${eventResults.length}");
            } else {
              eventResults.clear();
            }
          } catch (eEvent) {
            print("❌ ERROR PARSING EVENT: $eEvent");
          }

          // Kunci Utama: Jangan langsung set isError(true) global jika salah satu tab gagal.
          // Cukup biarkan tab yang gagal menampilkan list kosong atau error lokal.
          isError(false);
        } else {
          print("Format status JSON bukan success atau data null");
          isError(true);
        }
      } else {
        isError(true);
      }
    } catch (e) {
      print("❌ CRASH TOTAL PADA GLOBAL SEARCH METHOD: $e");
      isError(true);
    } finally {
      print("============ END GLOBAL SEARCH DEBUG ============");
      isLoading(false);
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    searchC.dispose();
    super.onClose();
  }
}
