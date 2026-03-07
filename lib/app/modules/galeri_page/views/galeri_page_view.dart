import 'package:batikara/app/modules/galeri_page/views/batik_detail.dart';
import 'package:batikara/app/modules/galeri_page/widgets/batik_search.dart';
import 'package:batikara/app/modules/galeri_page/widgets/courosel_galeri.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/galeri_page_controller.dart';

class GaleriPageView extends GetView<GaleriPageController> {
  const GaleriPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F5F2),
        foregroundColor: Colors.black,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Galeri Batik',
          style: GoogleFonts.lora(fontWeight: FontWeight.w800, fontSize: 28),
        ),
      ),
      backgroundColor: const Color(0xFFF7F5F2),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 12, right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: BatikSearchBar(
                      onChanged: (query) => controller.onSearchChanged(query),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const SizedBox(
                    // width: double.infinity,
                    child: GalleryCarousel(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Obx(() {
                  // Tambahkan Loading State agar user tahu data sedang diambil
                  if (controller.isLoading.value) {
                    return const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFF8A5A44)),
                    );
                  }

                  // Gunakan filteredBatik agar fitur pencarian berfungsi
                  final displayList = controller.filteredBatik;

                  if (displayList.isEmpty) {
                    return Center(
                      child: Text(
                        "Motif tidak ditemukan",
                        style: GoogleFonts.poppins(color: Colors.grey),
                      ),
                    );
                  }

                  return GridView.builder(
                    itemCount: displayList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.86,
                    ),
                    itemBuilder: (context, i) {
                      final cat = displayList[i];

                      return InkWell(
                        borderRadius: BorderRadius.circular(22),
                        overlayColor:
                            const WidgetStatePropertyAll(Colors.transparent),
                        splashColor: Colors.black12,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          Get.to(() => BatikDetailPage(), arguments: cat);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: const Color(0xFFE7EAEE)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              AspectRatio(
                                aspectRatio: 1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: Hero(
                                    tag: 'batik_image_${cat.image}',
                                    // PERBAIKAN: Gunakan Image.network karena data dari API
                                    child: Image.network(
                                      cat.image,
                                      fit: BoxFit.cover,
                                      // Handler jika gambar error/gagal load
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey[200],
                                          child: const Icon(
                                              Icons.image_not_supported,
                                              color: Colors.grey),
                                        );
                                      },
                                      frameBuilder:
                                          (ctx, child, frame, wasSync) {
                                        if (wasSync) return child;
                                        return AnimatedOpacity(
                                          opacity: frame == null ? 0 : 1,
                                          duration:
                                              const Duration(milliseconds: 250),
                                          child: child,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                cat.title,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.lora(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
