import 'package:get/get.dart';

import '../modules/galeri_page/bindings/galeri_page_binding.dart';
import '../modules/galeri_page/views/galeri_page_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/informasi_page/bindings/informasi_page_binding.dart';
import '../modules/informasi_page/views/informasi_page_view.dart';
import '../modules/login_page/bindings/login_page_binding.dart';
import '../modules/login_page/views/login_page_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/profile_user/bindings/profile_user_binding.dart';
import '../modules/profile_user/views/profile_user_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
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
  ];
}
