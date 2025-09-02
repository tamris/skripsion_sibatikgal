import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

// widgets terpisah
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
    return const Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      bottomNavigationBar: HomeBottomNav(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: HomeHeader()),
            SliverToBoxAdapter(child: HomeSearchBar()),
            SliverToBoxAdapter(child: HomeCarousel()),
            SliverToBoxAdapter(child: HomeQuickActions()),
            SliverToBoxAdapter(
              child: HomeSectionTitle(title: 'Browser', action: 'Lihat semua'),
            ),
            HomeNewsList(),
            SliverToBoxAdapter(child: SizedBox(height: 16)),
          ],
        ),
      ),
    );
  }
}
