import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/models/informasi_model.dart'; // Pastikan import model baru

class InformasiDetailPage extends StatelessWidget {
  // Langsung ambil objek model yang dikirim lewat arguments
  final InformasiModel newsItem = Get.arguments;

  InformasiDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Header Gambar yang bisa di-scroll (SliverAppBar)
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
                tag:
                    'news_image_${newsItem.id}', // Gunakan ID unik untuk animasi Hero
                child: Image.network(
                  newsItem.imageUrl ?? '', // Gunakan URL dari API
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported, size: 50),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Berita
                  Text(
                    newsItem.title ?? 'Tanpa Judul',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown[800],
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Meta info (Kategori)
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.brown[600],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          newsItem.categori ?? 'Umum',
                          style: GoogleFonts.mulish(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.access_time,
                          size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        // Langsung panggil fungsi helper dari model
                        newsItem.timeAgo,
                        style: GoogleFonts.mulish(
                            color: Colors.grey[600], fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Isi Deskripsi
                  Text(
                    newsItem.deskripsi ?? 'Tidak ada deskripsi tersedia.',
                    style: GoogleFonts.mulish(
                      fontSize: 16,
                      color: Colors.grey[800],
                      height: 1.7,
                    ),
                    textAlign: TextAlign.justify,
                  ),

                  const SizedBox(height: 40),

                  // Tombol Aksi
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _showSnackbar(
                              'Share', 'Fitur bagikan akan segera hadir'),
                          icon: const Icon(Icons.share_outlined),
                          label: const Text('Bagikan'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown[600],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showSnackbar(
                              'Simpan', 'Artikel berhasil disimpan'),
                          icon: const Icon(Icons.bookmark_border_rounded),
                          label: const Text('Simpan'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.brown[600],
                            side: BorderSide(color: Colors.brown[600]!),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackbar(String title, String msg) {
    Get.snackbar(
      title,
      msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.brown[50],
      colorText: Colors.brown[900],
      margin: const EdgeInsets.all(15),
    );
  }
}
