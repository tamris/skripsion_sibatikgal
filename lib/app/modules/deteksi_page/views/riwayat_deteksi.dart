import 'package:batikara/app/modules/deteksi_page/widget/riwayat_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/deteksi_page_controller.dart';

class RiwayatDeteksiView extends GetView<DeteksiPageController> {
  const RiwayatDeteksiView({super.key});

  // ── Brand Colors — sama dengan fitur deteksi ─────────────
  static const Color cDark = Color(0xFF1A1208);
  static const Color cKrem = Color(0xFFF7F4EE);
  static const Color cKremChip = Color(0xFFF0EAD8);
  static const Color cBorder = Color(0xFFE8E4DC);
  static const Color cGold = Color(0xFFFFD264);
  static const Color cBrown = Color(0xFF7A3B10);
  static const Color cTextSub = Color(0xFF9C8B7A);
  static const Color cDelete = Color(0xFFD32F2F);

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    // State selection — sama persis logic lama
    final isSelectionMode = false.obs;
    final selectedItems = <Map<String, dynamic>>[].obs;

    return Scaffold(
      backgroundColor: cKrem,
      body: SafeArea(
        child: Obx(() {
          return Column(
            children: [
              // ── HEADER ──────────────────────────────────
              _buildHeader(isSelectionMode, selectedItems),

              // ── LIST / LOADING / EMPTY ───────────────────
              Expanded(
                child: _buildBody(
                  isSelectionMode,
                  selectedItems,
                  bottomPadding,
                ),
              ),

              // ── BOTTOM DELETE BAR — muncul saat ada yg dipilih
              _buildDeleteBar(isSelectionMode, selectedItems, bottomPadding),
            ],
          );
        }),
      ),
    );
  }

  // ── HEADER ───────────────────────────────────────────────
  Widget _buildHeader(
    RxBool isSelectionMode,
    RxList<Map<String, dynamic>> selectedItems,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Tombol back / cancel selection
              _CircleBtn(
                child: Icon(
                  isSelectionMode.value ? Icons.close : Icons.arrow_back,
                  size: 18,
                  color: cDark,
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

              // Judul — berubah saat selection mode
              Text(
                isSelectionMode.value
                    ? '${selectedItems.length} dipilih'
                    : 'Riwayat Deteksi',
                style: GoogleFonts.lora(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: cDark,
                ),
              ),

              // Kanan: pilih semua / tombol delete
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
                      child: Text(
                        selectedItems.length == controller.historyList.length
                            ? 'Batal Semua'
                            : 'Pilih Semua',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: cBrown,
                        ),
                      ),
                    )
                  : _CircleBtn(
                      child: const Icon(
                        Icons.delete_outline_rounded,
                        size: 18,
                        color: cDark,
                      ),
                      onTap: () => isSelectionMode.value = true,
                    ),
            ],
          ),
        ),
        // Divider tipis
        const Divider(height: 1, color: cBorder, thickness: 0.5),
      ],
    );
  }

  // ── BODY ─────────────────────────────────────────────────
  Widget _buildBody(
    RxBool isSelectionMode,
    RxList<Map<String, dynamic>> selectedItems,
    double bottomPadding,
  ) {
    if (controller.isLoadingHistory.value) {
      return const Center(
        child: CircularProgressIndicator(color: cBrown, strokeWidth: 2),
      );
    }

    if (controller.historyList.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16, 16, 16, 24 + bottomPadding),
      itemCount: controller.historyList.length,
      itemBuilder: (context, index) {
        final rawItem = controller.historyList[index];
        final Map<String, dynamic> item = Map<String, dynamic>.from(
          rawItem as Map,
        );

        // ── Date header logic — sama persis lama ──────────
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
              'Desember',
            ];
            tanggalHeader = '${dt.day} ${bulan[dt.month - 1]} ${dt.year}';
          } catch (_) {}
        }

        if (index == 0) {
          showDateHeader = true;
        } else {
          final prev = Map<String, dynamic>.from(
            controller.historyList[index - 1] as Map,
          );
          if (prev['created_at'] != null && item['created_at'] != null) {
            try {
              final cur = DateTime.parse(
                item['created_at'].toString(),
              ).toLocal();
              final pre = DateTime.parse(
                prev['created_at'].toString(),
              ).toLocal();
              if (cur.day != pre.day ||
                  cur.month != pre.month ||
                  cur.year != pre.year) {
                showDateHeader = true;
              }
            } catch (_) {}
          }
        }

        final bool isChecked = selectedItems.any(
          (e) => e['_id'] == item['_id'],
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date header dengan style baru
            if (showDateHeader)
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 12),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: cDark,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tanggalHeader,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: cGold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Container(height: 0.5, color: cBorder)),
                  ],
                ),
              ),

            // Item widget — logic onTap & checkbox tetap
            RiwayatItemWidget(
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
          ],
        );
      },
    );
  }

  // ── EMPTY STATE ──────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: cKremChip,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.history_rounded, size: 30, color: cBrown),
          ),
          const SizedBox(height: 14),
          Text(
            'Belum ada riwayat deteksi',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: cDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Coba deteksi motif batik dulu yuk!',
            style: GoogleFonts.poppins(fontSize: 12, color: cTextSub),
          ),
        ],
      ),
    );
  }

  // ── DELETE BAR — animasi muncul/hilang ───────────────────
  Widget _buildDeleteBar(
    RxBool isSelectionMode,
    RxList<Map<String, dynamic>> selectedItems,
    double bottomPadding,
  ) {
    final bool show = isSelectionMode.value && selectedItems.isNotEmpty;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      height: show ? (60 + bottomPadding) : 0,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8 + bottomPadding * 0.5),
      decoration: const BoxDecoration(
        color: Color(0xFAF7F4EE),
        border: Border(top: BorderSide(color: cBorder, width: 0.5)),
      ),
      child: show
          ? GestureDetector(
              onTap: () => _showDeleteDialog(selectedItems),
              child: Container(
                decoration: BoxDecoration(
                  color: cDelete,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.delete_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Hapus ${selectedItems.length} Riwayat',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
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

  // ── DIALOG KONFIRMASI HAPUS — logic sama persis lama ─────
  void _showDeleteDialog(RxList<Map<String, dynamic>> selectedItems) {
    Get.defaultDialog(
      title: 'Hapus Riwayat',
      titleStyle: GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: cDark,
      ),
      middleText: 'Hapus ${selectedItems.length} riwayat deteksi yang dipilih?',
      middleTextStyle: GoogleFonts.poppins(fontSize: 12, color: cTextSub),
      textConfirm: 'Hapus',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      buttonColor: cDelete,
      cancelTextColor: cDark,
      radius: 16,
      onConfirm: () {
        final ids = selectedItems.map((e) => e['_id']).toList();
        // Hapus dari list lokal — sama persis logic lama
        controller.historyList.removeWhere((e) => ids.contains(e['_id']));
        selectedItems.clear();
        Get.back();
        Get.snackbar(
          'Sukses',
          'Riwayat berhasil dihapus',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: cDark,
          colorText: cGold,
        );
      },
    );
  }
}

// ════════════════════════════════════════════════════════════
// REUSABLE WIDGETS
// ════════════════════════════════════════════════════════════
class _CircleBtn extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const _CircleBtn({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 45,
        height: 45,
        decoration: const BoxDecoration(
          color: Color(0xFFF0EAD8),
          shape: BoxShape.circle,
        ),
        child: Center(child: child),
      ),
    );
  }
}