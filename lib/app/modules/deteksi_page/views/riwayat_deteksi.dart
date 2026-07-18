import 'package:batikara/app/modules/deteksi_page/widget/riwayat_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer_animation/shimmer_animation.dart'; // Impor package andalanmu untuk skeleton loading
import '../controllers/deteksi_page_controller.dart';

class RiwayatDeteksiView extends GetView<DeteksiPageController> {
  const RiwayatDeteksiView({super.key});

  // ── Palet Warna Premium Konsisten Batikara Global ─────────────
  static const Color bgCanvas = Color(0xFFFAF7F2);
  static const Color darkBrown = Color(0xFF1C1308);
  static const Color textMuted = Color(0xFF7A7062);
  static const Color accentGold = Color(0xFFFBBF24);
  static const Color borderColor = Color(0xFFE6DFD5);
  static const Color softRed = Color(0xFFFCE8E6);
  static const Color cDelete = Color(0xFFD32F2F);

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    // State selection asli kamu — dipertahaman penuh 100%
    final isSelectionMode = false.obs;
    final selectedItems = <Map<String, dynamic>>[].obs;

    return Scaffold(
      backgroundColor: bgCanvas,
      body: SafeArea(
        child: Obx(() {
          return Column(
            children: [
              // ── HEADER PREMIUM DENGAN CHIP SELEKSI ────────────────
              _buildHeader(isSelectionMode, selectedItems),

              // ── LIST / LOADING / EMPTY STATE DENGAN SHIMMER ───────
              Expanded(
                child: _buildBody(
                  isSelectionMode,
                  selectedItems,
                  bottomPadding,
                ),
              ),

              // ── BOTTOM DELETE BAR PREMIUM ────────────────────────
              _buildDeleteBar(isSelectionMode, selectedItems, bottomPadding),
            ],
          );
        }),
      ),
    );
  }

  // ── HEADER PREMIUM SINKRON ───────────────────────────────────────────
  Widget _buildHeader(
    RxBool isSelectionMode,
    RxList<Map<String, dynamic>> selectedItems,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CircleBtn(
                child: Icon(
                  isSelectionMode.value
                      ? Icons.close_rounded
                      : Icons.arrow_back_rounded,
                  size: 20,
                  color: darkBrown,
                ),
                onTap: () {
                  if (isSelectionMode.value) {
                    isSelectionMode.value = false;
                    selectedItems.clear();
                  } else {
                    Get.back();
                  }
                },
              ),
              Text(
                isSelectionMode.value
                    ? '${selectedItems.length} dipilih'
                    : 'Riwayat Deteksi',
                style: GoogleFonts.lora(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: darkBrown,
                ),
              ),
              isSelectionMode.value
                  ? GestureDetector(
                      onTap: () {
                        if (selectedItems.length ==
                            controller.historyList.length) {
                          selectedItems.clear();
                        } else {
                          final all = controller.historyList
                              .map((e) => Map<String, dynamic>.from(e as Map))
                              .toList();
                          selectedItems.assignAll(all);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Text(
                          selectedItems.length == controller.historyList.length
                              ? 'Batal Semua'
                              : 'Pilih Semua',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: darkBrown,
                          ),
                        ),
                      ),
                    )
                  : _CircleBtn(
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        size: 18,
                        color: darkBrown,
                      ),
                      onTap: () => isSelectionMode.value = true,
                    ),
            ],
          ),
        ),
        const Divider(height: 1, color: borderColor, thickness: 1),
      ],
    );
  }

  // ── BODY DENGAN INOVASI SHIMMER LAYOUT ───────────────────────────────
  Widget _buildBody(
    RxBool isSelectionMode,
    RxList<Map<String, dynamic>> selectedItems,
    double bottomPadding,
  ) {
    // 1. STATE LOADING MENGGUNAKAN STANDAR INDUSTRI SHIMMER MULTI-LAYOUT
    if (controller.isLoadingHistory.value) {
      return _buildShimmerLoading();
    }

    if (controller.historyList.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20, 16, 20, 24 + bottomPadding),
      itemCount: controller.historyList.length,
      itemBuilder: (context, index) {
        final rawItem = controller.historyList[index];
        final Map<String, dynamic> item =
            Map<String, dynamic>.from(rawItem as Map);

        String tanggalHeader = '';
        bool showDateHeader = false;

        if (item['created_at'] != null) {
          try {
            final dt = DateTime.parse(item['created_at'].toString()).toLocal();
            const bulan = [
              'Januari',
              'Februari',
              'Maret',
              'April',
              'Mei',
              'Juni',
              'Juli',
              'Agustus',
              'September',
              'Oktober',
              'November',
              'Desember'
            ];
            tanggalHeader = '${dt.day} ${bulan[dt.month - 1]} ${dt.year}';
          } catch (_) {}
        }

        if (index == 0) {
          showDateHeader = true;
        } else {
          final prev = Map<String, dynamic>.from(
              controller.historyList[index - 1] as Map);
          if (prev['created_at'] != null && item['created_at'] != null) {
            try {
              final cur =
                  DateTime.parse(item['created_at'].toString()).toLocal();
              final pre =
                  DateTime.parse(prev['created_at'].toString()).toLocal();
              if (cur.day != pre.day ||
                  cur.month != pre.month ||
                  cur.year != pre.year) {
                showDateHeader = true;
              }
            } catch (_) {}
          }
        }

        final bool isChecked =
            selectedItems.any((e) => e['_id'] == item['_id']);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showDateHeader)
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 14),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: darkBrown,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tanggalHeader,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: accentGold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Container(height: 1, color: borderColor)),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: RiwayatItemWidget(
                item: item,
                index: index,
                isSelectionMode: isSelectionMode.value,
                isChecked: isChecked,
                onCheckboxChanged: (val) {
                  if (val == true) {
                    selectedItems.add(item);
                  } else {
                    selectedItems.removeWhere((e) => e['_id'] == item['_id']);
                  }
                },
                onCardTapInSelection: () {
                  if (isChecked) {
                    selectedItems.removeWhere((e) => e['_id'] == item['_id']);
                  } else {
                    selectedItems.add(item);
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // ── EMPTY STATE SINKRON ──────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Color(0xFFF2ECE0),
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.history_rounded, size: 30, color: darkBrown),
            ),
            const SizedBox(height: 20),
            Text(
              'Belum ada riwayat deteksi',
              style: GoogleFonts.lora(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: darkBrown,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Coba deteksi motif batik dulu yuk!',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 13, color: textMuted),
            ),
          ],
        ),
      ),
    );
  }

  // ── DELETE BAR — ANIMASI DI-POLES HALUS ───────────────────────────────
  Widget _buildDeleteBar(
    RxBool isSelectionMode,
    RxList<Map<String, dynamic>> selectedItems,
    double bottomPadding,
  ) {
    final bool show = isSelectionMode.value && selectedItems.isNotEmpty;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      height: show ? (68 + bottomPadding) : 0,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10 + bottomPadding),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -4),
          )
        ],
      ),
      child: show
          ? GestureDetector(
              onTap: () => _showDeleteDialog(isSelectionMode, selectedItems),
              child: Container(
                decoration: BoxDecoration(
                  color: cDelete,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.delete_forever_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Hapus ${selectedItems.length} Riwayat',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  // ── REDESAIN DIALOG KONFIRMASI HAPUS PREMIUM PREMIUM ─────────────────
  void _showDeleteDialog(
      RxBool isSelectionMode, RxList<Map<String, dynamic>> selectedItems) {
    Get.dialog(
      Dialog(
        backgroundColor: bgCanvas,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: borderColor, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. Indikator Bahaya Lingkar Ikon Soft-Red
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: softRed,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_sweep_rounded,
                  size: 32,
                  color: cDelete,
                ),
              ),
              const SizedBox(height: 20),

              // 2. Judul Dialog Elegance
              Text(
                'Hapus Riwayat',
                style: GoogleFonts.lora(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: darkBrown,
                ),
              ),
              const SizedBox(height: 10),

              // 3. Deskripsi Dialog Penegasan UX
              Text(
                'Apakah Anda yakin ingin menghapus ${selectedItems.length} riwayat deteksi yang dipilih secara permanen? Tindakan ini tidak dapat dibatalkan.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: textMuted,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),

              // 4. Tombol Aksi Row Bersebelahan Secara Proporsional
              Row(
                children: [
                  // Tombol Batalkan (Gaya Outlined Minimalis)
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: darkBrown,
                          side:
                              const BorderSide(color: borderColor, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () => Get.back(),
                        child: Text(
                          'Batal',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Tombol Hapus (Gaya Solid Danger Red Dominan)
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cDelete,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          final ids =
                              selectedItems.map((e) => e['_id']).toList();

                          // Menjalankan fungsi hapus data asli di database kamu[cite: 10]
                          controller.deleteSelectedHistory(ids);

                          // Membersihkan status data di UI secara instan[cite: 10]
                          controller.historyList
                              .removeWhere((e) => ids.contains(e['_id']));
                          selectedItems.clear();
                          isSelectionMode.value = false;

                          Get.back(); // Menutup dialog kustom
                        },
                        child: Text(
                          'Hapus',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  // ================= INDUSTRIAL STANDARD: RIWAYAT MULTI-LAYOUT SKELETON SHIMMER =================
  Widget _buildShimmerLoading() {
    const shimmerBg = Color(0xFFEFECE6);
    const maskColor = Color(0xFFE2DDD5);

    return Shimmer(
      color: const Color(0xFFFAF7F2),
      colorOpacity: 0.5,
      duration: const Duration(milliseconds: 1200),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (index == 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 14),
                    child: Container(
                      width: 130,
                      height: 24,
                      decoration: BoxDecoration(
                        color: maskColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                Container(
                  width: double.infinity,
                  height: 94,
                  decoration: BoxDecoration(
                    color: shimmerBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: borderColor, width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: maskColor,
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 140,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: maskColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                width: 80,
                                height: 11,
                                decoration: BoxDecoration(
                                  color: maskColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                width: 45,
                                height: 9,
                                decoration: BoxDecoration(
                                  color: maskColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: maskColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ── CUSTOM REUSABLE BUTTON SINKRON ──────────────────────────────────
class _CircleBtn extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const _CircleBtn({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        child: Center(child: child),
      ),
    );
  }
}
