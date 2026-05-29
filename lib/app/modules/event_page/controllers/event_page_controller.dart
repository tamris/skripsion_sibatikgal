import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../data/models/event_model.dart';
import '../../../data/service/event_service.dart';

class EventPageController extends GetxController {
  var eventList = <EventModel>[].obs;
  var isLoading = false.obs;
  final RxString selectedCategory = 'Semua'.obs;
  final RxString searchQuery = ''.obs;

  var categories = <String>['Semua'].obs;

  // Warna static untuk kebutuhan snackbar kustommu
  static const Color cDark = Color(0xFF1A1208);
  static const Color cGold = Color(0xFFFFD264);

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  void fetchEvents() async {
    isLoading.value = true;
    try {
      final response =
          await EventService.fetchAllEvents(search: searchQuery.value);
      if (response.statusCode == 200) {
        List data = response.data['data'];
        final fetchedEvents = data.map((e) => EventModel.fromJson(e)).toList();
        eventList.assignAll(fetchedEvents);
        _updateCategories(fetchedEvents);
      }
    } catch (e) {
      print("Error Parsing atau Koneksi: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _updateCategories(List<EventModel> events) {
    final allCats = events
        .map((e) => e.kategori)
        .whereType<String>()
        .map((kategori) => kategori.trim())
        .where((kategori) => kategori.isNotEmpty)
        .toSet()
        .toList();
    allCats.insert(0, 'Semua');
    categories.assignAll(allCats);
    if (!categories.contains(selectedCategory.value)) {
      selectedCategory.value = 'Semua';
    }
  }

  List<EventModel> get filteredEvents {
    List<EventModel> listData;
    if (selectedCategory.value == 'Semua') {
      listData = List<EventModel>.from(eventList);
    } else {
      listData =
          eventList.where((e) => e.kategori == selectedCategory.value).toList();
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    listData.sort((a, b) {
      final dateA = DateTime.tryParse(a.eventDate ?? '') ?? DateTime(2999);
      final dateB = DateTime.tryParse(b.eventDate ?? '') ?? DateTime(2999);
      bool isPastA = dateA.isBefore(today);
      bool isPastB = dateB.isBefore(today);
      if (isPastA != isPastB) return isPastA ? 1 : -1;
      return dateA.compareTo(dateB);
    });

    return listData;
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    selectedCategory.value = 'Semua';
    fetchEvents();
  }

  void onCategoryChanged(String cat) {
    selectedCategory.value = cat;
  }

  // ── Pindahan Logika Buka Google Maps Bawaan Kamu ─────────────────
  Future<void> openMap(String lat, String lng) async {
    final url = "https://www.google.com/maps/search/?api=1&query=$lat,$lng";
    try {
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url, mode: LaunchMode.externalApplication);
      } else {
        await launchUrlString(url, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      Get.snackbar("Error", "Tidak dapat membuka peta: $e",
          backgroundColor: cDark, colorText: cGold);
    }
  }

  // ── Pindahan Logika Buka Link Pendaftaran Bawaan Kamu ───────────
  Future<void> openRegistration(String url) async {
    try {
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url, mode: LaunchMode.externalApplication);
      } else {
        await launchUrlString(url, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      Get.snackbar("Error", "Tidak dapat membuka link pendaftaran: $e",
          backgroundColor: cDark, colorText: cGold);
    }
  }
}
