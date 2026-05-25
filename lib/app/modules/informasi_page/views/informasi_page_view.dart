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
      backgroundColor: const Color(0xFFF7F3EE),
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
            // --- BAGIAN ATAS: CATEGORY CHIPS & SEARCH BAR ---
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: controller.categories.map((cat) {
                        final selected =
                            controller.selectedCategory.value == cat ||
                            (controller.selectedCategory.value.isEmpty &&
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
                          onSelected: (_) => controller.onCategoryChanged(cat),
                        );
                      }).toList(),
                    ),
                  ),
                  InformasiSearchBar(onChanged: controller.onSearchChanged),
                ],
              ),
            ),

            // --- BAGIAN KONTEN UTAMA (DENGAN ERROR HANDLING & LOADING STATE) ---
            if (controller.isLoading.value)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.brown),
                  ),
                ),
              )
            else if (controller.isError.value)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wifi_off_rounded,
                        size: 64,
                        color: Colors.brown[300],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Oops! Terjadi Kendala',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        controller.errorMessage.value,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => controller.loadInformasi(),
                        icon: const Icon(
                          Icons.refresh_rounded,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Coba Lagi',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown[700],
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (controller.filteredNews.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    'Tidak ada informasi mengenai motif ini.',
                    style: GoogleFonts.poppins(color: Colors.grey[600]),
                  ),
                ),
              )
            else
              // Render List Artikel jika semuanya sukses
              SliverList.separated(
                itemCount: controller.filteredNews.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final n = controller.filteredNews[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GestureDetector(
                      onTap: () =>
                          Get.to(() => InformasiDetailPage(), arguments: n),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SizedBox(
                          height: 200,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                n.imageUrl ?? '',
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.broken_image_rounded,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
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