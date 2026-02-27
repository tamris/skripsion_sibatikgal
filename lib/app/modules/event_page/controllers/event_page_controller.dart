import 'package:get/get.dart';
import '../../../data/models/event_model.dart';
import '../../../data/service/event_service.dart';

class EventPageController extends GetxController {
  var eventList = <EventModel>[].obs;
  var isLoading = false.obs;
  final RxString selectedCategory = 'Semua'.obs;
  final RxString searchQuery = ''.obs;

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

        // Cek apakah data muncul di terminal
        print("Data Event dari API: ${data.length} item");

        eventList.assignAll(data.map((e) => EventModel.fromJson(e)).toList());
      } else {
        print("API Error: ${response.statusCode}");
      }
    } catch (e) {
      // Ini akan membantu kamu melihat jika ada field yang salah tipe data
      print("Error Parsing atau Koneksi: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Filter kategori lokal agar lebih cepat
  List<EventModel> get filteredEvents {
    if (selectedCategory.value == 'Semua') return eventList;
    return eventList
        .where((e) => e.kategori == selectedCategory.value)
        .toList();
  }

  // Ambil list kategori unik untuk ChoiceChip
  List<String> get categories {
    final all = eventList
        .map((e) => e.kategori)
        .whereType<String>()
        .map((kategori) => kategori.trim())
        .where((kategori) => kategori.isNotEmpty)
        .toSet()
        .toList();
    all.insert(0, 'Semua');
    return all;
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    fetchEvents(); // Panggil ulang API saat user mengetik
  }

  void onCategoryChanged(String cat) {
    selectedCategory.value = cat;
  }

  
}
