import 'package:batikara/app/modules/deteksi_page/widget/riwayat_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/deteksi_page_controller.dart';

class RiwayatDeteksiView extends GetView<DeteksiPageController> {
  const RiwayatDeteksiView({super.key});

  @override
  Widget build(BuildContext context) {
    const colorPrimary = Color(0xFF795548);
    const colorBgScreen = Color(0xFFFCF9F6);
    const colorIconBoxBg = Color(0xFFF5EFE6);
    const textDark = Color(0xFF3E2723);
    const colorTimelineLine = Color(0xFFEFE7DD);
    const colorDelete = Color(0xFFD32F2F);

    // --- BEST PRACTICE: Deklarasikan tipe data Map secara eksplisit ---
    final isSelectionMode = false.obs;
    final selectedItems = <Map<String, dynamic>>[].obs;

    return Scaffold(
      backgroundColor: colorBgScreen,
      body: SafeArea(
        child: Obx(() {
          return Column(
            children: [
              // --- 1. APP BAR REGION ---
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 12.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: colorIconBoxBg,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: IconButton(
                        onPressed: () {
                          if (isSelectionMode.value) {
                            isSelectionMode.value = false;
                            selectedItems.clear();
                          } else {
                            Get.back();
                          }
                        },
                        icon: Icon(
                          isSelectionMode.value
                              ? Icons.close
                              : Icons.arrow_back,
                          color: textDark,
                          size: 20,
                        ),
                      ),
                    ),
                    Text(
                      isSelectionMode.value
                          ? 'Dipilih: ${selectedItems.length}'
                          : 'Riwayat Deteksi',
                      style: GoogleFonts.lora(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                    isSelectionMode.value
                        ? TextButton(
                            onPressed: () {
                              if (selectedItems.length ==
                                  controller.historyList.length) {
                                selectedItems.clear();
                              } else {
                                // Konversi massal seluruh isi list ke tipe Map<String, dynamic> secara aman
                                final allConverted = controller.historyList
                                    .map(
                                      (e) =>
                                          Map<String, dynamic>.from(e as Map),
                                    )
                                    .toList();
                                selectedItems.assignAll(allConverted);
                              }
                            },
                            child: Text(
                              selectedItems.length ==
                                      controller.historyList.length
                                  ? 'Batal Semua'
                                  : 'Pilih Semua',
                              style: GoogleFonts.poppins(
                                color: colorPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: colorIconBoxBg,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: IconButton(
                              onPressed: () => isSelectionMode.value = true,
                              icon: const Icon(
                                Icons.delete_outline,
                                color: textDark,
                                size: 20,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              const Divider(height: 1, color: colorTimelineLine),

              // --- 2. LIST VIEW TIMELINE REGION ---
              Expanded(
                child: () {
                  if (controller.isLoadingHistory.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: colorPrimary),
                    );
                  }

                  if (controller.historyList.isEmpty) {
                    return Center(
                      child: Text(
                        'Belum ada riwayat deteksi.',
                        style: GoogleFonts.poppins(color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(
                      left: 24.0,
                      right: 24.0,
                      top: 16.0,
                      bottom: 24.0,
                    ),
                    itemCount: controller.historyList.length,
                    itemBuilder: (context, index) {
                      // Ambil objek mentah lalu lakukan konversi Type-Safe secara eksplisit
                      final rawItem = controller.historyList[index];
                      final Map<String, dynamic> item =
                          Map<String, dynamic>.from(rawItem as Map);

                      String tanggalHeader = 'Tanggal';
                      if (item['created_at'] != null) {
                        try {
                          DateTime dateTime = DateTime.parse(
                            item['created_at'].toString(),
                          ).toLocal();
                          List<String> namaBulan = [
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
                          tanggalHeader =
                              "${dateTime.day} ${namaBulan[dateTime.month - 1]} ${dateTime.year}";
                        } catch (_) {}
                      }

                      bool showDateHeader = false;
                      if (index == 0) {
                        showDateHeader = true;
                      } else {
                        final prevRawItem = controller.historyList[index - 1];
                        final Map<String, dynamic> prevItem =
                            Map<String, dynamic>.from(prevRawItem as Map);

                        if (prevItem['created_at'] != null &&
                            item['created_at'] != null) {
                          try {
                            DateTime currentDt = DateTime.parse(
                              item['created_at'].toString(),
                            ).toLocal();
                            DateTime prevDt = DateTime.parse(
                              prevItem['created_at'].toString(),
                            ).toLocal();
                            if (currentDt.day != prevDt.day ||
                                currentDt.month != prevDt.month ||
                                currentDt.year != prevDt.year) {
                              showDateHeader = true;
                            }
                          } catch (_) {}
                        }
                      }

                      // Cek status menggunakan perbandingan nilai ID atau key unik agar presisi
                      final bool isItemChecked = selectedItems.any(
                        (element) => element['_id'] == item['_id'],
                      );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (showDateHeader)
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 14.0,
                                bottom: 16.0,
                              ),
                              child: Text(
                                tanggalHeader,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  color: textDark.withValues(alpha: 0.4),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          RiwayatItemWidget(
                            item: item,
                            index: index,
                            isSelectionMode: isSelectionMode.value,
                            isChecked: isItemChecked,
                            onCheckboxChanged: (bool? value) {
                              if (value == true) {
                                selectedItems.add(item);
                              } else {
                                selectedItems.removeWhere(
                                  (element) => element['_id'] == item['_id'],
                                );
                              }
                            },
                            onCardTapInSelection: () {
                              if (isItemChecked) {
                                selectedItems.removeWhere(
                                  (element) => element['_id'] == item['_id'],
                                );
                              } else {
                                selectedItems.add(item);
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                }(),
              ),

              // --- 3. FLOATING BOTTOM BAR EXECUTOR ---
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: (isSelectionMode.value && selectedItems.isNotEmpty)
                    ? 80
                    : 0,
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                child: (isSelectionMode.value && selectedItems.isNotEmpty)
                    ? ElevatedButton.icon(
                        onPressed: () {
                          Get.defaultDialog(
                            title: "Hapus Riwayat",
                            middleText:
                                "Apakah kamu yakin ingin menghapus ${selectedItems.length} riwayat deteksi terpilih?",
                            textConfirm: "Hapus",
                            textCancel: "Batal",
                            confirmTextColor: Colors.white,
                            buttonColor: colorDelete,
                            onConfirm: () {
                              // Mengambil semua ID terpilih untuk dieksekusi hapus di database
                              final selectedIds =
                                  selectedItems.map((e) => e['_id']).toList();

                              // Sinkronisasi hapus lokal di controller
                              controller.historyList.removeWhere(
                                (element) =>
                                    selectedIds.contains(element['_id']),
                              );

                              isSelectionMode.value = false;
                              selectedItems.clear();
                              Get.back();
                              Get.snackbar(
                                "Sukses",
                                "Riwayat berhasil dihapus",
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.delete, color: Colors.white),
                        label: Text(
                          'Hapus Riwayat (${selectedItems.length})',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorDelete,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          );
        }),
      ),
    );
  }
}
