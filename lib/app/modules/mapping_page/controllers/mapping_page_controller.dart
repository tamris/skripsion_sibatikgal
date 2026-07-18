import 'package:batikara/app/data/models/mapping_model.dart';
import 'package:batikara/app/data/service/mapping_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get_storage/get_storage.dart';

class MappingPageController extends GetxController {
  final MappingService _mappingService = MappingService();
  final MapController mapController = MapController();
  final _storage = GetStorage();

  final TextEditingController searchTextController = TextEditingController();
  var isSearching =
      false.obs; // Untuk memantau apakah user sedang mengetik atau tidak

  var isLoading = true.obs;
  final locationsList = <MappingModelData>[].obs;
  final filteredLocationsList = <MappingModelData>[].obs;

  // State interaktif untuk form ulasan baru
  var userRating = 0.obs;
  final TextEditingController reviewCommentController = TextEditingController();
  var isSendingReview = false.obs; // Loader khusus tombol kirim

  // KUNCI BEST PRACTICE: Flag reaktif penanda status ulasan user saat ini
  var isAlreadyReviewed = false.obs;
// State untuk melacak tab aktif di halaman detail (0: Info, 1: Ulasan, 2: Foto)
  var selectedDetailTab = 0.obs;
  // Penampung reaktif utama untuk menyinkronkan data live ke halaman detail
  final currentDetailLocation = MappingModelData().obs;

  void resetReviewForm() {
    userRating.value = 0;
    reviewCommentController.clear();
    isAlreadyReviewed.value = false;
  }

  // GPS & Map State
  var userPosition = Rxn<Position>();
  var mapCenter = const LatLng(
    -6.9996,
    109.1230,
  ).obs; // Default koordinat Tegal

  // Filter state
  var selectedCategory = 'Semua'.obs;
  final List<String> categories = [
    'Semua',
    'Pengrajin',
    'Toko',
    'Sentra Batik',
    'Edukasi',
  ];

  @override
  void onClose() {
    reviewCommentController.dispose();
    searchTextController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    initLocationAndData();
  }

