import 'package:batikara/app/data/service/oauth_service.dart';
import 'package:batikara/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class PengaturanPageController extends GetxController {
  final RxBool pushNotif = true.obs;

  var greeting = ''.obs;

  // Contoh data user — nanti bisa kamu ganti dari store/auth
  final RxString displayName = 'Rizqi Pratama'.obs;
  final RxString photoUrl = ''.obs; // kosong = fallback avatar

  void toggleNotif(bool v) => pushNotif.value = v;

  void goToProfile() => Get.toNamed('/profile-user'); // sesuaikan rute
  void goToChangePassword() => Get.toNamed('/ubah-sandi');
  void goToFaqs() => Get.toNamed('/faqs');

  void logout() async {
    final storage = GetStorage();
    storage.remove('token'); // Hapus token sesi
    storage.remove('user_data');

    Get.until((route) => Get.currentRoute == Routes.LOGIN_PAGE);
    await OauthService.logout();
    Get.offAllNamed(Routes.LOGIN_PAGE);
  }

  @override
  void onInit() {
    super.onInit();
    loadGreeting();
  }

  Future<void> contactWhatsApp() async {
    final url =
        Uri.parse('https://wa.me/6281391497365?text=Halo%20Tim%20Batikara');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Gagal membuka', 'Tidak dapat membuka WhatsApp');
    }
  }

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
