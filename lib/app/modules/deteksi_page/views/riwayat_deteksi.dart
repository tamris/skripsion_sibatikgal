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

    // State selection asli kamu — dipertahankan penuh 100%
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
              // Tombol back / cancel selection dengan style premium bulat kustom
              _CircleBtn(
                child: Icon(
                  isSelectionMode.value
                      ? Icons.close_rounded
                      : Icons.arrow_back_rounded,
                  size: 18,
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

              // Judul — Elegan dinamis lora font
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

              // Kanan: pilih semua / tombol masuk mode delete
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
    // 1. INOVASI: KONDISI LOADING SEKARANG MENGGUNAKAN SHIMMER LAYOUT FORM SKELETON
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

        // ── Date header logic asli kamu — dipertahankan presisi ──
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
            // Date chip header dengan gaya minimalis premium baru
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

            // Item widget asli kamu tetap aman berjalan logikanya
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
              decoration: BoxDecoration(
                color: const Color(0xFFF2ECE0),
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
                      size: 18,
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

  // ── DIALOG KONFIRMASI HAPUS PREMIUM SINKRON ─────────────────────────
  void _showDeleteDialog(
      RxBool isSelectionMode, RxList<Map<String, dynamic>> selectedItems) {
    Get.defaultDialog(
      title: 'Hapus Riwayat',
      titleStyle: GoogleFonts.lora(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: darkBrown,
      ),
      titlePadding: const EdgeInsets.only(top: 24),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      middleText:
          'Hapus ${selectedItems.length} riwayat deteksi yang dipilih secara permanen?',
      middleTextStyle:
          GoogleFonts.poppins(fontSize: 14, color: textMuted, height: 1.4),
      textConfirm: 'Hapus',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      buttonColor: cDelete,
      cancelTextColor: darkBrown,
      radius: 20,
      onConfirm: () {
        final ids = selectedItems.map((e) => e['_id']).toList();

        // 1. Jalankan hapus di database & storage server asli bawaan kamu
        controller.deleteSelectedHistory(ids);

        // 2. State UI kamu dibersihkan seketika
        controller.historyList.removeWhere((e) => ids.contains(e['_id']));
        selectedItems.clear();
        isSelectionMode.value = false;

        Get.back();
        Get.snackbar(
          'Sukses',
          'Riwayat berhasil dihapus',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: darkBrown,
          colorText: accentGold,
          borderRadius: 12,
          margin: const EdgeInsets.all(16),
        );
      },
    );
  }

  // ================= UTILITY OPTIMIZED SHIMMER LAYOUT =================
  Widget _buildShimmerLoading() {
    return Shimmer(
      color: const Color(0xFFFAF7F2),
      colorOpacity: 0.6,
      duration: const Duration(milliseconds: 1500),
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tiruan Tanggal Header di baris pertama
                if (index == 0)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 14.0),
                    child: Container(
                      width: 140,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE6DFD5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                // Tiruan Card List Utama berkilau menyatu
                Container(
                  width: double.infinity,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F0E6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: borderColor, width: 1),
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
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE6DFD5), width: 1),
        ),
        child: Center(child: child),
      ),
    );
  }
}
