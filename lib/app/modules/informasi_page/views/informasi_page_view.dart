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
    // Palet warna premium konsisten Batikara
    const bgCanvas = Color(0xFFFAF7F2);
    const darkBrown = Color(0xFF1C1308);
    const textMuted = Color(0xFF7A7062);
    const accentGold = Color(0xFFFBBF24);
    const borderColor = Color(0xFFE6DFD5);

    return Scaffold(
      backgroundColor: bgCanvas,
      // ================= FIXED APP BAR DENGAN TOMBOL BACK =================
      appBar: AppBar(
        backgroundColor: bgCanvas,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        // Tombol Back dikembalikan secara kustom dan rapi bro!
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Center(
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.all(10),
                child: const Icon(Icons.arrow_back_rounded,
                    color: darkBrown, size: 20),
              ),
            ),
          ),
        ),
        title: Text(
          'Informasi',
          style: GoogleFonts.lora(
            color: darkBrown,
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
        ),
        surfaceTintColor: Colors.transparent,
      ),

      body: Obx(
        () => CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // --- BAGIAN ATAS: SEARCH BAR & CATEGORY CHIPS ---
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Memanggil search bar kustom baru yang sudah kita sesuaikan di atas
                  InformasiSearchBar(onChanged: controller.onSearchChanged),

                  // Horizontal Scrolling Kategori Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                    child: Row(
                      children: controller.categories.map((cat) {
                        final selected =
                            controller.selectedCategory.value == cat ||
                                (controller.selectedCategory.value.isEmpty &&
                                    cat == 'Semua');

                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(cat),
                            labelStyle: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight:
                                  selected ? FontWeight.w700 : FontWeight.w500,
                              color: selected ? accentGold : textMuted,
                            ),
                            selected: selected,
                            selectedColor: darkBrown,
                            backgroundColor: Colors.white,
                            pressElevation: 0,
                            side: BorderSide(
                              color: selected ? darkBrown : borderColor,
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            onSelected: (_) =>
                                controller.onCategoryChanged(cat),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            // --- BAGIAN KONTEN UTAMA ---
            if (controller.isLoading.value)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(darkBrown),
                  ),
                ),
              )
            else if (controller.isError.value)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFCE8E6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.wifi_off_rounded,
                          size: 44,
                          color: Color(0xFFC2612D),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Oops! Terjadi Kendala',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: darkBrown,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        controller.errorMessage.value,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: textMuted,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => controller.loadInformasi(),
                        icon: const Icon(Icons.refresh_rounded,
                            color: Colors.white, size: 18),
                        label: Text(
                          'Coba Lagi',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: darkBrown,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
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
                    style: GoogleFonts.poppins(
                      color: textMuted,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
            else
              // Render List Artikel Premium
              SliverList.separated(
                itemCount: controller.filteredNews.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, i) {
                  final n = controller.filteredNews[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: () =>
                          Get.to(() => InformasiDetailPage(), arguments: n),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: darkBrown.withOpacity(0.04),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: SizedBox(
                            height: 210,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  n.imageUrl ?? '',
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: const Color(0xFFE6DFD5),
                                    child: const Icon(
                                      Icons.broken_image_rounded,
                                      color: textMuted,
                                      size: 32,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.05),
                                        Colors.black.withOpacity(0.75),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 20,
                                  right: 20,
                                  bottom: 20,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        n.title ?? 'Tanpa Judul',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          height: 1.3,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        n.deskripsi ??
                                            'Deskripsi tidak tersedia',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          color: Colors.white.withOpacity(0.75),
                                          fontSize: 12,
                                          height: 1.4,
                                          fontWeight: FontWeight.w400,
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
                    ),
                  );
                },
              ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}
