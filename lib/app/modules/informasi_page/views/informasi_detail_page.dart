import 'package:batikara/app/data/models/informasi_model.dart';
import 'package:batikara/app/modules/informasi_page/widgets/related_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/informasi_page_controller.dart';

class InformasiDetailPage extends StatelessWidget {
  const InformasiDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InformasiPageController>();
    final InformasiModel info = Get.arguments;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- TOP BAR ---
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTopBarButton(Icons.arrow_back, () => Get.back()),
                    Text(
                      "Detail Artikel",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildTopBarButton(
                      Icons.share_outlined,
                      () => controller.shareArtikel(info),
                    ),
                  ],
                ),
              ),
              const Divider(),

              // --- CONTENT ---
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Badge Kategori
                    _buildCategoryBadge(info.categori ?? "Event"),
                    const SizedBox(height: 12),

                    // Judul
                    Text(
                      info.title ?? "",
                      style: GoogleFonts.lora(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF333333),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Info Author / Admin
                    _buildAuthorRow(info),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),

                    // Gambar Utama
                    _buildMainImage(info.imageUrl),
                    const SizedBox(height: 20),

                    // Deskripsi
                    Text(
                      info.deskripsi ?? "",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.mulish(
                        fontSize: 16,
                        color: const Color(0xFF666666),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    const SizedBox(height: 15),

                    // --- SECTION ARTIKEL TERKAIT ---
                    Text(
                      "Artikel Terkait",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Obx(() {
                      var relatedItems = controller.getRelatedItems(
                        info.id!,
                        info.categori,
                      );
                      List<Color> bgColors = [
                        const Color(0xFFFDECE8),
                        const Color(0xFFE8F3E8),
                        const Color(0xFFE8EEF3),
                      ];

                      if (relatedItems.isEmpty) {
                        return const Text(
                          "Tidak ada artikel terkait lainnya.",
                          style: TextStyle(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: relatedItems.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          return RelatedCardWidget(
                            item: relatedItems[index],
                            baseColor: bgColors[index % bgColors.length],
                          );
                        },
                      );
                    }),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- HELPER COMPONENT WIDGETS (Agar build utama tetap clean) ---
  Widget _buildTopBarButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF5EFE1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 20, color: const Color(0xFFB08968)),
      ),
    );
  }

  Widget _buildCategoryBadge(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFDECE8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        category,
        style: GoogleFonts.poppins(
          color: const Color(0xFFD48166),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildAuthorRow(InformasiModel info) {
    return Row(
      children: [
        CircleAvatar(
          radius: 17,
          backgroundColor: const Color(0xFFB08968),
          child: Text(
            // Inisial dinamis (Contoh: "Ahmad Dani" otomatis jadi "AD")
            info.authorInitial,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          info.authorName ?? "Admin Batik Tegal",
          style: GoogleFonts.poppins(
            color: Colors.grey[600],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
        const SizedBox(width: 5),
        Text(
          info.timeAgo,
          style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildMainImage(String? url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: double.infinity,
        height: 200,
        color: const Color(0xFFF5EFE1),
        child: url != null && url.isNotEmpty
            ? Image.network(url, fit: BoxFit.cover)
            : const Icon(Icons.image_outlined, size: 80, color: Colors.white38),
      ),
    );
  }
}