  Future<void> initLocationAndData() async {
    try {
      isLoading(true);
      await determinePosition();
      await loadLocations();
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  // Ambil izin lokasi user
  Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Layanan lokasi (GPS) dinonaktifkan.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Izin lokasi ditolak.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Izin lokasi ditolak permanen.');
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    userPosition.value = position;
    mapCenter.value = LatLng(position.latitude, position.longitude);
  }

  Future<void> recenterToUserSpace() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      userPosition.value = position;
      mapCenter.value = LatLng(position.latitude, position.longitude);

      mapController.move(mapCenter.value, 15.0);
    } catch (e) {
      Get.snackbar(
        'GPS Error',
        'Gagal mengambil lokasi terbaru. Pastikan GPS kamu aktif.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Load data dari backend & hitung jarak terdekat
  Future<void> loadLocations({String query = ''}) async {
    try {
      var data = await _mappingService.fetchLocations(query: query);

      if (userPosition.value != null) {
        for (var loc in data) {
          if (loc.latitude != null && loc.longitude != null) {
            double distanceInMeters = Geolocator.distanceBetween(
              userPosition.value!.latitude,
              userPosition.value!.longitude,
              loc.latitude!,
              loc.longitude!,
            );
            loc.distance = distanceInMeters / 1000;
          }
        }
        data.sort((a, b) => (a.distance ?? 0).compareTo(b.distance ?? 0));
      }

      locationsList.assignAll(data);
      filterLocations(selectedCategory.value);
    } catch (e) {
      Get.snackbar('Gagal Memuat', 'Tidak dapat memperbarui daftar lokasi.');
    }
  }

  // Fungsi Filter Kategori
  void filterLocations(String selectedCat) {
    selectedCategory.value = selectedCat;

    if (selectedCat == 'Semua') {
      filteredLocationsList.assignAll(locationsList);
    } else {
      filteredLocationsList.assignAll(
        locationsList.where((loc) {
          bool matchUtama =
              loc.category?.toLowerCase() == selectedCat.toLowerCase();

          bool matchTambahan = loc.categories != null &&
              loc.categories!.any(
                (cat) => cat.toLowerCase() == selectedCat.toLowerCase(),
              );

          return matchUtama || matchTambahan;
        }).toList(),
      );
    }
  }

  Future<void> bukaGoogleMaps(
    double? lat,
    double? lng,
    String? placeName,
  ) async {
    if (lat == null || lng == null) {
      Get.snackbar(
        'Gagal',
        'Koordinat lokasi tidak valid atau tidak ditemukan.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      return;
    }

    // Gunakan skema geo intent universal untuk aplikasi Maps bawaan smartphone
    final Uri googleMapsUrl = Uri.parse(
        'geo:$lat,$lng?q=$lat,$lng(${Uri.encodeComponent(placeName ?? 'Lokasi Batik')})');

    // URL Cadangan jika geo intent tidak disupport (dibuka lewat browser)
    final Uri googleMapsWebUrl =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');

    try {
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl);
      } else if (await canLaunchUrl(googleMapsWebUrl)) {
        await launchUrl(googleMapsWebUrl, mode: LaunchMode.externalApplication);
      } else {
        throw 'Tidak bisa membuka URL Maps.';
      }
    } catch (e) {
      Get.snackbar(
        'Terjadi Kesalahan',
        'Gagal membuka Google Maps atau browser tidak tersedia.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> kontakWhatsApp(String? phone) async {
    if (phone == null || phone.isEmpty) {
      Get.snackbar(
        'Info',
        'Nomor WhatsApp tempat ini tidak tersedia.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    String cleanedPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanedPhone.startsWith('0')) {
      cleanedPhone = '62${cleanedPhone.substring(1)}';
    } else if (cleanedPhone.startsWith('8')) {
      cleanedPhone = '62$cleanedPhone';
    }

    // Best practice WhatsApp Link menggunakan skema whatsapp intent langsung atau api.whatsapp
    final Uri whatsappUrl = Uri.parse(
        'whatsapp://send?phone=$cleanedPhone&text=${Uri.encodeComponent("Halo, saya ingin bertanya tentang informasi Batik Tegalan di toko Anda.")}');

    // Cadangan jika aplikasi WA tidak terinstall langsung (buka via web browser)
    final Uri whatsappWebUrl = Uri.parse(
        'https://api.whatsapp.com/send?phone=$cleanedPhone&text=${Uri.encodeComponent("Halo, saya ingin bertanya tentang informasi Batik Tegalan di toko Anda.")}');

    try {
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl);
      } else if (await canLaunchUrl(whatsappWebUrl)) {
        await launchUrl(whatsappWebUrl, mode: LaunchMode.externalApplication);
      } else {
        throw 'Tidak dapat membuka WhatsApp.';
      }
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Pastikan aplikasi WhatsApp sudah terinstal di perangkat Anda.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> kirimUlasanKeFlask(String mappingId) async {
    try {
      isSendingReview(true);

      int rating = userRating.value;
      String comment = reviewCommentController.text.trim();

      var response = await _mappingService.submitReview(
        mappingId: mappingId,
        rating: rating,
        comment: comment,
      );

      if (response['status'] == 'success') {
        Get.snackbar(
          'Sukses',
          response['message'] ?? 'Ulasan berhasil ditambahkan!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        userRating(0);
        reviewCommentController.clear();

        await loadLocations();

        var updatedLoc = locationsList.firstWhereOrNull(
          (l) => l.id == mappingId,
        );

        if (updatedLoc != null) {
          currentDetailLocation.value = updatedLoc;
          cekUlasanLamaUser(updatedLoc.reviews ?? []);
        }
      } else {
        Get.snackbar(
          'Gagal Mengirim',
          response['message'] ?? 'Terjadi kesalahan sistem.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kegagalan memproses ulasan: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSendingReview(false);
    }
  }

  void cekUlasanLamaUser(List<ReviewModel> reviews) {
    // 1. Ambil token JWT transaksi yang sudah pasti tersimpan pas login
    String? token = _storage.read('token');
    String? currentUserId;

    if (token != null && token.isNotEmpty) {
      try {
        // 2. Bongkar isi JWT untuk mengambil ID User murni (Payload Identity)
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

        // Ekstrak ID dari payload JWT (standar Flask-JWT-Extended menggunakan sub atau identity)
        currentUserId = decodedToken['sub']?.toString() ??
            decodedToken['identity']?.toString();
      } catch (e) {
        currentUserId = null;
      }
    }

    if (currentUserId == null || currentUserId.isEmpty) {
      isAlreadyReviewed.value = false;
      userRating.value = 0;
      reviewCommentController.clear();
      return;
    }

    // 3. Cocokkan ulasan murni berdasarkan perbandingan ID unik secara kokoh
    var ulasanLama = reviews.firstWhereOrNull((r) {
      if (r.userId == null) return false;

      String reviewUserId = r.userId.toString();

      // Bersihkan format ObjectId bawaan MongoDB jika ada
      reviewUserId =
          reviewUserId.replaceAll("ObjectId('", "").replaceAll("')", "");
      String cleanCurrentUserId =
          currentUserId!.replaceAll("ObjectId('", "").replaceAll("')", "");

      return reviewUserId.trim() == cleanCurrentUserId.trim();
    });

    // 4. Update status form secara reaktif
    if (ulasanLama != null) {
      isAlreadyReviewed.value = true;
      userRating.value = ulasanLama.rating?.round() ?? 0;
      reviewCommentController.text = ulasanLama.comment ?? '';
    } else {
      isAlreadyReviewed.value = false;
      userRating.value = 0;
      reviewCommentController.clear();
    }
  }

  // ===========================================================================
  // KUNCI BEST PRACTICE: Eksekusi Update Jalur HTTP PUT
  // ===========================================================================
  Future<void> perbaruiUlasanDiFlask(String mappingId) async {
    try {
      isSendingReview(true);
      int rating = userRating.value;
      String comment = reviewCommentController.text.trim();

      var response = await _mappingService.updateReview(
        mappingId: mappingId,
        rating: rating,
        comment: comment,
      );

      if (response['status'] == 'success') {
        Get.snackbar(
          'Sukses',
          response['message'] ?? 'Ulasan berhasil diperbarui!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        await loadLocations();
        var updatedLoc = locationsList.firstWhereOrNull(
          (l) => l.id == mappingId,
        );
        if (updatedLoc != null) {
          currentDetailLocation.value = updatedLoc;
          cekUlasanLamaUser(updatedLoc.reviews ?? []);
        }
      } else {
        Get.snackbar(
          'Gagal',
          response['message'] ?? 'Gagal memperbarui ulasan.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memproses pembaruan: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSendingReview(false);
    }
  }

  Future<void> bagikanLokasi(MappingModelData loc) async {
    if (loc.name == null) return;

    // Susun template teks share yang informatif dan rapi
    final String namaTempat = loc.name!;
    final String kategori = loc.category ?? '-';
    final String alamat = loc.address != null && loc.address!['full'] != null
        ? loc.address!['full'].toString()
        : 'Alamat belum terdaftar.';

    // Link koordinat Google Maps agar penerima bisa langsung klik navigasi
    final String linkMaps = loc.latitude != null && loc.longitude != null
        ? '\n\nBuka di Google Maps:\nhttps://www.google.com/maps/search/?api=1&query=${loc.latitude},${loc.longitude}'
        : '';

    final String textToShare =
        'Temukan tempat Batik menarik di aplikasi Sibatikgal!\n\n'
        '🏛️ Nama: $namaTempat\n'
        '🏷️ Kategori: $kategori\n'
        '📍 Alamat: $alamat'
        '$linkMaps';

    try {
      // Panggil share dialog sistem smartphone
      await Share.share(
        textToShare,
        subject: 'Rekomendasi Tempat Batik: $namaTempat',
      );
    } catch (e) {
      Get.snackbar(
        'Gagal Berbagi',
        'Terjadi kesalahan saat mencoba membagikan informasi.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
