import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Paket cache gambar premium
import 'package:shimmer_animation/shimmer_animation.dart'; // Paket shimmer andalanmu
import '../controllers/video_page_controller.dart';
import '../../../data/models/video_model.dart';

class VideoPageView extends GetView<VideoPageController> {
  const VideoPageView({super.key});

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
            _buildSearchBar(),
            _buildChips(),
            Expanded(child: _buildVideoList()),
          ],
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 4),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Container(
                width: 42,
                height: 42,
                child: Center(
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.arrow_back_rounded, size: 20),
                    color: darkBrown,
                    onPressed: () => Get.back(),
                  ),
                ),
              ),
            ),
          ),
          Column(
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
                'Video Batik',
                style: GoogleFonts.lora(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: darkBrown,
                  height: 1.15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Search bar ─────────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: borderColor, width: 1.0),
        ),
        child: TextField(
          controller: controller.searchController,
          onChanged: controller.onSearch,
          cursorColor: darkBrown,
          style: GoogleFonts.poppins(
              fontSize: 14, color: darkBrown, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: 'Cari video batik...',
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: textMuted.withOpacity(0.5),
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: textMuted.withOpacity(0.7),
              size: 20,
            ),
            suffixIcon: Obx(
              () => controller.searchQuery.value.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: textMuted.withOpacity(0.7),
                        size: 18,
                      ),
                      onPressed: controller.clearSearch,
                    )
                  : const SizedBox.shrink(),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 4,
            ),
          ),
        ),
      ),
    );
  }

  // ── Chip filter kategori ───────────────────────────────────────────────────
  Widget _buildChips() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 0, 14),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Obx(
          () => Row(
            children: controller.kategoriList.map((k) {
              final isSelected = controller.selectedKategori.value == k;
              return GestureDetector(
                onTap: () => controller.setKategori(k),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? darkBrown : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? darkBrown : borderColor,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    k,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? accentGold : textMuted,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // ── List video ─────────────────────────────────────────────────────────────
  Widget _buildVideoList() {
    return Obx(() {
      // 1. KONDISI LOADING: Menggunakan Multi-Layout Industrial Skeleton Shimmer
      if (controller.isLoading.value) {
        return _buildShimmerLoading();
      }

      // 2. KONDISI ERROR: Memakai format message global premium yang seragam
      if (controller.isError.value) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
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
                    onPressed: () => controller.fetchVideos(),
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
        );
      }

      // 3. KONDISI EMPTY STATE
      if (controller.filteredVideos.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFFF2ECE0),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.videocam_off_outlined,
                    size: 30, color: darkBrown),
              ),
              const SizedBox(height: 20),
              Text(
                'Belum ada video tersedia',
                style: GoogleFonts.lora(
                  fontSize: 18,
                  color: darkBrown,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Coba ubah kata kunci pencarian Anda',
                style: GoogleFonts.poppins(fontSize: 13, color: textMuted),
              ),
            ],
          ),
        );
      }

      // 4. KONDISI BERHASIL MEMUAT DATA
      return RefreshIndicator(
        color: darkBrown,
        backgroundColor: Colors.white,
        onRefresh: controller.fetchVideos,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          itemCount: controller.filteredVideos.length,
          itemBuilder: (context, index) {
            return _buildVideoCard(controller.filteredVideos[index]);
          },
        ),
      );
    });
  }

  // ── Video card (Style B — dark) ────────────────────────────────────────────
  Widget _buildVideoCard(VideoModel video) {
    return GestureDetector(
      onTap: () => _openYoutube(video.youtubeUrl),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1814),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: darkBrown.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 6),
            )
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Thumbnail dengan CachedNetworkImage + Shimmer Internal ──
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: video.getThumbnail.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: video.getThumbnail,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer(
                            color: const Color(0xFFFAF7F2),
                            colorOpacity: 0.5,
                            duration: const Duration(milliseconds: 1500),
                            child: Container(color: const Color(0xFFE6DFD5)),
                          ),
                          errorWidget: (_, __, ___) => _thumbnailPlaceholder(),
                        )
                      : _thumbnailPlaceholder(),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.4),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.38),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
                if (video.formattedDuration.isNotEmpty)
                  Positioned(
                    bottom: 8,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.65),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        video.formattedDuration,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 8,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.play_circle_fill,
                          color: Colors.red,
                          size: 12,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'YouTube',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ── Info ───────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildBadge(video.kategori ?? ''),
                      if (video.formattedViews.isNotEmpty)
                        Row(
                          children: [
                            const Icon(
                              Icons.remove_red_eye_outlined,
                              size: 12,
                              color: Color(0xFFFBBF24),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              video.formattedViews,
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFFFBBF24)),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    video.judul ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFFAF7F2),
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (video.channelName != null) ...[
                        const Icon(
                          Icons.person_outline_rounded,
                          size: 13,
                          color: Color(0x88FAF7F2),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            video.channelName!,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: const Color(0x88FAF7F2),
                              fontWeight: FontWeight.w400,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String kategori) {
    final Map<String, List<Color>> colors = {
      'Edukasi': [const Color(0x38204A80), const Color(0xFF60A0F0)],
      'Event': [const Color(0x38802020), const Color(0xFFF06060)],
      'Tutorial': [const Color(0x38C47828), const Color(0xFFE89840)],
      'Sejarah': [const Color(0x38306010), const Color(0xFF80C040)],
      'Motif & Makna': [const Color(0x385A2A80), const Color(0xFFC080F0)],
    };
    final c =
        colors[kategori] ?? [const Color(0x38808080), const Color(0xFFB0B0B0)];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: c[0],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        kategori,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: c[1],
        ),
      ),
    );
  }

  Widget _thumbnailPlaceholder() {
    return Container(
      color: const Color(0xFF2E1A08),
      child: const Center(
        child: Icon(
          Icons.play_circle_outline_rounded,
          color: Color(0x44FAF7F2),
          size: 40,
        ),
      ),
    );
  }

  Future<void> _openYoutube(String? url) async {
    if (url == null || url.isEmpty) return;
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (_) {
      try {
        await launchUrl(Uri.parse(url), mode: LaunchMode.inAppWebView);
      } catch (e) {
        Get.snackbar(
          'Error',
          'Tidak bisa membuka YouTube',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: darkBrown,
          colorText: accentGold,
        );
      }
    }
  }

  // ================= INDUSTRIAL STANDARD: VIDEO MULTI-LAYOUT SKELETON SHIMMER =================
  Widget _buildShimmerLoading() {
    const shimmerBg = Color(0xFFEFECE6);
    const maskColor = Color(0xFFE2DDD5);

    return Shimmer(
      color: const Color(0xFFFAF7F2),
      colorOpacity: 0.5,
      duration: const Duration(milliseconds: 1200),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        itemCount: 2, // Merender 2 bodi video card tiruan industri
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: shimmerBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Replikasi Rasio Thumbnail Gambar (16:9)
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      color: maskColor,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(19)),
                    ),
                    child: Center(
                      // Tombol play tiruan di tengah area gambar
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: shimmerBg.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),

                // 2. Replikasi Area Info Teks Card Bawah
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge tiruan
                      Container(
                        width: 70,
                        height: 18,
                        decoration: BoxDecoration(
                          color: maskColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Baris Judul Pertama (Panjang)
                      Container(
                        width: double.infinity,
                        height: 14,
                        decoration: BoxDecoration(
                          color: maskColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Baris Judul Kedua (Pendek)
                      Container(
                        width: 160,
                        height: 14,
                        decoration: BoxDecoration(
                          color: maskColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Baris Channel info
                      Container(
                        width: 110,
                        height: 10,
                        decoration: BoxDecoration(
                          color: maskColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
