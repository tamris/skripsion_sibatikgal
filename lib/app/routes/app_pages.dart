import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../modules/chatbot_page/bindings/chatbot_page_binding.dart';
import '../modules/chatbot_page/views/chatbot_page_view.dart';
import '../modules/deteksi_page/bindings/deteksi_page_binding.dart';
import '../modules/deteksi_page/views/deteksi_page_view.dart';
import '../modules/event_page/bindings/event_page_binding.dart';
import '../modules/event_page/views/event_detail_view.dart';
import '../modules/event_page/views/event_page_view.dart';
import '../modules/galeri_page/bindings/galeri_page_binding.dart';
import '../modules/galeri_page/views/galeri_page_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/informasi_page/bindings/informasi_page_binding.dart';
import '../modules/informasi_page/views/informasi_page_view.dart';
import '../modules/login_page/bindings/login_page_binding.dart';
import '../modules/login_page/views/login_page_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/otp_verifikasi/bindings/otp_verifikasi_binding.dart';
import '../modules/otp_verifikasi/views/otp_verifikasi_view.dart';
import '../modules/pengaturan_page/bindings/pengaturan_page_binding.dart';
import '../modules/pengaturan_page/views/pengaturan_page_view.dart';
import '../modules/profile_user/bindings/profile_user_binding.dart';
import '../modules/profile_user/views/profile_user_view.dart';
import '../modules/regsiter_page/bindings/regsiter_page_binding.dart';
import '../modules/regsiter_page/views/regsiter_page_view.dart';
import '../modules/reset_password_page/bindings/reset_password_page_binding.dart';
import '../modules/reset_password_page/views/reset_password_page_view.dart';
import '../modules/sejarah_page/bindings/sejarah_page_binding.dart';
import '../modules/sejarah_page/views/sejarah_page_view.dart';
import '../modules/ubah_sandi/bindings/ubah_sandi_binding.dart';
import '../modules/ubah_sandi/views/ubah_sandi_view.dart';
import '../modules/video_page/bindings/video_page_binding.dart';
import '../modules/video_page/views/video_page_view.dart';
import '../widgets/navigation/main_wrapper.dart';

part 'app_routes.dart';

class AppPages {
  static final storage = GetStorage();
  AppPages._();

  static final INITIAL =
      storage.read('token') != null ? Routes.HOME : Routes.ONBOARDING;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const MainWrapper(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN_PAGE,
      page: () => const LoginPageView(),
      binding: LoginPageBinding(),
    ),
    GetPage(
      name: _Paths.INFORMASI_PAGE,
      page: () => const InformasiPageView(),
      binding: InformasiPageBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_USER,
      page: () => const ProfileUserView(),
      binding: ProfileUserBinding(),
    ),
    GetPage(
      name: _Paths.GALERI_PAGE,
      page: () => const GaleriPageView(),
      binding: GaleriPageBinding(),
    ),
    GetPage(
      name: _Paths.CHATBOT_PAGE,
      page: () => const ChatbotPageView(),
      binding: ChatbotPageBinding(),
    ),
    GetPage(
      name: _Paths.PENGATURAN_PAGE,
      page: () => const PengaturanPageView(),
      binding: PengaturanPageBinding(),
    ),
    GetPage(
      name: _Paths.DETEKSI_PAGE,
      page: () => const DeteksiPageView(),
      binding: DeteksiPageBinding(),
    ),
    GetPage(
      name: _Paths.REGSITER_PAGE,
      page: () => const RegsiterPageView(),
      binding: RegsiterPageBinding(),
    ),
    GetPage(
      name: _Paths.OTP_VERIFIKASI,
      page: () => const OtpVerifikasiView(),
      binding: OtpVerifikasiBinding(),
    ),
    GetPage(
      name: _Paths.UBAH_SANDI,
      page: () => const UbahSandiView(),
      binding: UbahSandiBinding(),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD_PAGE,
      page: () => const ResetPasswordPageView(),
      binding: ResetPasswordPageBinding(),
    ),
    GetPage(
      name: _Paths.VIDEO_PAGE,
      page: () => const VideoPageView(),
      binding: VideoPageBinding(),
    ),
    GetPage(
      name: _Paths.EVENT_PAGE,
      page: () => const EventPageView(),
      binding: EventPageBinding(),
    ),
    GetPage(
      name: '/event-detail',
      page: () => const EventDetailView(),
      binding: EventPageBinding(), // Pakai binding yang sama bro!
    ),
    GetPage(
      name: _Paths.SEJARAH_PAGE,
      page: () => const SejarahPageView(),
      binding: SejarahPageBinding(),
    ),
  ];
}
