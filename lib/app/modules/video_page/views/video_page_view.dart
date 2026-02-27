import 'package:batikara/app/modules/video_page/controllers/video_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class VideoPageView extends GetView<VideoPageController> {
  const VideoPageView({super.key});

  String _extractId(String? url) {
    if (url == null || url.isEmpty) return '';
    try {
      final uri = Uri.parse(url);
      if (uri.host.contains('youtu.be')) {
        return uri.pathSegments.first;
      } else if (uri.host.contains('youtube.com')) {
        return uri.queryParameters['v'] ?? '';
      }
    } catch (e) {
      return '';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3EE),
      appBar: AppBar(
        title: Text('Video Batik',
            style: GoogleFonts.lora(
                fontWeight: FontWeight.w600, color: Colors.white)),
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.brown[800],
        centerTitle: true,
      ),
      // MENGGUNAKAN CustomScrollView AGAR SEARCH & KATEGORI BISA DI-SCROLL
      body: CustomScrollView(
        slivers: [
          // 1. BAGIAN SEARCH & KATEGORI
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // SEARCH BAR
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari edukasi video batik...',
                      hintStyle: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Colors.brown.withValues(alpha: 0.5),
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 255, 246, 241),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 20),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide:
                            BorderSide(color: Colors.grey.shade300, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                            color: Color(0xFF8A5A44), width: 1.5),
                      ),
                      prefixIcon: Icon(Icons.search,
                          color: Colors.brown.withValues(alpha: 0.7)),
                    ),
                    onChanged: (value) => controller
                        .onSearchChanged(value), // Hubungkan ke controller
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 16),
                  ),
                ),
                const SizedBox(height: 12),
                // WRAP KATEGORI (Vertikal Adaptif sesuai kemauanmu)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Obx(() => Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: controller.categories.map((cat) {
                          final isSelected =
                              controller.selectedCategory.value == cat;
                          return ChoiceChip(
                            label: Text(cat,
                                style: GoogleFonts.poppins(fontSize: 12)),
                            selected: isSelected,
                            selectedColor: Colors.brown[100],
                            backgroundColor: Colors.white,
                            onSelected: (_) =>
                                controller.onCategoryChanged(cat),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          );
                        }).toList(),
                      )),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // 2. DAFTAR VIDEO (Mengambil desain asli kamu)
          Obx(() {
            if (controller.isLoading.value) {
              return SliverFillRemaining(
                child: Center(
                  child: Lottie.asset(
                    'assets/lottie/Trail loading.json',
                    width: 150,
                    height: 150,
                    repeat: true,
                  ),
                ),
              );
            }

            // Gunakan filteredVideos agar fungsi search & kategori jalan
            final videos = controller.filteredVideos;

            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final video = videos[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10)
                        ],
                      ),
                      child: Column(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16)),
                                child: Image.network(
                                  video.getYoutubeThumbnail,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Image.network(
                                    'https://img.youtube.com/vi/${_extractId(video.youtubeUrl)}/hqdefault.jpg',
                                    height: 200,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      height: 200,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.broken_image,
                                          size: 50),
                                    ),
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor:
                                    Colors.white.withValues(alpha: 0.9),
                                radius: 30,
                                child: Icon(Icons.play_arrow_rounded,
                                    size: 40, color: Colors.brown[800]),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Menampilkan Kategori di atas judul
                                Text(
                                  video.kategori?.toUpperCase() ?? 'UMUM',
                                  style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown[400]),
                                ),
                                const SizedBox(height: 4),
                                Text(video.judul ?? 'Video Batik',
                                    style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 6),
                                Text(video.deskripsi ?? '',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.mulish(
                                        fontSize: 14, color: Colors.grey[600])),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(Icons.schedule,
                                        size: 14, color: Colors.brown[400]),
                                    const SizedBox(width: 4),
                                    Text(video.timeAgo,
                                        style: TextStyle(
                                            color: Colors.brown[400],
                                            fontSize: 12)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: videos.length,
                ),
              ),
            );
          }),
          // Padding bawah ekstra agar tidak mentok
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}
