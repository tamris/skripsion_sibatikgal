import 'package:batikara/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewsDetailPage extends StatelessWidget {
  final HomeController homeController = Get.find<HomeController>();
  final int newsIndex = Get.arguments ?? 0;

  @override
  Widget build(BuildContext context) {
    final newsItem = homeController.news[newsIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
              expandedHeight: 350.0,
              floating: false,
              pinned: true,
              backgroundColor: Colors.brown[800],
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Get.back(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: 'news_image_$newsIndex',
                  child: AspectRatio(
                    aspectRatio: 16 / 9, // atau sesuai rasio gambar Anda
                    child: Image.asset(
                      newsItem.image,
                      fit: BoxFit.fill, // paksa full, tapi bisa distorsi
                      width: double.infinity,
                    ),
                  ),
                ),
              )),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    newsItem.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[800],
                      height: 1.3,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 16),

                  // Meta info (kategori dan tanggal)
                  Row(
                    children: [
                      // Kategori
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.brown[600],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          newsItem.categori,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Mulish',
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      // Tanggal
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          SizedBox(width: 4),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Deskripsi
                  if (newsItem.deskripsi.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      newsItem.deskripsi,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                        height: 1.6,
                        fontFamily: 'Mulish',
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ] else ...[
                    // Jika deskripsi kosong, tampilkan placeholder
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.article_outlined,
                            size: 48,
                            color: Colors.grey[500],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Deskripsi detail akan segera tersedia',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontFamily: 'Mulish',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 30),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.snackbar(
                              'Share',
                              'Fitur share akan segera tersedia',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.brown[100],
                              colorText: Colors.brown[800],
                            );
                          },
                          icon: const Icon(Icons.share),
                          label: const Text(
                            'Share',
                            style: TextStyle(fontFamily: 'Mulish'),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown[600],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Get.snackbar(
                              'Bookmark',
                              'Artikel telah disimpan',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green[100],
                              colorText: Colors.green[800],
                            );
                          },
                          icon: const Icon(Icons.bookmark_border),
                          label: const Text(
                            'Simpan',
                            style: TextStyle(fontFamily: 'Mulish'),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.brown[600],
                            side: BorderSide(color: Colors.brown[600]!),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
