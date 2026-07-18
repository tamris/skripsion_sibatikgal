import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

// Import widget hasil pemisahan kamu
import '../controllers/event_page_controller.dart';
import '../widgets/event_search_bar.dart';
import '../widgets/event_filter_chips.dart';
import '../widgets/featured_card.dart';
import '../widgets/event_list_card.dart';
import '../../../data/models/event_model.dart';

class EventPageView extends GetView<EventPageController> {
  const EventPageView({super.key});

  // Palet warna premium konsisten Batikara global
  static const Color bgCanvas = Color(0xFFFAF7F2);
  static const Color darkBrown = Color(0xFF1C1308);
  static const Color textMuted = Color(0xFF7A7062);
  static const Color accentGold = Color(0xFFFBBF24);
  static const Color borderColor = Color(0xFFE6DFD5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCanvas,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const EventSearchBar(),
            const SizedBox(height: 9),
            const EventFilterChips(),
            const SizedBox(height: 16),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 14),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 42,
              height: 42,
              child: const Center(
                child:
                    Icon(Icons.arrow_back_rounded, size: 20, color: darkBrown),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'JELAJAHI',
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: textMuted,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  'Event Batik',
                  style: GoogleFonts.lora(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: darkBrown,
                      letterSpacing: -.3),
                ),
              ],
            ),
          ),
          const SizedBox(width: 42),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      // 1. KONDISI LOADING: Menggunakan full skeleton shimmer
      if (controller.isLoading.value) {
        return _buildShimmerLoading();
      }

      // 2. KONDISI ERROR / LOST CONNECTION: Memakai format message global premium yang seragam
      if (controller.isError.value) {
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFCE8E6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.wifi_off_rounded,
                        size: 40,
                        color: Color(0xFFC2612D),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Tidak Dapat Memuat Data',
                      style: GoogleFonts.poppins(
                        color: darkBrown,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Data tidak dapat dimuat saat ini. Pastikan koneksi internet Anda aktif, lalu ketuk tombol Coba Lagi.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: textMuted,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 150,
                      height: 44,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: darkBrown,
                          foregroundColor: accentGold,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        // Silakan sesuaikan fungsi refresh data event di controller kamu jika namanya berbeda
                        onPressed: () => controller.fetchEvents(),
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: Text(
                          'Coba Lagi',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }

      final events = controller.filteredEvents;
      if (events.isEmpty) return _buildEmptyState();

      final featured = events.first;
      final rest = events.length > 1 ? events.sublist(1) : <EventModel>[];

      // 3. KONDISI BERHASIL MEMUAT DATA
      return CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: FeaturedCard(event: featured),
            ),
          ),
          if (rest.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Event Lainnya',
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: darkBrown),
                    ),
                    Text(
                      '${rest.length} event',
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: textMuted,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: EventListCard(event: rest[i]),
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
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Color(0xFFF2ECE0),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.event_busy_outlined,
                  size: 30, color: darkBrown),
            ),
            const SizedBox(height: 20),
            Text(
              'Belum ada event',
              style: GoogleFonts.lora(
                  fontSize: 18, fontWeight: FontWeight.bold, color: darkBrown),
            ),
            const SizedBox(height: 6),
            Text(
              'Coba ubah filter atau kata pencarian',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 13, color: textMuted),
            ),
          ],
        ),
      ),
    );
  }

  // ================= INDUSTRIAL STANDARD: MULTI-LAYOUT SKELETON SHIMMER =================
  Widget _buildShimmerLoading() {
    const shimmerBg = Color(0xFFEFECE6); // Warna dasar skeleton yang tenang
    const maskColor = Color(0xFFE2DDD5); // Warna masking elemen dalam

    return Shimmer(
      color: const Color(0xFFFAF7F2),
      colorOpacity: 0.5,
      duration: const Duration(milliseconds: 1200),
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          // 1. SKELETON FEATURED CARD (Kartu Utama Atas)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Container(
                height: 260,
                decoration: BoxDecoration(
                  color: shimmerBg,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: borderColor, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Area Gambar Utama (70% Tinggi)
                    Expanded(
                      flex: 7,
                      child: Container(
                        decoration: BoxDecoration(
                          color: maskColor,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(23)),
                        ),
                      ),
                    ),
                    // Area Teks Info di Bawah Gambar (3% Tinggi)
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Garis Masking Judul Utama
                            Container(
                              width: 180,
                              height: 16,
                              decoration: BoxDecoration(
                                color: maskColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Garis Masking Tanggal/Sub-info
                            Container(
                              width: 100,
                              height: 12,
                              decoration: BoxDecoration(
                                color: maskColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 2. SKELETON SECTION TITLE
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 110,
                    height: 16,
                    decoration: BoxDecoration(
                      color: maskColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(
                    width: 50,
                    height: 14,
                    decoration: BoxDecoration(
                      color: maskColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. SKELETON EVENT LIST CARD (Daftar List Kiri-Kanan)
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: shimmerBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: borderColor, width: 1),
                  ),
                  child: Row(
                    children: [
                      // Sisi Kiri: Kotak Gambar Kecil (Thumbnail)
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: maskColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(19),
                            bottomLeft: Radius.circular(19),
                          ),
                        ),
                      ),
                      // Sisi Kanan: Baris Teks Judul & Detail Event
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: maskColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                width: 140,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: maskColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: 80,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: maskColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              childCount: 2, // Merender 2 baris list reguler tiruan
            ),
          ),
        ],
      ),
    );
  }
}
