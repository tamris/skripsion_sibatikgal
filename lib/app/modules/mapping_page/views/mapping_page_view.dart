import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:batikara/app/data/config/app_config.dart';
import 'package:batikara/app/data/models/mapping_model.dart';
import 'package:batikara/app/modules/mapping_page/widgets/shared_components.dart';
import 'package:batikara/app/routes/app_pages.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer_animation/shimmer_animation.dart'; // Impor paket shimmer andalanmu
import '../controllers/mapping_page_controller.dart';

class MappingPageView extends GetView<MappingPageController> {
  const MappingPageView({super.key});

  @override
  Widget build(BuildContext context) {
    // Palet warna premium konsisten Batikara global
    const colorBackground = Color(0xFFF7F5EE);
    const colorPrimaryDark = Color(0xFF1A1208);
    const colorAccentOrange = Color(0xFFD35400);
    const Color cGold = Color(0xFFFFD264);
    const Color borderColor = Color(0xFFE6DFD5);

    return Scaffold(
      backgroundColor: colorBackground,
      body: Obx(() {
        // 1. STATE LOADING UTAMA HALAMAN: Menggunakan Full Skeleton Shimmer Card Premium
        if (controller.isLoading.value) {
          return _buildFullPageShimmer(borderColor);
        }

        return Stack(
          children: [
            FlutterMap(
              mapController: controller.mapController,
              options: MapOptions(
                initialCenter: controller.mapCenter.value,
                initialZoom: 14.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.your_app.batik_tegalan',
                ),
                MarkerLayer(
                  markers: [
                    if (controller.userPosition.value != null)
                      Marker(
                        point: LatLng(
                          controller.userPosition.value!.latitude,
                          controller.userPosition.value!.longitude,
                        ),
                        width: 30,
                        height: 30,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.fromBorderSide(
                                BorderSide(color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ...controller.filteredLocationsList.map((loc) {
                      String chipAktif =
                          controller.selectedCategory.value.toLowerCase();
                      String kategoriVisual = (chipAktif == 'semua')
                          ? (loc.category ?? '').toLowerCase()
                          : chipAktif;

                      Color markerColor = colorPrimaryDark;
                      IconData markerIcon = Icons.storefront;

                      if (kategoriVisual == 'pengrajin') {
                        markerColor = const Color(0xFF2E5A27);
                        markerIcon = Icons.design_services;
                      } else if (kategoriVisual == 'sentra batik') {
                        markerColor = const Color(0xFF8B4513);
                        markerIcon = Icons.factory_outlined;
                      } else if (kategoriVisual == 'edukasi') {
                        markerColor = const Color(0xFF2980B9);
                        markerIcon = Icons.school_outlined;
                      } else {
                        markerColor = colorPrimaryDark;
                        markerIcon = Icons.storefront;
                      }

                      return Marker(
                        point: LatLng(loc.latitude!, loc.longitude!),
                        width:
                            50, // Sedikit diperbesar agar area klik lebih nyaman
                        height: 50,
                        child: GestureDetector(
                          // =======================================================================
                          // KUNCI UTAMA: Ketika Marker Peta Di-klik
                          // =======================================================================
                          onTap: () {
                            // Option 1: Langsung bawa user masuk ke halaman Detail tempat tersebut
                            Get.toNamed(Routes.DETAIL_PAGE, arguments: loc);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(
                                    7), // Perbesar padding sedikit
                                decoration: BoxDecoration(
                                  color: markerColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  markerIcon,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: controller
                              .searchTextController, // 1. Pasangkan controller teks di sini
                          onChanged: (val) {
                            // Update status apakah tombol 'X' harus muncul atau tidak
                            controller.isSearching.value = val.isNotEmpty;
                            controller.loadLocations(query: val);
                          },
                          decoration: InputDecoration(
                            hintText: 'Cari lokasi batik...',
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),

                            // =========================================================================
                            // KUNCI UTAMA: Tambahkan suffixIcon dinamis menggunakan Obx
                            // =========================================================================
                            suffixIcon: Obx(() {
                              // Jika user sedang tidak mengetik apa-apa, kosongkan ikon kanan
                              if (!controller.isSearching.value)
                                return const SizedBox.shrink();

                              // Jika ada teks, munculkan tombol klik 'X' (clear button)
                              return IconButton(
                                icon:
                                    const Icon(Icons.clear, color: Colors.grey),
                                onPressed: () {
                                  // 1. Bersihkan teks di dalam TextField
                                  controller.searchTextController.clear();
                                  // 2. Sembunyikan kembali tombol 'X'
                                  controller.isSearching.value = false;
                                  // 3. Reset list lokasi agar menampilkan semua data tanpa filter
                                  controller.loadLocations(query: '');
                                },
                              );
                            }),

                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 16,
              bottom: MediaQuery.of(context).size.height * 0.23,
              child: GestureDetector(
                onTap: () => controller.recenterToUserSpace(),
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.my_location,
                    color: Colors.black87,
                    size: 24,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: DraggableScrollableSheet(
                initialChildSize: 0.20,
                minChildSize: 0.20,
                maxChildSize: 0.85,
                builder: (context, scrollController) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: colorBackground,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 12,
                          offset: Offset(0, -3),
                        ),
                      ],
                    ),
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          height: 38,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.categories.length,
                            itemBuilder: (context, index) {
                              String category = controller.categories[index];
                              return Obx(() {
                                bool isSelected =
                                    controller.selectedCategory.value ==
                                        category;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: ChoiceChip(
                                    label: Text(category),
                                    selected: isSelected,
                                    onSelected: (_) =>
                                        controller.filterLocations(category),
                                    selectedColor: Colors.black,
                                    backgroundColor: Colors.white,
                                    labelStyle: GoogleFonts.poppins(
                                      color:
                                          isSelected ? cGold : Colors.black87,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    side: BorderSide(
                                      color: isSelected
                                          ? Colors.black
                                          : Colors.grey.shade300,
                                    ),
                                    showCheckmark: false,
                                  ),
                                );
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Terdekat dari lokasimu',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorPrimaryDark.withValues(alpha: 0.9),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                          itemCount: controller.filteredLocationsList.length,
                          itemBuilder: (context, index) {
                            final loc = controller.filteredLocationsList[index];
                            return _buildLocationCard(
                              loc,
                              colorAccentOrange,
                              colorPrimaryDark,
                              borderColor,
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildLocationCard(
    MappingModelData loc,
    Color distanceColor,
    Color primaryDark,
    Color baseBorderColor,
  ) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.DETAIL_PAGE, arguments: loc);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child:
                  loc.bannerImageUrl != null && loc.bannerImageUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl:
                              '${AppConfig.baseUrl}/static/img/mapping/${loc.bannerImageUrl}',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          // 2. FIXED INTERNAL IMAGE PLACEHOLDER: Efek Shimmer Transparan Lembut
                          placeholder: (context, url) => Shimmer(
                            color: const Color(0xFFE6DFD5),
                            colorOpacity: 0.4,
                            duration: const Duration(milliseconds: 1200),
                            child: Container(
                              width: 100,
                              height: 100,
                              color: Colors.transparent,
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: 100,
                            height: 100,
                            color: primaryDark.withValues(alpha: 0.1),
                            child: Icon(
                              Icons.image_not_supported,
                              color: primaryDark,
                              size: 24,
                            ),
                          ),
                        )
                      : Container(
                          width: 100,
                          height: 100,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.store, size: 24),
                        ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: SizedBox(
                height: 95,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 5,
                          runSpacing: 4,
                          children: [
                            if (loc.category != null)
                              buildSharedSingleBadge(loc.category!),
                            if (loc.categories != null)
                              ...loc.categories!
                                  .where(
                                    (cat) =>
                                        cat.toLowerCase() !=
                                        loc.category?.toLowerCase(),
                                  )
                                  .map((cat) => buildSharedSingleBadge(cat)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          loc.name ?? '-',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 15,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            (loc.address != null &&
                                    loc.address!['full'] != null)
                                ? ambilNamaDepanAlamat(
                                    loc.address!['full'].toString(),
                                  )
                                : 'Tegal',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          loc.distance != null
                              ? '${loc.distance!.toStringAsFixed(1)} km'
                              : '- km',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: distanceColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 2),
                        Text(
                          loc.averageRating?.toStringAsFixed(1) ?? '0.0',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= INDUSTRIAL STANDARD: FULL PAGE MAP & DRAGGABLE SKELETON SHIMMER =================
  Widget _buildFullPageShimmer(Color baseBorderColor) {
    const shimmerBg = Color(0xFFEFECE6);
    const maskColor = Color(0xFFE2DDD5);

    return Shimmer(
      color: const Color(0xFFFAF7F2),
      colorOpacity: 0.5,
      duration: const Duration(milliseconds: 1200),
      child: Stack(
        children: [
          // Kerangka dasar peta latar belakang meluas penuh
          Container(
            color: maskColor,
            width: double.infinity,
            height: double.infinity,
          ),

          // Kerangka Search Bar Tiruan Atas
          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: shimmerBg,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),

          // Kerangka Bottom Sheet Tiruan Yang Menyerupai Draggable Asli
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 240, // Tinggi dummy meniru bodi area lembar lipat bawah
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF7F5EE),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle Bar Atas
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: maskColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Judul Sub Menu Tiruan
                    Container(
                      width: 160,
                      height: 18,
                      decoration: BoxDecoration(
                        color: maskColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Replikasi baris tunggal dummy list card lokasi
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: shimmerBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: baseBorderColor, width: 1),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: maskColor,
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 40,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: maskColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: 130,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    color: maskColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  width: 90,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: maskColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ],
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
        ],
      ),
    );
  }
}
