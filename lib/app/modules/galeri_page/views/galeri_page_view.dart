import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/galeri_page_controller.dart';
import 'galeri_detail_view.dart';

class GaleriPageView extends GetView<GaleriPageController> {
  const GaleriPageView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color bgPrimary = Color(0xFFFAF6F0);
    const Color textDark = Color(0xFF3E2723);
    const Color textLight = Color(0xFFFFD264);
    const Color searchBg = Color(0xFFF0EAD8);
    const Color activeTabColor = Color(0xFF1A1208);
    const Color inactiveTabColor = Color(0xFFF0EAD8);

    return Scaffold(
      backgroundColor: bgPrimary,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Header Row (Diberi padding horizontal)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Galeri Motif Batik',
                    style: GoogleFonts.lora(
                      color: textDark,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Obx(
                    () => Text(
                      '${controller.totalBatikCount.value} koleksi motif',
                      style: GoogleFonts.lora(
                        color: textDark.withValues(alpha: 0.6),
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Search Bar (Diberi padding horizontal)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                onChanged: (value) => controller.searchBatik(value),
                decoration: InputDecoration(
                  hintText: 'Cari motif batik...',
                  hintStyle: GoogleFonts.poppins(
                    color: textDark.withValues(alpha: 0.5),
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(Icons.search, color: textDark),
                  filled: true,
                  fillColor: searchBg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Kategori Tab - Menggunakan Scrollable Horizontal
            Obx(
              () => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: controller.categories.map((category) {
                    bool isSelected =
                        controller.selectedCategory.value == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: InkWell(
                        onTap: () => controller.filterByCategory(category),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected ? activeTabColor : inactiveTabColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            category == 'Semua'
                                ? category
                                : category[0].toUpperCase() +
                                    category.substring(1),
                            style: GoogleFonts.poppins(
                              color: isSelected ? textLight : textDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Grid List Motif Batik + Load More Indicator + Error & Refresh Handling
            Expanded(
              child: Obx(() {
                // 1. KONDISI JIKA SEDANG LOADING UTAMA (AWAL BUKA)
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: activeTabColor),
                  );
                }

                // 2. KONDISI JIKA JARINGAN ERROR ATAU SERVER DOWN
                if (controller.isError.value) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.wifi_off_rounded,
                            size: 64,
                            color: textDark,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Oops! Terjadi Kendala',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: textDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tidak ada koneksi internet. Pastikan Anda terhubung ke jaringan.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: textDark.withValues(alpha: 0.6),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: activeTabColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            onPressed: () => controller.refreshData(),
                            icon: const Icon(Icons.refresh_rounded),
                            label: Text(
                              'Muat Ulang',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // 3. KONDISI JIKA DATA FILTER KOSONG
                if (controller.filteredBatikList.isEmpty) {
                  return RefreshIndicator(
                    color: activeTabColor,
                    backgroundColor: Colors.white,
                    onRefresh: () => controller.refreshData(),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Center(
                          child: Text(
                            'Motif tidak ditemukan',
                            style: GoogleFonts.poppins(
                              color: textDark.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                // 4. KONDISI NORMAL (DATA BERHASIL DIMUAT JALAN JALAN)
                return RefreshIndicator(
                  color: activeTabColor,
                  backgroundColor: Colors.white,
                  onRefresh: () => controller.refreshData(),
                  child: Column(
                    children: [
                      Expanded(
                        child: GridView.builder(
                          controller: controller.scrollController,
                          itemCount: controller.filteredBatikList.length,
                          // Menggunakan AlwaysScrollableScrollPhysics agar pull-to-refresh tetap aktif walau item sedikit
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            right: 20.0,
                            bottom: 10.0,
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            childAspectRatio: 0.72,
                          ),
                          itemBuilder: (context, index) {
                            final batik = controller.filteredBatikList[index];

                            return InkWell(
                              onTap: () {
                                Get.to(() => GaleriDetailView(batik: batik));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.02,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Image Container
                                    Expanded(
                                      flex: 3,
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                            top: Radius.circular(20),
                                          ),
                                          child: Stack(
                                            children: [
                                              Positioned.fill(
                                                child: batik.image.isNotEmpty
                                                    ? Image.network(
                                                        batik.image,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (
                                                          c,
                                                          e,
                                                          s,
                                                        ) =>
                                                            Container(
                                                          color:
                                                              Colors.grey[200],
                                                          child: const Icon(
                                                            Icons.broken_image,
                                                            size: 40,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        color: Colors.grey[200],
                                                        child: const Icon(
                                                          Icons.image,
                                                          size: 40,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Text Info Container
                                    Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0,
                                          vertical: 8.0,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              batik.title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                color: textDark,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              batik.category,
                                              style: GoogleFonts.poppins(
                                                color: textDark.withValues(
                                                  alpha: 0.6,
                                                ),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Indikator Loading Tambahan di bawah grid saat proses Load More (Infinite Scroll) jalan
                      Obx(() {
                        if (controller.isLoadMore.value) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: activeTabColor,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
