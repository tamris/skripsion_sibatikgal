import 'package:batikara/app/modules/deteksi_page/views/detail_history_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Impor cache gambar premium
import 'package:shimmer_animation/shimmer_animation.dart'; // Impor paket shimmer andalanmu

class RiwayatItemWidget extends StatelessWidget {
  final Map<String, dynamic> item;
  final bool isSelectionMode;
  final bool isChecked;
  final int index;
  final ValueChanged<bool?> onCheckboxChanged;
  final VoidCallback onCardTapInSelection;

  const RiwayatItemWidget({
    super.key,
    required this.item,
    required this.isSelectionMode,
    required this.isChecked,
    required this.index,
    required this.onCheckboxChanged,
    required this.onCardTapInSelection,
  });

  @override
  Widget build(BuildContext context) {
    const colorPrimary = Color(0xFF795548);
    const colorCardBg = Color(0xFFFFFBF7);
    const textDark = Color(0xFF3E2723);
    const colorTimelineLine = Color(0xFFEFE7DD);

    final List<Color> dynamicPastelColors = [
      const Color(0xFFF3E5D8),
      const Color(0xFFE8F5E9),
      const Color(0xFFF5E6E8),
      const Color(0xFFE8EAF6),
    ];

    final List<IconData> dynamicIcons = [
      Icons.blur_circular,
      Icons.grid_view_rounded,
      Icons.gesture_rounded,
      Icons.notes_rounded,
    ];

    final String namaMotif = item['nama_motif'] ?? 'Batik';
    final String fullImageUrl = item['full_image_url'] ?? '';

    String jam = '00:00';
    if (item['created_at'] != null) {
      try {
        DateTime dateTime = DateTime.parse(item['created_at'].toString()).toLocal();
        jam = "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
      } catch (_) {}
    }

    final Color currentBoxColor = dynamicPastelColors[index % dynamicPastelColors.length];
    final IconData currentIcon = dynamicIcons[index % dynamicIcons.length];

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Sisi Kiri: Node Penanda Waktu & Garis Timeline
          Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isSelectionMode ? 24 : 16,
                height: isSelectionMode ? 24 : 16,
                margin: EdgeInsets.only(
                  top: isSelectionMode ? 0 : 4,
                  bottom: isSelectionMode ? 0 : 4,
                ),
                child: isSelectionMode
                    ? Checkbox(
                        value: isChecked,
                        activeColor: colorPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        side: const BorderSide(color: colorPrimary, width: 1.5),
                        onChanged: onCheckboxChanged,
                      )
                    : Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorPrimary,
                        ),
                      ),
              ),
              Expanded(
                child: Container(
                  width: 2,
                  color: colorTimelineLine,
                ),
              ),
            ],
          ),
          SizedBox(width: isSelectionMode ? 8 : 16),

          // Sisi Kanan: Konten Jam, Panah Navigasi, dan Card Informasi
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      jam,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: textDark.withOpacity(0.35),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (!isSelectionMode)
                      Icon(
                        Icons.chevron_right_rounded,
                        color: textDark.withOpacity(0.25),
                        size: 18,
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: InkWell(
                    onTap: () {
                      if (isSelectionMode) {
                        onCardTapInSelection();
                      } else {
                        Get.to(() => DetailHistoryView(
                              historyData: {
                                'nama_motif': namaMotif,
                                'waktu_relatif': item['waktu_relatif'] ?? 'Baru saja',
                                'full_image_url': fullImageUrl,
                                'makna': item['makna'] ?? 'Makna tidak ditemukan.',
                                'confidence': item['confidence'] ?? '0%',
                              },
                            ));
                      }
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isChecked ? colorPrimary.withOpacity(0.03) : colorCardBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isChecked ? colorPrimary.withOpacity(0.4) : colorTimelineLine.withOpacity(0.6),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              width: 60,
                              height: 60,
                              color: currentBoxColor,
                              // INTEGRASI BERHASIL: Menggunakan CachedNetworkImage + Shimmer Internal Transparan Lembut
                              child: fullImageUrl.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: fullImageUrl,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Shimmer(
                                        color: const Color(0xFFFAF7F2),
                                        colorOpacity: 0.5,
                                        duration: const Duration(milliseconds: 1200),
                                        child: Container(color: Colors.transparent),
                                      ),
                                      errorWidget: (c, e, s) => Center(
                                        child: Icon(currentIcon, color: colorPrimary.withOpacity(0.5), size: 24),
                                      ),
                                    )
                                  : Center(
                                      child: Icon(currentIcon, color: colorPrimary.withOpacity(0.5), size: 24),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              namaMotif,
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: textDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}