import 'package:batikara/app/data/models/informasi_model.dart';
import 'package:batikara/app/modules/informasi_page/views/informasi_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class RelatedCardWidget extends StatelessWidget {
  final InformasiModel item;
  final Color baseColor;

  const RelatedCardWidget({
    Key? key,
    required this.item,
    required this.baseColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color cardBgColor = const Color(0xFFFFFDF9);
    Color borderColor = baseColor.withValues(alpha: 1);

    return GestureDetector(
      onTap: () {
        // Berpindah ke halaman detail artikel yang baru dan menggantikan halaman saat ini
        Get.off(
          () => const InformasiDetailPage(),
          arguments: item,
          preventDuplicates: false,
        );
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Row(
            children: [
              // Kiri: Gambar / Blok Warna Pastel
              Container(
                width: 120,
                height: double.infinity,
                color: baseColor,
                child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                    ? Image.network(item.imageUrl!, fit: BoxFit.cover)
                    : const Icon(
                        Icons.image_outlined,
                        color: Colors.black26,
                        size: 32,
                      ),
              ),
              // Kanan: Teks
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.title ?? "",
                        maxLines: 2,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF333333),
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.categori ?? "Umum",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFB08968),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}