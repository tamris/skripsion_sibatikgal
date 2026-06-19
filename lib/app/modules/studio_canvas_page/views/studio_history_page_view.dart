import 'package:batikara/app/modules/studio_canvas_page/views/detail_studio_history_canvas.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/studio_canvas_page_controller.dart';

class StudioHistoryPageView extends StatelessWidget {
  const StudioHistoryPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StudioCanvasPageController>();
    const Color cDark = Color(0xFF1A1208);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F8F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F8F4),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Galeri Karyaku',
          style: GoogleFonts.lora(
            color: cDark,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoadingDrafts.value) {
          return const Center(child: CircularProgressIndicator(color: cDark));
        }

        if (controller.savedDraftsList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.edit_note_rounded,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum Ada Draf',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: cDark,
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Kamu belum memiliki progres membatik yang disimpan. Silakan coret canvas dan simpan terlebih dahulu.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(20),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.78,
          ),
          itemCount: controller.savedDraftsList.length,
          itemBuilder: (context, index) {
            final batik = controller.savedDraftsList[index];

            return GestureDetector(
              onTap: () async {
                // 1. Ambil ID dengan Validasi Fallback Dua Arah
                String validBatikId = batik.id;
                if (validBatikId.isEmpty) {
                  try {
                    validBatikId = (batik as dynamic).sId ?? '';
                  } catch (_) {}
                }

                final String batikName = batik.name;

                if (validBatikId.isEmpty && batikName.isEmpty) {
                  Get.snackbar(
                    'Gagal Memproses',
                    'Identitas draf motif tidak ditemukan. Silakan coba kembali.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                  return;
                }

                // 2. Lacak Index Master Berdasarkan ID / Nama Motif
                int mainIndex = controller.batikList.indexWhere(
                  (element) =>
                      element.id == validBatikId || element.name == batikName,
                );

                if (mainIndex == -1) {
                  mainIndex = controller.batikList.indexWhere((element) {
                    try {
                      return (element as dynamic).sId == validBatikId;
                    } catch (_) {
                      return false;
                    }
                  });
                }

                // 3. Kunci Target Index di Controller
                if (mainIndex != -1) {
                  controller.selectedBatikIndex.value = mainIndex;
                  controller.clearCanvasState();
                } else {
                  if (index < controller.batikList.length) {
                    controller.selectedBatikIndex.value = index;
                    controller.clearCanvasState();
                  }
                }

                final String searchId = mainIndex != -1
                    ? controller.batikList[mainIndex].id
                    : validBatikId;

                // 🟢 🌟 IMPLEMENTASI UX LOADING SAAT DRAF DIKLIK 🌟
                // Menampilkan dialog lingkaran loading kecil transparan agar user tahu sistem sedang bekerja
                showDialog(
                  context: context,
                  barrierDismissible:
                      false, // User tidak bisa menutup paksa sebelum unduhan selesai
                  builder: (context) => const Center(
                    child: CircularProgressIndicator(color: cDark),
                  ),
                );

                try {
                  // Mengunduh paket data koordinat goresan dari cloud backend Flask
                  await controller.loadUserCanvasDraft(searchId);
                } finally {
                  // Menutup dialog loading transparan begitu proses unduh selesai/gagal
                  Get.back();
                }

                // 5. Antarkan user masuk aman ke lembar draf history baru
                Get.to(() => const DetailStudioHistoryCanvas());
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.grey.withValues(alpha: 0.15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFECE5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          // 🟢 🌟 MENGGANTI IMAGE DENGAN CACHEDNETWORKIMAGE + SHIMMER EFFECT 🌟
                          child: CachedNetworkImage(
                            imageUrl: batik.imageUrl,
                            fit: BoxFit.cover,
                            // Tampilan kotak abu-abu berkilat yang estetik saat gambar diunduh
                            placeholder: (context, url) => Shimmer(
                              duration: const Duration(
                                seconds: 2,
                              ), // kecepatan kilatan animasi
                              interval: const Duration(
                                milliseconds: 500,
                              ), // jeda antar kilatan
                              color:
                                  Colors.grey.shade100, // warna kilatan shimmer
                              colorOpacity: 0.5,
                              enabled: true,
                              direction:
                                  const ShimmerDirection.fromLBRT(), // arah gerakan kilat
                              child: Container(
                                color: Colors
                                    .grey
                                    .shade300, // warna dasar kotak draf batik
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.broken_image,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 12,
                        right: 12,
                        bottom: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            batik.name,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: cDark,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.edit_note_rounded,
                                size: 14,
                                color: Colors.brown,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Klik untuk Lanjut',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.brown,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}