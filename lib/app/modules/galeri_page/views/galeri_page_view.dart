import 'package:batikara/app/modules/galeri_page/widgets/batik_search.dart';
import 'package:batikara/app/modules/galeri_page/widgets/bottom_nav.dart';
import 'package:batikara/app/modules/galeri_page/widgets/courosel_galeri.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/galeri_page_controller.dart';

class GaleriPageView extends GetView<GaleriPageController> {
  const GaleriPageView({super.key});
  @override
  Widget build(BuildContext context) {
    final categories = [
      {'image': 'assets/images/Sekar Jagad.jpg', 'label': 'Sekar Jagad'},
      {'image': 'assets/images/Kembang Pacar.jpg', 'label': 'Kembang Pacar'},
      {'image': 'assets/images/Poci Tahu Aci.jpg', 'label': 'Poci Tahu Aci'},
      {'image': 'assets/images/Sidomulyo.jpg', 'label': 'Sidomulyo'},
      {'image': 'assets/images/Sekar Jagad.jpg', 'label': 'Sekar Jagad'},
      {'image': 'assets/images/Kembang Pacar.jpg', 'label': 'Kembang Pacar'},
      {'image': 'assets/images/Poci Tahu Aci.jpg', 'label': 'Poci Tahu Aci'},
      {'image': 'assets/images/Sidomulyo.jpg', 'label': 'Sidomulyo'},
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F5F2),
        foregroundColor: const Color(0xFF8A5A44),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Galeri Batik',
          style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
        ),
      ),
      bottomNavigationBar: const GaleriBottomNav(currentIndex: 1),
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
                    width: double.infinity,
                    child: GalleryCarousel(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: GridView.builder(
                  itemCount: categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio:
                        0.86, // sedikit lebih “kotak” seperti contoh
                  ),
                  itemBuilder: (context, i) {
                    final cat = categories[i];

                    return InkWell(
                      borderRadius: BorderRadius.circular(22),
                      onTap: () {}, // TODO: aksi jika diklik
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                              color: const Color(0xFFE7EAEE)), // outline tipis
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // gambar kotak dengan sudut bulat (seperti contoh)
                            AspectRatio(
                              aspectRatio: 1, // kotak
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Image.asset(
                                  cat['image']!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // label center, bold tipis
                            Text(
                              cat['label']!,
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
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
