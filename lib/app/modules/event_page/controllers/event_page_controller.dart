import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../data/models/event_model.dart';
import '../../../data/service/event_service.dart';
import 'package:share_plus/share_plus.dart';

class EventPageController extends GetxController {
  var eventList = <EventModel>[].obs;
  var isLoading = false.obs;
  var isError = false.obs;

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
    isError.value =
        false; // 1. Reset state error ke false setiap kali mulai menarik data
    try {
      final response =
          await EventService.fetchAllEvents(search: searchQuery.value);
      if (response.statusCode == 200) {
        List data = response.data['data'];
        final fetchedEvents = data.map((e) => EventModel.fromJson(e)).toList();
        eventList.assignAll(fetchedEvents);
        _updateCategories(fetchedEvents);
        isError.value = false; // Memastikan tetap false jika response aman
      } else {
        isError.value = true; // Jaga-jaga jika response server bukan 200
      }
    } catch (e) {
      print("Error Parsing atau Koneksi: $e");
      isError.value =
          true; // 2. Set true saat crash/koneksi putus agar UI merender Message Error Global
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

  Future<void> shareEvent(EventModel event) async {
    try {
      final String eventName = event.title ?? 'Event Seru';
      final String eventCat = event.kategori ?? '-';
      final String eventDate = event.eventDate ?? '-';
      final String eventDesc = event.description ?? '-';
      final String eventUrl = event.registrationUrl ?? '-';

      // Susun template pesan text share sesuai kebutuhanmu
      final String shareText = "Yuk cek event menarik ini!\n\n"
          "📌 *Nama Event:* $eventName\n"
          "🏷️ *Kategori:* $eventCat\n"
          "📅 *Tanggal:* $eventDate\n\n"
          "📖 *Deskripsi:* $eventDesc\n"
          "🔗 *Link Pendaftaran:* $eventUrl\n\n"
          "Jangan sampai ketinggalan ya! ✨";

      // Memanggil method bawaan share_plus
      await Share.share(shareText);
    } catch (e) {
      Get.snackbar("Error", "Gagal membagikan event: $e",
          backgroundColor: cDark, colorText: cGold);
    }
  }
}
