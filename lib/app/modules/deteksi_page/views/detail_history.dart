import 'package:batikara/app/data/service/galeri_service.dart';
import 'package:batikara/app/modules/galeri_page/views/galeri_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailHistoryView extends StatelessWidget {
  // Parsing data riwayat langsung dari item list yang di-tap
  final Map<String, dynamic> historyData;

  const DetailHistoryView({super.key, required this.historyData});

  // Fungsi navigasi langsung ke detail galeri (Sama dengan logika kamu di HasilDeteksiView)
  Future<void> _openHistoryMotifDetail() async {
    final String targetMotifName = (historyData['nama_motif'] ?? '').trim();
    if (targetMotifName.isEmpty) {
      Get.snackbar(
        'Motif tidak tersedia',
        'Data riwayat tidak memiliki nama motif yang valid.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    final batik = await GaleriService.fetchBatikByMotifName(targetMotifName);

    if (Get.isDialogOpen ?? false) {
      Get.back();
    }

    if (batik == null) {
      Get.snackbar(
        'Detail tidak ditemukan',
        'Motif "$targetMotifName" belum tersedia di data galeri.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.to(() => GaleriDetailView(batik: batik));
  }

  @override
  Widget build(BuildContext context) {
    // Palet warna kesatuan tema budaya kamu
    const colorPrimary = Color(0xFF795548);
    const colorBgScreen = Color(0xFFFCF9F6);
    const colorCardBg = Color(0xFFF5EFE6);
    const textDark = Color(0xFF3E2723);

    // Ekstraksi data riwayat dari lemparan parameter
    final String namaMotif = historyData['nama_motif'] ?? 'Batik';
    final String tanggalRelatif = historyData['waktu_relatif'] ?? 'Baru saja';
    final String fullImageUrl = historyData['full_image_url'] ?? '';
    final String filosofi = historyData['makna'] ?? 'Makna tidak ditemukan.';

    // Tombol lingkaran tipis untuk top bar sesuai desain
    final decorationTopButton = BoxDecoration(
      color: colorCardBg,
      borderRadius: BorderRadius.circular(14),
    );

    return Scaffold(
      backgroundColor: colorBgScreen,
      body: SafeArea(
        child: Column(
          children: [
            // --- 1. CUSTOM TOP BAR (SIMETRIS KIRI & KANAN) ---
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 12.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Tombol Back Kiri
                  Container(
                    decoration: decorationTopButton,
                    child: IconButton(
                      onPressed: () => Navigator.pop(
                        context,
                      ), // Kembali ke halaman utama deteksi
                      icon: const Icon(
                        Icons.arrow_back,
                        color: textDark,
                        size: 20,
                      ),
                    ),
                  ),
                  // Judul Tengah
                  Text(
                    'Riwayat Deteksi', // Menggunakan judul yang sama agar UI konsisten penuh
                    style: GoogleFonts.lora(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                  // Tombol Share Kanan
                  Container(
                    decoration: decorationTopButton,
                    child: IconButton(
                      onPressed: () {
                        // Fitur share data riwayat skripsi
                      },
                      icon: const Icon(
                        Icons.share_outlined,
                        color: textDark,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: Color(0xFFEFE7DD)),

            // --- INTERNALS SCROLLABLE CONTENT ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- 2. WADAH GAMBAR DARI DATABASE DENGAN NETWORK IMAGE ---
                    Container(
                      width: double.infinity,
                      height: 280,
                      decoration: BoxDecoration(
                        color: colorCardBg,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: fullImageUrl.isNotEmpty
                            ? Image.network(
                                fullImageUrl,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: colorPrimary,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) =>
                                    const Center(
                                  child: Icon(
                                    Icons.broken_image_outlined,
                                    color: colorPrimary,
                                    size: 32,
                                  ),
                                ),
                              )
                            : const Center(
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  color: colorPrimary,
                                  size: 32,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // --- 3. DETAIL NAMA MOTIF & AKURASI RIWAYAT ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            namaMotif,
                            style: GoogleFonts.lora(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: textDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Waktu Deteksi Sesuai Kartu Riwayat Yang Di-tap
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: textDark.withValues(alpha: 0.5),
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Terdeteksi $tanggalRelatif',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: textDark.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    const Divider(),
                    const SizedBox(height: 16),

                    // --- 4. MAKNA SINGKAT TEXT ---
                    Text(
                      'Makna Singkat',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      filosofi,
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.mulish(
                        fontSize: 16,
                        color: textDark.withValues(alpha: 0.7),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),

                    // --- 5. ACTION BUTTONS ---
                    Row(
                      children: [
                        // Tombol Lihat Detail Motif (Cokelat Tua) -> Mengarah ke GaleriDetailView
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _openHistoryMotifDetail,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: Text(
                              'Lihat Detail Motif',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                        // const SizedBox(width: 14),
                        // // Tombol Deteksi Ulang (Krem Lembut Berborder) -> Di riwayat fungsinya tinggal pop balik ke awal
                        // Expanded(
                        //   child: OutlinedButton(
                        //     onPressed: () => Navigator.pop(context),
                        //     style: OutlinedButton.styleFrom(
                        //       backgroundColor: colorCardBg,
                        //       padding: const EdgeInsets.symmetric(vertical: 18),
                        //       side: BorderSide(
                        //         color: colorPrimary.withValues(alpha: 0.2),
                        //         width: 1,
                        //       ),
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(18),
                        //       ),
                        //     ),
                        //     child: Text(
                        //       'Deteksi Ulang',
                        //       style: GoogleFonts.poppins(
                        //         color: textDark,
                        //         fontWeight: FontWeight.bold,
                        //         fontSize: 15,
                        //       ),
                        //     ),
                        //   ),
                        // ),
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
}
