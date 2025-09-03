import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

import '../widgets/courosel.dart';
import '../widgets/hedaer.dart';
import '../widgets/new_list.dart';
import '../widgets/search.dart';
import '../widgets/quick_actions.dart';
import '../widgets/section_title.dart';
import '../widgets/bottom_nav.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F2),
      bottomNavigationBar: const HomeBottomNav(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: HomeHeader()),
            const SliverToBoxAdapter(child: HomeSearchBar()),
            const SliverToBoxAdapter(child: HomeCarousel()),
            const SliverToBoxAdapter(child: HomeQuickActions()),
            SliverToBoxAdapter(
              child: HomeSectionTitle(
                title: 'Informasi',
                action: 'Lihat semua >',
                onTap: () => Get.toNamed('/informasi-page'),
              ),
            ),
            const HomeNewsList(),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
          ],
        ),
      ),
    );
  }
}
