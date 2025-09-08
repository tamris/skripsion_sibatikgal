import 'package:batikara/app/modules/galeri_page/widgets/batik_search.dart';
import 'package:batikara/app/modules/galeri_page/widgets/bottom_nav.dart';
import 'package:batikara/app/modules/galeri_page/widgets/courosel_galeri.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/galeri_page_controller.dart';

class GaleriPageView extends GetView<GaleriPageController> {
  const GaleriPageView({super.key});
  @override
  Widget build(BuildContext context) {
    final categories = [
      {'image': 'assets/images/Sekar Jagad.jpg', 'label': 'Modernism'},
      {'image': 'assets/images/Kembang Pacar.jpg', 'label': 'Impressionism'},
      {'image': 'assets/images/Poci Tahu Aci.jpg', 'label': 'Suprematism'},
      {'image': 'assets/images/Sidomulyo.jpg', 'label': 'Pop-art'},
      {'image': 'assets/images/Sidomulyo.jpg', 'label': 'Pop-art'},
    ];
    return Scaffold(
      bottomNavigationBar: const GaleriBottomNav(currentIndex: 1),
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          children: [
            // 🔧 Samakan padding dengan grid: 12
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 12, right: 12),
              child: Column(
                // 🔧 Biar anak-anak full width
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 🔧 Pastikan melebar penuh
                  SizedBox(
                    width: double.infinity,
                    child: BatikSearchBar(
                      onChanged: (query) => controller.onSearchChanged(query),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // 🔧 Pastikan carousel juga full width
                  const SizedBox(
                    width: double.infinity,
                    child: GalleryCarousel(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                // Grid sudah 12 → sekarang match
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: GridView.builder(
                  itemCount: categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 15,
                    childAspectRatio: 0.9,
                  ),
                  itemBuilder: (context, i) {
                    final cat = categories[i];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 2,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              cat['image']!,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            cat['label']!,
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
