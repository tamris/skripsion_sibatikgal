import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/service/user_service.dart';
import 'package:get_storage/get_storage.dart'; // <--- Tambahkan import GetStorage

class ProfileUserController extends GetxController {
  final usernameC = TextEditingController();
  final genderC = TextEditingController();
  final tanggalLahirC = TextEditingController();
  final emailC = TextEditingController();

  var isLoading = false.obs;
  var isSaving = false.obs;
  var profilePictureUrl = ''.obs;
  var selectedLocalPath = ''.obs;
  var selectedGender = ''.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  // 1. Ambil data profil dari backend
 // 1. Ambil data profil dari backend
  void fetchUserProfile() async {
    isLoading.value = true;
    try {
      final response = await UserService.getProfile();

      if (response.statusCode == 200 && response.data['status'] == true) {
        final userData = response.data['user'];

        usernameC.text = userData['username'] ?? '';
        emailC.text = userData['email'] ?? '';
        genderC.text = userData['gender'] ?? '';
        selectedGender.value = userData['gender'] ?? '';

        String rawDate = userData['tanggal_lahir'] ?? '';
        if (rawDate.isNotEmpty && rawDate.contains('-')) {
          List<String> splitted = rawDate.split('-');
          if (splitted.length == 3) {
            tanggalLahirC.text = "${splitted[2]}-${splitted[1]}-${splitted[0]}";
          } else {
            tanggalLahirC.text = rawDate;
          }
        } else {
          tanggalLahirC.text = rawDate;
        }

        profilePictureUrl.value = userData['profile_picture'] ?? '';

        // =========================================================
        // TAMBAHKAN INI: TULIS ULANG DATA TERBARU KE GETSTORAGE
        // =========================================================
        final getStorage = GetStorage();
        getStorage.write('user_data', userData); // Menyimpan cache terbaru agar dibaca Beranda

      } else {
        Get.snackbar("Error", "Gagal memuat profil pengguna",
            backgroundColor: const Color(0xFFFFEBEE));
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal terhubung ke server",
          backgroundColor: const Color(0xFFFFEBEE));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        selectedLocalPath.value = image.path;
      }
    } catch (e) {
      Get.snackbar("Error", "Gagal mengambil gambar dari galeri",
          backgroundColor: const Color(0xFFFFEBEE));
    }
  }

  // 3. Kirim data update profil (Multipart) ke backend
  void saveProfileChanges() async {
    if (usernameC.text.trim().isEmpty) {
      Get.snackbar("Peringatan", "Nama lengkap tidak boleh kosong",
          backgroundColor: const Color(0xFFFFF3E0));
      return;
    }

    // --- AMAN: Parsing balik dari DD-MM-YYYY menjadi YYYY-MM-DD khusus saat kirim ke Backend Flask ---
    String formattedDateForBackend = tanggalLahirC.text.trim();
    if (formattedDateForBackend.isNotEmpty &&
        formattedDateForBackend.contains('-')) {
      List<String> splitted = formattedDateForBackend.split('-');
      if (splitted.length == 3) {
        formattedDateForBackend =
            "${splitted[2]}-${splitted[1]}-${splitted[0]}";
      }
    }

    isSaving.value = true;
    try {
      final response = await UserService.updateProfile(
        username: usernameC.text.trim(),
        gender: genderC.text.trim(),
        tanggalLahir:
            formattedDateForBackend, // Dikirim dengan format database yang bener
        imagePath:
            selectedLocalPath.value.isNotEmpty ? selectedLocalPath.value : null,
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        Get.snackbar("Berhasil", "Profil kamu berhasil diperbarui!",
            backgroundColor: const Color(0xFFE8F5E9));
        selectedLocalPath.value = '';
        fetchUserProfile();
      } else {
        Get.snackbar(
            "Gagal", response.data['msg'] ?? "Gagal menyimpan perubahan",
            backgroundColor: const Color(0xFFFFEBEE));
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan sistem saat menyimpan data",
          backgroundColor: const Color(0xFFFFEBEE));
    } finally {
      isSaving.value = false;
    }
  }

  // Fungsi memilih tanggal lahir dengan Date Picker
  Future<void> chooseTanggalLahir(BuildContext context) async {
    DateTime initialDate =
        DateTime.now().subtract(const Duration(days: 365 * 20));

    // Parsing teks DD-MM-YYYY agar kalender mendeteksi tanggal awal secara bener saat dibuka
    if (tanggalLahirC.text.isNotEmpty && tanggalLahirC.text.contains('-')) {
      try {
        List<String> splitted = tanggalLahirC.text.split('-');
        if (splitted.length == 3) {
          initialDate =
              DateTime.parse("${splitted[2]}-${splitted[1]}-${splitted[0]}");
        }
      } catch (_) {}
    }

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1C1308),
              onPrimary: Colors.white,
              onSurface: Color(0xFF1C1308),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      // --- AMAN: Simpan hasil pick ke controller langsung dengan format user (DD-MM-YYYY) ---
      String formattedDate =
          "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}";
      tanggalLahirC.text = formattedDate;
    }
  }

  @override
  void onClose() {
    usernameC.dispose();
    genderC.dispose();
    tanggalLahirC.dispose();
    emailC.dispose();
    super.onClose();
  }
}
