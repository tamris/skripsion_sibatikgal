import 'package:batikara/app/modules/informasi_page/views/informasi_detail_page.dart';
import 'package:batikara/app/modules/informasi_page/widgets/informasi_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/informasi_page_controller.dart';

class InformasiPageView extends GetView<InformasiPageController> {
  const InformasiPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3EE), // nuansa mirip beranda
      appBar: AppBar(
        backgroundColor: Colors.brown[800],
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Informasi',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
      ),
      body: Obx(
        () => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  // MENGGUNAKAN PADDING DAN WRAP UNTUK TAMPILAN VERTIKAL
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Obx(() => Wrap(
                          spacing: 8.0, // Jarak horizontal antar chip
                          runSpacing: 4.0, // Jarak vertikal antar baris chip
                          children: controller.categories.map((cat) {
                            final selected =
                                controller.selectedCategory.value == cat ||
                                    (controller
                                            .selectedCategory.value.isEmpty &&
                                        cat == 'Semua');

                            return ChoiceChip(
                              label: Text(
                                cat,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: selected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: selected
                                      ? Colors.brown[800]
                                      : Colors.brown[400],
                                ),
                              ),
                              selected: selected,
                              selectedColor: Colors.brown[100],
                              backgroundColor: Colors.white,
                              pressElevation: 0,
                              side: BorderSide(
                                color: selected
                                    ? Colors.brown[300]!
                                    : Colors.transparent,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              onSelected: (_) =>
                                  controller.onCategoryChanged(cat),
                            );
                          }).toList(),
                        )),
                  ),
                  InformasiSearchBar(
                    onChanged: controller.onSearchChanged,
                  ),
                ],
              ),
            ),
            SliverList.separated(
              itemCount: controller.filteredNews.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final n = controller.filteredNews[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GestureDetector(
                    // Kirim data Map secara utuh atau ID-nya saja
                    onTap: () =>
                        Get.to(() => InformasiDetailPage(), arguments: n),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        height: 200,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Gunakan Image.network karena gambar berasal dari server
                            Image.network(
                              n.imageUrl ?? '',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  Container(color: Colors.grey[300]),
                            ),
                            // Gradient overlay
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withValues(alpha: 0.10),
                                    Colors.black.withValues(alpha: 0.65),
                                  ],
                                ),
                              ),
                            ),
                            // Teks
                            Positioned(
                              left: 18,
                              right: 18,
                              bottom: 18,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    n.title ?? 'Tanpa Judul',
                                    maxLines: 2,
                                    overflow: TextOverflow.clip,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      height: 1.2,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    n.deskripsi ?? 'Deskripsi tidak tersedia',
                                    maxLines: 2,
                                    overflow: TextOverflow.clip,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                      height: 1.3,
                                      fontFamily: 'Mulish',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
          ],
        ),
      ),
    );
  }
}
