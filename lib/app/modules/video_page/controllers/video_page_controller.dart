// lib/app/modules/video_page/controllers/video_page_controller.dart
import 'package:get/get.dart';
import '../../../data/models/video_model.dart';
import '../../../data/service/video_service.dart';

class VideoPageController extends GetxController {
  var videoList = <VideoModel>[].obs;
  var isLoading = false.obs;

  // Variabel untuk Search dan Kategori
  final RxString selectedCategory = 'Semua'.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchVideos();
  }

  void fetchVideos() async {
    isLoading.value = true;
    try {
      final response = await VideoService.fetchAllVideos(
        search: searchQuery.value, // Kirim query pencarian ke API
      );

      if (response.statusCode == 200) {
        List data = response.data['data'];
        videoList.assignAll(data.map((e) => VideoModel.fromJson(e)).toList());
      }
    } catch (e) {
      print("Error Fetching Video: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Filter list berdasarkan kategori yang dipilih user
  List<VideoModel> get filteredVideos {
    if (selectedCategory.value == 'Semua') return videoList;
    return videoList.where((v) => v.kategori == selectedCategory.value).toList();
  }

  // Ambil daftar kategori unik langsung dari data database
  List<String> get categories {
    final all = videoList.map((v) => v.kategori ?? 'Umum').toSet().toList();
    all.insert(0, 'Semua');
    return all;
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    fetchVideos(); // Panggil API setiap kali mengetik
  }

  void onCategoryChanged(String cat) {
    selectedCategory.value = cat;
  }
}