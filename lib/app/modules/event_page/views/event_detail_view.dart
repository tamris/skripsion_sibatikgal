import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/models/event_model.dart';
import '../controllers/event_page_controller.dart';

// Panggil 3 komponen utama yang seimbang ukurannya
import '../widgets/detail_header_section.dart';
import '../widgets/detail_content_section.dart'; // Sudah gabungan konten, deskripsi, lokasi, pendaftaran
import '../widgets/detail_bottom_action.dart';

class EventDetailView extends GetView<EventPageController> {
  const EventDetailView({super.key});

  static const Color cDark = Color(0xFF1A1208);
  static const Color cKrem = Color(0xFFF7F4EE);
  static const Color cGold = Color(0xFFFFD264);
  static const Color cTextSub = Color(0xFF9C8B7A);

  @override
  Widget build(BuildContext context) {
    final EventModel? event = Get.arguments;

    if (event == null) {
      return Scaffold(
        backgroundColor: cKrem,
        appBar: AppBar(
          backgroundColor: cKrem,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: cDark, size: 16),
            onPressed: () => Get.back(),
          ),
        ),
        body: Center(
          child: Text("Data event tidak tersedia",
              style: GoogleFonts.poppins(fontSize: 14, color: cTextSub)),
        ),
      );
    }

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: cKrem,
      body: SafeArea(
        child: Stack(
          children: [
            // ── SCROLL CONTENT ────────────────────────────────
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: DetailHeaderSection(event: event)),

                // Menerima parameter fungsi navigasi map dan pendaftaran
                SliverToBoxAdapter(
                  child: DetailContentSection(
                    event: event,
                    onOpenMap: controller.openMap,
                    onOpenRegistration: controller.openRegistration,
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 110)),
              ],
            ),

            // ── BOTTOM CTA ────────────────────────────────────
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: DetailBottomAction(
                event: event,
                bottomPadding: bottomPadding,
                onOpenMap: controller.openMap,
                onOpenRegistration: controller.openRegistration,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
