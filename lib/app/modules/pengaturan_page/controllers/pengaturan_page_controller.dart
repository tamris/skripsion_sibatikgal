import 'package:batikara/app/data/service/oauth_service.dart';
import 'package:batikara/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/service/user_service.dart'; // <--- Pastikan import ProfileService kamu ke sini

class PengaturanPageController extends GetxController {
  final storage =
      GetStorage(); // <--- Definisikan instance GetStorage secara global di class

  final RxBool pushNotif = true.obs;
  var greeting = ''.obs;

  // --- MURNI BEST PRACTICE: Menggunakan Observable kosong agar dinamis ---
  final RxString displayName = ''.obs;
  final RxString photoUrl = ''.obs;

  void toggleNotif(bool v) => pushNotif.value = v;

  // --- PROTEKSI NAVIGASI DENGAN AWAIT ---
  Future<void> goToProfile() async {
    await Get.toNamed('/profile-user'); // Menunggu halaman profile ditutup
    updateSettingProfile(); // Tarik data cache terbaru pas user kembali ke halaman ini
  }

  void goToChangePassword() => Get.toNamed('/ubah-sandi');
  void goToFaqs() => Get.toNamed('/faqs-page');
  void goToSaveItem() => Get.toNamed('/save-item-page');
  void goToAbout() => Get.toNamed('/tentang-aplikasi-page');

  void logout() async {
    storage.remove('token');
    storage.remove('user_data');

    Get.until((route) => Get.currentRoute == Routes.LOGIN_PAGE);
    await OauthService.logout();
    Get.offAllNamed(Routes.LOGIN_PAGE);
  }

  @override
  void onInit() {
    super.onInit();
    loadGreeting();
    updateSettingProfile(); // 1. Ambil cache lokal instan saat inisialisasi awal
    syncProfileFromServer(); // 2. Sinkronisasi data asli ke server di latar belakang
  }

  @override
  void onReady() {
    super.onReady();
    updateSettingProfile(); // 3. Pastikan layout selesai render, data reaktif ter-refresh sempurna
  }

  // =========================================================
  // FIX LOGIC: MEMBACA CACHE DARI GETSTORAGE
  // =========================================================
  void updateSettingProfile() {
    final userData = storage.read('user_data');
    if (userData != null) {
      displayName.value = userData['username'] ?? '';
      photoUrl.value = userData['profile_picture'] ?? '';
      photoUrl
          .refresh(); // Memaksa widget Obx di View melakukan pembaruan instan
    }
  }

  // =========================================================
  // BACKGROUND SYNC: Menyembuhkan total bug telat load pasca-login
  // =========================================================
  void syncProfileFromServer() async {
    try {
      final response = await UserService.getProfile();
      if (response.statusCode == 200 && response.data['status'] == true) {
        final userData = response.data['user'];

        // Simpan data paling segar dari server ke cache lokal
        storage.write('user_data', userData);

        // Perbarui state reaktif
        displayName.value = userData['username'] ?? '';
        photoUrl.value = userData['profile_picture'] ?? '';
        photoUrl.refresh();
      }
    } catch (e) {
      print("Background sync di halaman pengaturan gagal: $e");
    }
  }

  // Future<void> contactWhatsApp() async {
  //   final url =
  //       Uri.parse('https://wa.me/6281391497365?text=Halo%20Tim%20Batikara');
  //   if (await canLaunchUrl(url)) {
  //     await launchUrl(url, mode: LaunchMode.externalApplication);
  //   } else {
  //     Get.snackbar('Gagal membuka', 'Tidak dapat membuka WhatsApp');
  //   }
  // }

  void loadGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) {
      greeting.value = "Sugeng Enjing!";
    } else if (hour < 15) {
      greeting.value = "Sugeng Siang!";
    } else if (hour < 18) {
      greeting.value = "Sugeng Sonten!";
    } else {
      greeting.value = "Sugeng Dalu!";
    }
  }
}
