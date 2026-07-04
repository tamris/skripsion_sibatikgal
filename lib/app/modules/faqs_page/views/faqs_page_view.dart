import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/faqs_page_controller.dart';

class FaqsPageView extends GetView<FaqsPageController> {
  const FaqsPageView({super.key});

  @override
  Widget build(BuildContext context) {
    // Palet warna konsisten Batikara
    const bgCanvas = Color(0xFFFAF7F2);
    const darkBrown = Color(0xFF1C1308);
    const textMuted = Color(0xFF7A7062);
    const accentGold = Color(0xFFFBBF24);

    // List dummy FAQs data untuk mengisi halaman secara terstruktur
    final List<Map<String, String>> faqData = [
      {
        'q': 'Apa itu aplikasi Sibatikgal?',
        'a':
            'Sibatikgal adalah aplikasi berbasis mobile yang dikembangkan untuk membantu mendeteksi, mengenali, serta memberikan edukasi informasi mengenai motif-motif lokal khas Batik Tegalan menggunakan teknologi Computer Vision.'
      },
      {
        'q': 'Bagaimana cara mendeteksi motif batik?',
        'a':
            'Kamu cukup masuk ke menu deteksi kamera, posisikan kain Batik Tegalan di area yang cukup terang, lalu ambil gambar. Sistem akan otomatis menganalisis detail motif dan menampilkan hasilnya.'
      },
      {
        'q': 'Apakah aplikasi ini bisa digunakan secara offline?',
        'a':
            'Untuk proses deteksi motif batik yang akurat, aplikasi ini memerlukan koneksi internet aktif guna memproses data gambar ke server backend.'
      },
      {
        'q': 'Bagaimana jika motif tidak terdeteksi?',
        'a':
            'Pastikan kualitas gambar yang diambil cukup terang dan detail motif terlihat jelas. Jika masih gagal, kemungkinan motif tersebut belum masuk ke dalam dataset pelatihan sistem kami.'
      },
    ];

    return Scaffold(
      backgroundColor: bgCanvas,
      // ================= FIXED APP BAR =================
      appBar: AppBar(
        backgroundColor: bgCanvas,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Center(
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.all(10),
                child: const Icon(Icons.arrow_back, color: darkBrown, size: 20),
              ),
            ),
          ),
        ),
        title: Text(
          'FAQ & Bantuan',
          style: GoogleFonts.lora(
            color: darkBrown,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),

      // ================= BODY CONTENT =================
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          itemCount: faqData.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final item = faqData[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE6DFD5), width: 1),
              ),
              child: Theme(
                // Menghilangkan border garis bawaan ExpansionTile saat dibuka
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  iconColor: accentGold,
                  collapsedIconColor: textMuted,
                  tilePadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  title: Text(
                    item['q']!,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: darkBrown,
                      height: 1.3,
                    ),
                  ),
                  children: [
                    Text(
                      item['a']!,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: textMuted,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
