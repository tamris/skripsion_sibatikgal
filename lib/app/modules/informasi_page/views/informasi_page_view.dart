import 'package:batikara/app/modules/informasi_page/widgets/informasi_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/views/news_detail_page.dart';
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Wrap(
                      spacing: 8,
                      children: controller.categories.map((cat) {
                        final selected =
                            controller.selectedCategory.value.isEmpty
                                ? cat == 'Semua'
                                : controller.selectedCategory.value == cat;
                        return ChoiceChip(
                          label: Text(cat,
                              style: const TextStyle(fontFamily: 'Poppins')),
                          selected: selected,
                          selectedColor: Colors.brown[100],
                          backgroundColor: Colors.white,
                          labelStyle: TextStyle(
                            color: selected
                                ? Colors.brown[800]
                                : Colors.brown[400],
                            fontWeight:
                                selected ? FontWeight.bold : FontWeight.normal,
                          ),
                          onSelected: (_) => controller.onCategoryChanged(cat),
                        );
                      }).toList(),
                    ),
                  ),
                  InformasiSearchBar(
                    onChanged: controller.onSearchChanged,
                  ),
                ],
              ),
            ),
            SliverList.separated(
              itemCount: controller.news.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final n = controller.news[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GestureDetector(
                    onTap: () => Get.to(() => NewsDetailPage(), arguments: i),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Gambar background
                            Image.asset(
                              n.image,
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                              errorBuilder: (_, __, ___) =>
                                  Container(color: const Color(0xFFF1F1F1)),
                            ),
                            // Gradient overlay
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.10),
                                    Colors.black.withOpacity(0.65),
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
                                    n.title,
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
                                    n.subtitle,
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
