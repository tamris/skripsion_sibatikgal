import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shimmer_animation/shimmer_animation.dart'; // Impor paket shimmer andalanmu
import '../../galeri_page/views/galeri_detail_view.dart';
import '../../informasi_page/views/informasi_detail_page.dart';
import '../../informasi_page/controllers/informasi_page_controller.dart';
import '../controllers/global_search_controller.dart';

class GlobalSearchView extends GetView<GlobalSearchController> {
  const GlobalSearchView({super.key});

  // Palet warna premium konsisten Batikara global
  static const Color bgCanvas = Color(0xFFFAF7F2);
  static const Color darkBrown = Color(0xFF1C1308);
  static const Color textMuted = Color(0xFF7A7062);
  static const Color accentGold = Color(0xFFFBBF24);
  static const Color borderColor = Color(0xFFE6DFD5);
  static const Color softRed = Color(0xFFFCE8E6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgCanvas,
      appBar: AppBar(
        backgroundColor: bgCanvas,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Center(
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.all(10),
                child: const Icon(Icons.arrow_back_rounded,
                    color: darkBrown, size: 20),
              ),
            ),
          ),
        ),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'JELAJAHI',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: textMuted,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Pencarian Global',
              style: GoogleFonts.lora(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: darkBrown,
                height: 1.15,
              ),
            ),
          ],
        ),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(124),
          child: Column(
            children: [
              // Search Input Bar Premium
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: borderColor, width: 1.0),
                  ),
                  child: TextField(
                    controller: controller.searchC,
                    cursorColor: darkBrown,
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: darkBrown,
                        fontWeight: FontWeight.w500),
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) => controller.fetchGlobalSearch(value),
                    decoration: InputDecoration(
                      hintText: 'Cari sesuatu...',
                      hintStyle: GoogleFonts.poppins(
                        color: textMuted.withValues(alpha: 0.5),
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(Icons.search_rounded,
                          color: textMuted.withValues(alpha: 0.7), size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear_rounded,
                            color: textMuted.withValues(alpha: 0.7), size: 18),
                        onPressed: () => controller.searchC.clear(),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 16),
                    ),
                  ),
                ),
              ),
              // TabBar Kategori Konten Premium
              TabBar(
                controller: controller.tabController,
                labelColor: darkBrown,
                unselectedLabelColor: textMuted,
                indicatorColor: darkBrown,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 2.5,
                dividerColor: borderColor,
                labelStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700, fontSize: 13),
                unselectedLabelStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500, fontSize: 13),
                tabs: const [
                  Tab(text: 'Motif'),
                  Tab(text: 'Artikel'),
                  Tab(text: 'Video'),
                  Tab(text: 'Event'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Obx(() {
        // 1. STATE LOADING UTAMA MENGGUNAKAN LIST MULTI-LAYOUT SKELETON SHIMMER
        if (controller.isLoading.value) {
          return _buildShimmerLoading();
        }

        // 2. STATE ERROR / LOST CONNECTION
        if (controller.isError.value) {
          return _buildEmptyOrErrorState(
              Icons.wifi_off_rounded,
              'Gagal Memuat Data',
              'Gagal memuat hasil pencarian global. Pastikan koneksi internet ponsel Anda aktif.',
              true);
        }

        // 3. KONDISI NORMAL DATA BERHASIL DIMUAT
        return TabBarView(
          controller: controller.tabController,
          children: [
            _buildBatikTab(),
            _buildArtikelTab(),
            _buildVideoTab(),
            _buildEventTab(),
          ],
        );
      }),
    );
  }

  // --- RENDERING TAB MOTIF BATIK ---
  Widget _buildBatikTab() {
    if (controller.batikResults.isEmpty) {
      return _buildEmptyOrErrorState(
          Icons.style_outlined,
          'Motif Tidak Ditemukan',
          'Tidak ada koleksi motif batik yang cocok dengan kata kunci pencarian Anda.',
          false);
    }
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: controller.batikResults.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, idx) {
        final batik = controller.batikResults[idx];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: batik.image,
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer(
                  color: const Color(0xFFFAF7F2),
                  colorOpacity: 0.5,
                  duration: const Duration(milliseconds: 1200),
                  child: Container(
                      color: const Color(0xFFE6DFD5), width: 52, height: 52),
                ),
                errorWidget: (_, __, ___) => Container(
                  width: 52,
                  height: 52,
                  color: const Color(0xFFE6DFD5),
                  child: const Icon(Icons.broken_image_rounded,
                      color: textMuted, size: 20),
                ),
              ),
            ),
            title: Text(batik.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    color: darkBrown,
                    fontSize: 15)),
            subtitle: Text(batik.category,
                style: GoogleFonts.poppins(
                    color: textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w500)),
            trailing: Container(
              padding: const EdgeInsets.all(6),
              decoration:
                  const BoxDecoration(color: bgCanvas, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_forward_ios_rounded,
                  size: 10, color: darkBrown),
            ),
            onTap: () => Get.to(() => GaleriDetailView(batik: batik)),
          ),
        );
      },
    );
  }

  // --- RENDERING TAB ARTIKEL / INFORMASI ---
  Widget _buildArtikelTab() {
    if (controller.artikelResults.isEmpty) {
      return _buildEmptyOrErrorState(
          Icons.article_outlined,
          'Artikel Tidak Ditemukan',
          'Tidak ada info artikel batik yang cocok dengan kata kunci pencarian Anda.',
          false);
    }
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: controller.artikelResults.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, idx) {
        final artikel = controller.artikelResults[idx];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: artikel.imageUrl ?? '',
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer(
                  color: const Color(0xFFFAF7F2),
                  colorOpacity: 0.5,
                  duration: const Duration(milliseconds: 1200),
                  child: Container(
                      color: const Color(0xFFE6DFD5), width: 52, height: 52),
                ),
                errorWidget: (_, __, ___) => Container(
                  width: 52,
                  height: 52,
                  color: const Color(0xFFE6DFD5),
                  child: const Icon(Icons.article_rounded,
                      color: textMuted, size: 22),
                ),
              ),
            ),
            title: Text(artikel.title ?? 'Tanpa Judul',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    color: darkBrown,
                    fontSize: 15)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text(artikel.deskripsi ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                      color: textMuted, fontSize: 12, height: 1.3)),
            ),
            trailing: Container(
              padding: const EdgeInsets.all(6),
              decoration:
                  const BoxDecoration(color: bgCanvas, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_forward_ios_rounded,
                  size: 10, color: darkBrown),
            ),
            onTap: () {
              Get.to(
                () => InformasiDetailPage(),
                binding: BindingsBuilder(
                    () => Get.lazyPut(() => InformasiPageController())),
                arguments: artikel,
              );
            },
          ),
        );
      },
    );
  }

  // --- RENDERING TAB SPESIFIK VIDEO MAPPING MODEL ---
  Widget _buildVideoTab() {
    if (controller.videoResults.isEmpty) {
      return _buildEmptyOrErrorState(
          Icons.videocam_outlined,
          'Video Tidak Ditemukan',
          'Tidak ada unggahan edukasi video yang cocok dengan kata kunci pencarian Anda.',
          false);
    }
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: controller.videoResults.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, idx) {
        final video = controller.videoResults[idx];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                color: darkBrown,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CachedNetworkImage(
                      imageUrl: video.getThumbnail,
                      width: 64,
                      height: 48,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer(
                        color: const Color(0xFFFAF7F2),
                        colorOpacity: 0.5,
                        duration: const Duration(milliseconds: 1200),
                        child: Container(
                            color: const Color(0xFFE6DFD5),
                            width: 64,
                            height: 48),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        width: 64,
                        height: 48,
                        color: const Color(0xFFE6DFD5),
                        child: const Icon(Icons.videocam_rounded,
                            color: textMuted, size: 20),
                      ),
                    ),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow_rounded,
                          color: Colors.white, size: 12),
                    ),
                  ],
                ),
              ),
            ),
            title: Text(
              video.judul ?? 'Tanpa Judul',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700, color: darkBrown, fontSize: 15),
            ),
            subtitle: Text(
              video.deskripsi ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(color: textMuted, fontSize: 12),
            ),
            trailing: Container(
              padding: const EdgeInsets.all(6),
              decoration:
                  const BoxDecoration(color: bgCanvas, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_forward_rounded,
                  size: 12, color: darkBrown),
            ),
            onTap: () => _openYoutube(video.youtubeUrl),
          ),
        );
      },
    );
  }

  void _openYoutube(String? url) async {
    if (url == null || url.isEmpty) return;
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'Tidak dapat membuka tautan YouTube',
          backgroundColor: darkBrown,
          colorText: accentGold,
          borderRadius: 12,
          margin: const EdgeInsets.all(16));
    }
  }

  // --- RENDERING TAB EVENT ---
  Widget _buildEventTab() {
    if (controller.eventResults.isEmpty) {
      return _buildEmptyOrErrorState(
          Icons.event_note_outlined,
          'Event Tidak Ditemukan',
          'Tidak ada jadwal agenda agenda event batik tegalan yang cocok dengan kata kunci Anda.',
          false);
    }
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: controller.eventResults.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, idx) {
        final event = controller.eventResults[idx];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: event.bannerImageUrl ?? '',
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer(
                  color: const Color(0xFFFAF7F2),
                  colorOpacity: 0.5,
                  duration: const Duration(milliseconds: 1200),
                  child: Container(
                      color: const Color(0xFFE6DFD5), width: 52, height: 52),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: const Color(0xFFE6DFD5),
                  child: const Icon(Icons.event_available_rounded,
                      color: textMuted, size: 22),
                ),
              ),
            ),
            title: Text(
              event.title ?? 'Tanpa Nama Event',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700, color: darkBrown, fontSize: 15),
            ),
            subtitle: Text(
              event.displayAddress,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                  color: textMuted, fontSize: 12, fontWeight: FontWeight.w500),
            ),
            trailing: Container(
              padding: const EdgeInsets.all(6),
              decoration:
                  const BoxDecoration(color: bgCanvas, shape: BoxShape.circle),
              child: const Icon(Icons.arrow_forward_ios_rounded,
                  size: 10, color: darkBrown),
            ),
            onTap: () => Get.toNamed('/event-detail', arguments: event),
          ),
        );
      },
    );
  }

  // --- PREMIUM ERROR & EMPTY STATE CODES ---
  Widget _buildEmptyOrErrorState(
      IconData icon, String title, String description, bool isErrorState) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isErrorState ? softRed : const Color(0xFFF2ECE0),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 36,
                color: isErrorState ? const Color(0xFFC2612D) : darkBrown,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: darkBrown,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: textMuted,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= INDUSTRIAL STANDARD: MULTI-LAYOUT SKELETON SHIMMER =================
  Widget _buildShimmerLoading() {
    const shimmerBg = Color(0xFFEFECE6);
    const maskColor = Color(0xFFE2DDD5);

    return Shimmer(
      color: const Color(0xFFFAF7F2),
      colorOpacity: 0.5,
      duration: const Duration(milliseconds: 1200),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return Container(
            height: 76,
            width: double.infinity,
            decoration: BoxDecoration(
              color: shimmerBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Leading Thumbnail Dummy
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: maskColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Teks Row Dummy
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 140,
                          height: 14,
                          decoration: BoxDecoration(
                            color: maskColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 80,
                          height: 11,
                          decoration: BoxDecoration(
                            color: maskColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Trailing Circle Dummy
                  Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: maskColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
