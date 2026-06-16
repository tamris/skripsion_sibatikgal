import 'package:batikara/app/data/config/app_config.dart';
import 'package:batikara/app/data/models/mapping_model.dart';
import 'package:batikara/app/modules/mapping_page/controllers/mapping_page_controller.dart';
import 'package:batikara/app/modules/mapping_page/widgets/shared_components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetailPageView extends StatelessWidget {
  const DetailPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final mappingController = Get.find<MappingPageController>();
    final RxInt selectedStarFilter = 0.obs;

    if (mappingController.currentDetailLocation.value.id != Get.arguments.id) {
      mappingController.currentDetailLocation.value = Get.arguments;

      mappingController.resetReviewForm();

      mappingController.selectedDetailTab.value = 0;

      mappingController.cekUlasanLamaUser(
        mappingController.currentDetailLocation.value.reviews ?? [],
      );
    }

    const colorBackground = Color(0xFFF7F5EE);
    const colorPrimaryDark = Color(0xFF1A1208);
    const colorAccentOrange = Color(0xFFD35400);
    const Color cGold = Color(0xFFFFD264);

    return Obx(() {
      final MappingModelData loc =
          mappingController.currentDetailLocation.value;

      return Scaffold(
        backgroundColor: colorBackground,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 260,
                    width: double.infinity,
                    child:
                        loc.bannerImageUrl != null &&
                            loc.bannerImageUrl!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl:
                                '${AppConfig.baseUrl}/static/img/mapping/${loc.bannerImageUrl}',
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: colorPrimaryDark.withValues(alpha: 0.2),
                            child: const Icon(
                              Icons.image,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),
                  ),
                  const SizedBox(height: 120),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => mappingController.bukaGoogleMaps(
                                  loc.latitude,
                                  loc.longitude,
                                  loc.name,
                                ),
                                child: Container(
                                  height: 54,
                                  decoration: BoxDecoration(
                                    color: colorPrimaryDark,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.navigation_outlined,
                                        color: cGold,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Arahkan ke sini',
                                        style: GoogleFonts.poppins(
                                          color: cGold,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            _buildSquareActionButton(
                              icon: Icons.bookmark_border_outlined,
                              onTap: () {},
                            ),
                            const SizedBox(width: 12),
                            _buildSquareActionButton(
                              icon: Icons.phone_outlined,
                              onTap: () =>
                                  mappingController.kontakWhatsApp(loc.phone),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),

                        _buildCustomTabBar(
                          mappingController,
                          colorAccentOrange,
                        ),
                        const SizedBox(height: 20),

                        if (mappingController.selectedDetailTab.value == 0) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                color: colorAccentOrange,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  loc.address != null &&
                                          loc.address!['full'] != null
                                      ? loc.address!['full'].toString()
                                      : 'Alamat tidak terdaftar.',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13.5,
                                    color: Colors.black87,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          _buildSectionTitle(
                            'Tentang tempat',
                            colorPrimaryDark,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            loc.description ??
                                'Tidak ada deskripsi tentang tempat ini.',
                            style: GoogleFonts.mulish(
                              fontSize: 14,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 25),
                          _buildSectionTitle(
                            'Ringkasan rating',
                            colorPrimaryDark,
                          ),
                          const SizedBox(height: 15),
                          _buildRatingSummaryBlock(loc, cGold),
                          const SizedBox(height: 30),
                          _buildSectionTitle(
                            'Ulasan pengunjung',
                            colorPrimaryDark,
                          ),
                          const SizedBox(height: 12),
                          // Di Tab Info tetap tampil default maksimal 3 ulasan terbaru tanpa filter bintang
                          _buildReviewSectionList(
                            loc,
                            colorAccentOrange,
                            limit: 3,
                          ),
                          const SizedBox(height: 30),
                          _buildWriteReviewForm(loc, colorPrimaryDark, cGold),
                          const SizedBox(height: 30),
                        ] else if (mappingController.selectedDetailTab.value ==
                            1) ...[
                          // ===================================================
                          // KONTEN TAB ULASAN FULL (Dinamis & Interaktif)
                          // ===================================================
                          _buildRatingSummaryBlock(loc, cGold),
                          const SizedBox(height: 20),

                          // Filter Badges dibungkus Obx lokal agar responsif saat diklik
                          Obx(
                            () => _buildFilterReviewBadges(selectedStarFilter),
                          ),
                          const SizedBox(height: 25),

                          _buildSectionTitle(
                            'Ulasan pengunjung',
                            colorPrimaryDark,
                          ),
                          const SizedBox(height: 12),

                          // List ulasan mendengarkan perubahan filter bintang dari selectedStarFilter
                          Obx(
                            () => _buildReviewSectionList(
                              loc,
                              colorAccentOrange,
                              filterStar: selectedStarFilter.value,
                            ),
                          ),
                          const SizedBox(height: 30),
                          _buildWriteReviewForm(loc, colorPrimaryDark, cGold),
                          const SizedBox(height: 30),
                        ] else ...[
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20.0,
                              ),
                              child: Text(
                                'Belum ada foto galeri untuk tempat ini.',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ],
                    ),
                  ),
                ],
              ),

              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildHeaderCircleButton(
                        Icons.arrow_back,
                        () => Get.back(),
                      ),
                      _buildHeaderCircleButton(Icons.share_outlined, () {}),
                    ],
                  ),
                ),
              ),

              Positioned(
                top: 210,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              loc.name ?? '-',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: colorPrimaryDark,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: cGold,
                                    size: 20,
                                  ),
                                  Text(
                                    loc.averageRating?.toStringAsFixed(1) ??
                                        '0.0',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: colorAccentOrange,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '(${loc.totalReviews ?? 0})',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      color: colorPrimaryDark.withValues(
                                        alpha: 0.7,
                                      ),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 6,
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
                      const SizedBox(height: 14),
                      const Divider(height: 1, color: Color(0xFFEEEEEE)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                color: Colors.grey,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                (loc.address != null &&
                                        loc.address!['full'] != null)
                                    ? ambilNamaDepanAlamat(
                                        loc.address!['full'].toString(),
                                      )
                                    : 'Tegal',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.directions_outlined,
                                color: colorAccentOrange,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                loc.distance != null
                                    ? '${loc.distance!.toStringAsFixed(1)} km'
                                    : '- km',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: colorAccentOrange,
                                ),
                              ),
                            ],
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
    });
  }

  Widget _buildSectionTitle(String title, Color darkColor) {
    return Row(
      children: [
        Container(width: 4, height: 18, color: const Color(0xFFD35400)),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: darkColor,
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderCircleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.black87, size: 22),
      ),
    );
  }

  Widget _buildSquareActionButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        width: 54,
        decoration: BoxDecoration(
          color: const Color(0xFFF1EDE2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: const Color(0xFFD35400), size: 22),
      ),
    );
  }

  Widget _buildCustomTabBar(
    MappingPageController controller,
    Color activeColor,
  ) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE5E2D9), width: 1.5),
        ),
      ),
      child: Row(
        children: [
          _buildSingleTabItem(
            'Info',
            controller.selectedDetailTab.value == 0,
            activeColor,
            () {
              controller.selectedDetailTab.value = 0;
            },
          ),
          _buildSingleTabItem(
            'Ulasan',
            controller.selectedDetailTab.value == 1,
            activeColor,
            () {
              controller.selectedDetailTab.value = 1;
            },
          ),
          // _buildSingleTabItem(
          //   'Foto',
          //   controller.selectedDetailTab.value == 2,
          //   activeColor,
          //   () {
          //     controller.selectedDetailTab.value = 2;
          //   },
          // ),
        ],
      ),
    );
  }

  Widget _buildSingleTabItem(
    String label,
    bool isActive,
    Color activeColor,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: isActive
              ? BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: activeColor, width: 3),
                  ),
                )
              : null,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              color: isActive ? Colors.black87 : Colors.grey.shade500,
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // MODIFIKASI: Filter Review Badges Sekarang Menerima RxInt State Agar Interaktif
  // ===========================================================================
  Widget _buildFilterReviewBadges(RxInt selectedFilter) {
    final List<Map<String, dynamic>> filters = [
      {'value': 0, 'label': 'Semua', 'isStar': false},
      {'value': 5, 'label': '5', 'isStar': true},
      {'value': 4, 'label': '4', 'isStar': true},
      {'value': 3, 'label': '3', 'isStar': true},
      {'value': 2, 'label': '2', 'isStar': true},
      {'value': 1, 'label': '1', 'isStar': true},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: filters.map((f) {
          final int filterVal = f['value'];
          final bool active = selectedFilter.value == filterVal;

          return GestureDetector(
            onTap: () {
              selectedFilter.value =
                  filterVal; // Set nilai filter bintang saat ditekan
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: active ? const Color(0xFF1A1208) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: active ? Colors.transparent : const Color(0xFFE5E2D9),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  if (f['isStar'] == true) ...[
                    Icon(
                      Icons.star,
                      size: 14,
                      color: active ? const Color(0xFFFFD264) : Colors.amber,
                    ),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    f['label'],
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: active ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRatingSummaryBlock(MappingModelData loc, Color starColor) {
    final List<ReviewModel> allReviews = loc.reviews ?? [];
    final int total = allReviews.length;

    int count5 = 0;
    int count4 = 0;
    int count3 = 0;
    int count2 = 0;
    int count1 = 0;
    for (var review in allReviews) {
      int r = (review.rating ?? 0.0).round();
      if (r == 5)
        count5++;
      else if (r == 4)
        count4++;
      else if (r == 3)
        count3++;
      else if (r == 2)
        count2++;
      else if (r == 1)
        count1++;
    }

    // ===========================================================================
    // KUNCI GOOGLE MAPS: Cari tahu jumlah ulasan paling banyak di antara semua baris
    // ===========================================================================
    int maxReviewsCount = [
      count5,
      count4,
      count3,
      count2,
      count1,
    ].reduce((curr, next) => curr > next ? curr : next);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            Text(
              loc.averageRating?.toStringAsFixed(1) ?? '0.0',
              style: GoogleFonts.poppins(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Row(
              children: List.generate(5, (index) {
                double currentStar = index + 1;
                double avgRating = loc.averageRating ?? 0.0;
                if (avgRating >= currentStar)
                  return const Icon(Icons.star, color: Colors.amber, size: 16);
                else if (avgRating >= currentStar - 0.5)
                  return const Icon(
                    Icons.star_half,
                    color: Colors.amber,
                    size: 16,
                  );
                else
                  return const Icon(
                    Icons.star_border,
                    color: Colors.amber,
                    size: 16,
                  );
              }),
            ),
            const SizedBox(height: 4),
            Text(
              '$total ulasan',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(width: 30),
        Expanded(
          child: Column(
            children: [
              // Pembaginya diganti menggunakan maxReviewsCount bukan total seluruh ulasan
              _buildSingleProgressBar(
                5,
                maxReviewsCount > 0 ? (count5 / maxReviewsCount) : 0.0,
                count5,
                starColor,
              ),
              _buildSingleProgressBar(
                4,
                maxReviewsCount > 0 ? (count4 / maxReviewsCount) : 0.0,
                count4,
                starColor,
              ),
              _buildSingleProgressBar(
                3,
                maxReviewsCount > 0 ? (count3 / maxReviewsCount) : 0.0,
                count3,
                starColor,
              ),
              _buildSingleProgressBar(
                2,
                maxReviewsCount > 0 ? (count2 / maxReviewsCount) : 0.0,
                count2,
                starColor,
              ),
              _buildSingleProgressBar(
                1,
                maxReviewsCount > 0 ? (count1 / maxReviewsCount) : 0.0,
                count1,
                starColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSingleProgressBar(
    int labelNumber,
    double valuePercentage,
    int countNumber,
    Color starColor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text(
            '$labelNumber',
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: valuePercentage,
                minHeight: 6,
                backgroundColor: const Color(0xFFE5E2D9),
                color: starColor,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$countNumber',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: countNumber > 0 ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // MODIFIKASI: Menerima param `filterStar` untuk menyaring ulasan secara langsung
  // ===========================================================================
  Widget _buildReviewSectionList(
    MappingModelData loc,
    Color orangeColor, {
    int? limit,
    int filterStar = 0,
  }) {
    final List<ReviewModel> allReviews = loc.reviews ?? [];

    if (allReviews.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            'Belum ada ulasan untuk tempat ini.',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    // 1. Lakukan duplikasi & sorting berdasarkan tanggal terbaru
    List<ReviewModel> sortedReviews = List.from(allReviews);
    sortedReviews.sort((a, b) {
      DateTime dateA = a.createdAt != null
          ? DateTime.parse(a.createdAt!)
          : DateTime(2000);
      DateTime dateB = b.createdAt != null
          ? DateTime.parse(b.createdAt!)
          : DateTime(2000);
      return dateB.compareTo(dateA);
    });

    // 2. LOGIKA UTAMA FILTER: Jika nilai filterStar > 0, saring ulasan yang pembulatannya cocok
    if (filterStar > 0) {
      sortedReviews = sortedReviews
          .where((review) => (review.rating ?? 0.0).round() == filterStar)
          .toList();
    }

    // 3. Jika datanya kosong setelah di-filter, tampilkan info kosong
    if (sortedReviews.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            'Tidak ada ulasan dengan bintang $filterStar.',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    final Iterable<ReviewModel> reviewDataToShow = limit != null
        ? sortedReviews.take(limit)
        : sortedReviews;
    final List<Color> avatarColors = [
      const Color(0xFFD35400),
      const Color(0xFF2C3E50),
      const Color(0xFF27AE60),
      const Color(0xFF2980B9),
      const Color(0xFF8E44AD),
    ];

    return Column(
      children: reviewDataToShow.map((review) {
        final String username = review.username ?? 'Anonim';
        final String comment = review.comment ?? '-';
        final double rating = review.rating ?? 0.0;
        final String displayDate = _formatTanggalIndonesia(review.createdAt);
        final int colorIndex = username.hashCode.abs() % avatarColors.length;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: avatarColors[colorIndex],
                        radius: 18,
                        child: Text(
                          _getInitials(username),
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            username,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            displayDate,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        index < rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                comment,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _formatTanggalIndonesia(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return '3 Jun 2026';
    try {
      DateTime parsedDate = DateTime.parse(rawDate).toLocal();
      const List<String> bulanIndo = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agt',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ];
      return '${parsedDate.day} ${bulanIndo[parsedDate.month - 1]} ${parsedDate.year}';
    } catch (e) {
      return rawDate.contains('T') ? rawDate.split('T')[0] : rawDate;
    }
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'U';
    List<String> nameParts = name.trim().split(' ');
    if (nameParts.length > 1 && nameParts[1].isNotEmpty)
      return (nameParts[0][0] + nameParts[1][0]).toUpperCase();
    return nameParts[0]
        .substring(0, nameParts[0].length >= 2 ? 2 : 1)
        .toUpperCase();
  }

  Widget _buildWriteReviewForm(
    MappingModelData loc,
    Color darkBgColor,
    Color goldColor,
  ) {
    final mappingController = Get.find<MappingPageController>();

    return Obx(() {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: darkBgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mappingController.isAlreadyReviewed.value
                  ? 'Ulasanmu di tempat ini'
                  : 'Bagaimana pengalamanmu?',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: List.generate(5, (index) {
                int starValue = index + 1;
                return GestureDetector(
                  onTap: () {
                    mappingController.userRating.value = starValue;
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: Icon(
                      starValue <= mappingController.userRating.value
                          ? Icons.star
                          : Icons.star_border,
                      color: starValue <= mappingController.userRating.value
                          ? goldColor
                          : Colors.grey.shade700,
                      size: 32,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2118),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade800),
              ),
              child: TextField(
                controller: mappingController.reviewCommentController,
                maxLines: 3,
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 13.5),
                decoration: InputDecoration(
                  hintText: 'Ceritakan pengalamanmu...',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey.shade600),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                if (mappingController.userRating.value == 0) {
                  Get.snackbar(
                    'Peringatan',
                    'Silakan pilih rating bintang terlebih dahulu.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.orange.withValues(alpha: 0.9),
                    colorText: Colors.white,
                  );
                  return;
                }
                if (mappingController.isAlreadyReviewed.value) {
                  mappingController.perbaruiUlasanDiFlask(loc.id ?? '');
                } else {
                  mappingController.kirimUlasanKeFlask(loc.id ?? '');
                }
              },
              child: Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  color: mappingController.isSendingReview.value
                      ? Colors.grey
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade800),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    mappingController.isSendingReview.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Icon(Icons.send_outlined, color: goldColor, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      mappingController.isSendingReview.value
                          ? 'Mengirim...'
                          : (mappingController.isAlreadyReviewed.value
                                ? 'Perbarui ulasan'
                                : 'Kirim ulasan'),
                      style: GoogleFonts.poppins(
                        color: goldColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}