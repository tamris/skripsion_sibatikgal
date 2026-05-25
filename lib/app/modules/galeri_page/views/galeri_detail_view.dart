import 'package:batikara/app/data/models/batik_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class GaleriDetailView extends StatelessWidget {
  final BatikModel batik;
  const GaleriDetailView({super.key, required this.batik});

  @override
  Widget build(BuildContext context) {
    const Color bgImage = Color(0xFFEEDCC5);
    const Color textDark = Color(0xFF3E2723);
    const Color categoryLabelBg = Color(0xFFF3EAE0);
    const Color buttonColor = Color(0xFF7A5C43);

    // Parsing warna dominan string ke widget bulatan warna jika diperlukan
    // (Misal data API berupa string hex dipisah koma atau spasi)
    Color hexToColor(String hexString) {
      // Menghapus tanda '#' jika ada
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));

      // Mengembalikan objek Color, jika parsing gagal akan me-return warna grey sebagai fallback
      return Color(int.tryParse(buffer.toString(), radix: 16) ?? 0xFF9E9E9E);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Image Area dengan background kecokelatan kustom
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height *
                      0.4, // Naikkan sedikit tingginya agar lebih proporsional (40% layar)
                  decoration: const BoxDecoration(color: bgImage),
                  child: batik.image.isNotEmpty
                      ? Image.network(
                          batik.image,
                          width: double
                              .infinity, // Paksa lebar gambar memenuhi layar
                          height: double
                              .infinity, // Paksa tinggi gambar memenuhi container
                          fit: BoxFit
                              .cover, // MEMASTIKAN GAMBAR FULL TANPA SISA RUANG KOSONG
                        )
                      : const Center(
                          child: Icon(
                            Icons.image,
                            size: 100,
                            color: Colors.grey,
                          ),
                        ),
                ),
                // Content Body
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Kategori Tag
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: categoryLabelBg,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          batik.category,
                          style: GoogleFonts.lora(
                            color: buttonColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Nama Motif
                      Text(
                        batik.title,
                        style: GoogleFonts.lora(
                          color: textDark,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Makna / Deskripsi Singkat
                      Text(
                        batik.deskripsi,
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.mulish(
                          color: textDark.withValues(alpha: 0.7),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),

                      // Section: Informasi Motif
                      Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            size: 20,
                            color: textDark,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Informasi Motif',
                            style: GoogleFonts.lora(
                              color: textDark.withValues(alpha: 0.9),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Detail Metadata (Kategori, Teknik, Filosofi)
                      _buildDetailRow('Teknik', batik.technique),
                      _buildDetailRow(
                        'Filosofi',
                        batik.filosophy,
                      ), // Menggunakan makna sebagai filosofi sesuai model
                      // Row Warna Dominan
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Warna Dominan',
                                style: GoogleFonts.lora(
                                  color: textDark.withValues(alpha: 0.5),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 0,
                              child: batik.dominantColors.isEmpty
                                  ? Text(
                                      '-',
                                      style: GoogleFonts.mulish(
                                        color: textDark,
                                      ),
                                    )
                                  : Wrap(
                                      // Menggunakan Wrap agar jika warna sangat banyak, posisinya otomatis turun ke bawah rapi
                                      spacing: 6.0,
                                      runSpacing: 4.0,
                                      children: batik.dominantColors.map((
                                        hexCode,
                                      ) {
                                        // Mengonversi string hex dari DB menjadi objek Color Flutter
                                        Color dynamicColor = hexToColor(
                                          hexCode,
                                        );
                                        return _buildColorCircle(dynamicColor);
                                      }).toList(),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),

                      // Section: Sejarah Singkat
                      Text(
                        'Sejarah Singkat',
                        style: GoogleFonts.lora(
                          color: textDark.withValues(alpha: 0.9),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Box Sejarah dengan Border Kiri Cokelat khas mockup
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: categoryLabelBg,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                          border: Border(
                            left: BorderSide(color: buttonColor, width: 4),
                          ),
                        ),
                        child: Text(
                          batik.history,
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.mulish(
                            color: textDark,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 2,
                          ),
                          onPressed: () {
                            // Aksi navigasi ke peta lokasi pengrajin
                          },
                          child: Text(
                            'Lihat Lokasi Pengrajin',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      // Spacing tambahan di bawah agar content tidak tertutup tombol sticky
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Custom Sticky Top App Bar (Back button & Favorite)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: textDark),
                        onPressed: () => Get.back(),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(
                          Icons.favorite_border,
                          color: buttonColor,
                        ),
                        onPressed: () {
                          // Implementasi fungsi favorit jika ada
                        },
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

  Widget _buildDetailRow(String label, String value) {
    const Color textDark = Color(0xFF3E2723);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: GoogleFonts.lora(
                color: textDark.withValues(alpha: 0.5),
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.lora(
                color: textDark,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorCircle(Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4),
        ],
      ),
    );
  }
}
