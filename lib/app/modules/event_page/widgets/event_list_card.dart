import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/models/event_model.dart';

class EventListCard extends StatelessWidget {
  final EventModel event;
  const EventListCard({super.key, required this.event});

  static const Color cDark = Color(0xFF1A1208);
  static const Color cBrown = Color(0xFF7A3B10);
  static const Color cKremChip = Color(0xFFF0EAD8);
  static const Color cBorder = Color(0xFFE8E4DC);
  static const Color cTextSub = Color(0xFF9C8B7A);
  static const Color cBrownLight = Color(0xFFC05A1A);
  static const Color cGreen = Color(0xFF2E7D32);
  static const Color cGreenBg = Color(0xFFE8F5E9);
  static const Color cOrange = Color(0xFFE65100);
  static const Color cOrangeBg = Color(0xFFFFF3E0);

  @override
  Widget build(BuildContext context) {
    final bool isFree = event.isFree == true;
    final (day, month) = _parseDate(event.eventDate);

    return GestureDetector(
      onTap: () => Get.toNamed('/event-detail', arguments: event),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cBorder, width: 0.5),
        ),
        clipBehavior: Clip.hardEdge,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 80,
                color: cKremChip,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(day,
                        style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: cBrown,
                            height: 1)),
                    const SizedBox(height: 3),
                    Text(month,
                        style: GoogleFonts.poppins(
                            fontSize: 9, color: cTextSub, letterSpacing: .5)),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              event.title ?? '-',
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: cDark,
                                  height: 1.35),
                              maxLines: 2,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: isFree ? cGreenBg : cOrangeBg,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            // KODE BARU
                            child: Text(
                              isFree ? 'GRATIS' : 'Rp ${event.formattedPrice}',
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isFree ? cGreen : cOrange),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 13, color: cBrownLight),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.displayAddress,
                              style: GoogleFonts.poppins(
                                  fontSize: 13, color: cTextSub),
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      if (event.kategori != null &&
                          event.kategori!.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: cKremChip,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(event.kategori!,
                              style: GoogleFonts.poppins(
                                  fontSize: 12, color: cBrown)),
                        ),
                      ],
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

  (String, String) _parseDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return ('-', '-');
    try {
      final dt = DateTime.parse(dateStr);
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Okt',
        'Nov',
        'Des'
      ];
      return (dt.day.toString().padLeft(2, '0'), months[dt.month - 1]);
    } catch (_) {
      return ('-', '-');
    }
  }
}
