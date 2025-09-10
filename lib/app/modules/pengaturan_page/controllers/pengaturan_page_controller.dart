import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class PengaturanPageController extends GetxController {
  final RxBool pushNotif = true.obs;

  var greeting = ''.obs;

  // Contoh data user — nanti bisa kamu ganti dari store/auth
  final RxString displayName = 'Mr. John Doe'.obs;
  final RxString photoUrl = ''.obs; // kosong = fallback avatar

  void toggleNotif(bool v) => pushNotif.value = v;

  void goToProfile() => Get.toNamed('/profile-user'); // sesuaikan rute
  void goToChangePassword() => Get.toNamed('/change-password');
  void goToFaqs() => Get.toNamed('/faqs');

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
