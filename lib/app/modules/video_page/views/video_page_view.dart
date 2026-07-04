import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/video_page_controller.dart';
import '../../../data/models/video_model.dart';

class VideoPageView extends GetView<VideoPageController> {
  const VideoPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EEE6),
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
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 4),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Back arrow aligned to the left
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Container(
                width: 40,
                height: 40,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.arrow_back, size: 20),
                  color: const Color(0xFF1A1814),
                  onPressed: () => Get.back(),
                ),
              ),
            ),
          ),
          // Centered title column
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'JELAJAHI',
                style: GoogleFonts.lora(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: Colors.brown.shade400,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Video Batik',
                style: GoogleFonts.lora(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1814),
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
          border: Border.all(color: const Color(0xFFE0D8CC), width: 1.5),
        ),
        child: TextField(
          controller: controller.searchController,
          onChanged: controller.onSearch,
          style: GoogleFonts.poppins(fontSize: 14, color: Color(0xFF1A1814)),
          decoration: InputDecoration(
            hintText: 'Cari video batik...',
            hintStyle: GoogleFonts.poppins(
              fontSize: 14,
              color: Color(0xFFB8A890),
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: Color(0xFFB8A890),
              size: 20,
            ),
            suffixIcon: Obx(
              () => controller.searchQuery.value.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Color(0xFFB8A890),
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
        child: Obx(
          () => Row(
            children: controller.kategoriList.map((k) {
              final isSelected = controller.selectedKategori.value == k;
              return GestureDetector(
                onTap: () => controller.setKategori(k),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF1A1814)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF1A1814)
                          : const Color(0xFFDDD5C4),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    k,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? const Color(0xFFFFD264)
                          : const Color(0xFF1A1208),
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
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFFC47828)),
        );
      }

      if (controller.filteredVideos.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.videocam_off_outlined,
                size: 52,
                color: Colors.brown.shade200,
              ),
              const SizedBox(height: 12),
              Text(
                'Belum ada video tersedia',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.brown.shade300,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        color: const Color(0xFF1A1208),
        onRefresh: controller.fetchVideos,
        child: ListView.builder(
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
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1814),
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Thumbnail ──────────────────────────────────────────────────
            Stack(
              children: [
                // Thumbnail image
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: video.getThumbnail.isNotEmpty
                      ? Image.network(
                          video.getThumbnail,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _thumbnailPlaceholder(),
                        )
                      : _thumbnailPlaceholder(),
                ),
                // Gradient overlay
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
                // Play button tengah
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
                // Durasi pill kanan bawah
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
                // YouTube pill kiri atas
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
                        Icon(
                          Icons.play_circle_fill,
                          color: Colors.red,
                          size: 12,
                        ),
                        SizedBox(width: 4),
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
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge kategori + views
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
                              color: Color(0xFFC47828),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              video.formattedViews,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFC47828),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Judul
                  Text(
                    video.judul ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFFF3EEE6),
                      height: 1.6,
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 7),
                  // Channel + durasi
                  Row(
                    children: [
                      if (video.channelName != null) ...[
                        const Icon(
                          Icons.person_outline,
                          size: 13,
                          color: Color(0x66F3EEE6),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            video.channelName!,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Color(0x66F3EEE6),
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

  // ── Badge warna per kategori ───────────────────────────────────────────────
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
          fontWeight: FontWeight.w800,
          color: c[1],
        ),
      ),
    );
  }

  // ── Placeholder thumbnail ──────────────────────────────────────────────────
  Widget _thumbnailPlaceholder() {
    return Container(
      color: const Color(0xFF2E1A08),
      child: const Center(
        child: Icon(
          Icons.play_circle_outline,
          color: Color(0x44F3EEE6),
          size: 40,
        ),
      ),
    );
  }

  // ── Buka YouTube ──────────────────────────────────────────────────────────
  Future<void> _openYoutube(String? url) async {
    if (url == null || url.isEmpty) return;
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (_) {
      // Fallback: buka di browser in-app
      try {
        await launchUrl(Uri.parse(url), mode: LaunchMode.inAppWebView);
      } catch (e) {
        Get.snackbar(
          'Error',
          'Tidak bisa membuka YouTube',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }
}
