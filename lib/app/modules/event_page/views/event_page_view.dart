import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// Import widget hasil pemisahan kita
import '../controllers/event_page_controller.dart';
import '../widgets/event_search_bar.dart';
import '../widgets/event_filter_chips.dart';
import '../widgets/featured_card.dart';
import '../widgets/event_list_card.dart';
import '../../../data/models/event_model.dart';

class EventPageView extends GetView<EventPageController> {
  const EventPageView({super.key});

  static const Color cDark = Color(0xFF1A1208);
  static const Color cKrem = Color(0xFFF7F4EE);
  static const Color cKremChip = Color(0xFFF0EAD8);
  static const Color cGold = Color(0xFFFFD264);
  static const Color cBrown = Color(0xFF7A3B10);
  static const Color cTextSub = Color(0xFF9C8B7A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cKrem,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const EventSearchBar(),
            const SizedBox(height: 9),
            const EventFilterChips(), // Hasil pisahan
            const SizedBox(height: 16),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 45,
              height: 45,
              decoration: const BoxDecoration(
                color: cKremChip,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.arrow_back, size: 16, color: cDark),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('JELAJAHI',
                    style: GoogleFonts.lora(
                        fontSize: 14,
                        color: cTextSub,
                        letterSpacing: .5,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text('Event Batik',
                    style: GoogleFonts.lora(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: cDark,
                        letterSpacing: -.3)),
              ],
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: cBrown, strokeWidth: 2),
        );
      }

      final events = controller.filteredEvents;
      if (events.isEmpty) return _buildEmptyState();

      final featured = events.first;
      final rest = events.length > 1 ? events.sublist(1) : <EventModel>[];

      return CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: FeaturedCard(event: featured), // Menggunakan widget baru
            ),
          ),
          if (rest.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Event Lainnya',
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: cDark)),
                    Text('${rest.length} event',
                        style:
                            GoogleFonts.poppins(fontSize: 14, color: cTextSub)),
                  ],
                ),
              ),
            ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: EventListCard(event: rest[i]), // Menggunakan widget baru
              ),
              childCount: rest.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: cKremChip,
              borderRadius: BorderRadius.circular(20),
            ),
            child:
                const Icon(Icons.event_busy_outlined, size: 30, color: cBrown),
          ),
          const SizedBox(height: 14),
          Text('Belum ada event',
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.w500, color: cDark)),
          const SizedBox(height: 6),
          Text('Coba ubah filter atau kata pencarian',
              style: GoogleFonts.poppins(fontSize: 12, color: cTextSub)),
        ],
      ),
    );
  }
}
