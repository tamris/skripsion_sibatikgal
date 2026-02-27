import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/event_page_controller.dart';
import '../widgets/event_search_bar.dart';
import '../widgets/event_category_filter.dart';
import '../widgets/event_list_section.dart';

class EventPageView extends GetView<EventPageController> {
  const EventPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8F4),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  EventSearchBar(),
                  EventCategoryFilter(),
                  SizedBox(height: 16),
                ],
              ),
            ),
            const EventListSection(),
            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: const Color(0xFFFBF8F4),
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
            onPressed: () => Get.back(),
          ),
        ),
      ),
      title: Text(
        'Kalender Event',
        style: GoogleFonts.lora(
          color: const Color(0xFF4E342E),
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
    );
  }
}
