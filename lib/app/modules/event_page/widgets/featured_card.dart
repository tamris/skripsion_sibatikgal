import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/models/event_model.dart';

class FeaturedCard extends StatelessWidget {
  final EventModel event;
  const FeaturedCard({super.key, required this.event});

  static const Color cDark = Color(0xFF1A1208);
  static const Color cGold = Color(0xFFFFD264);
  static const Color cGreen = Color(0xFF2E7D32);
  static const Color cGreenBg = Color(0xFFE8F5E9);
  static const Color cOrange = Color(0xFFE65100);
  static const Color cOrangeBg = Color(0xFFFFF3E0);

  @override
  Widget build(BuildContext context) {
    final bool isFree = event.isFree == true;

    return GestureDetector(
      onTap: () => Get.toNamed('/event-detail', arguments: event),
      child: Container(
        decoration: BoxDecoration(
          color: cDark,
          borderRadius: BorderRadius.circular(20),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _buildImage(event.bannerImageUrl),
                  Positioned(
                    top: 14,
                    right: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: cDark.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.calendar_today_outlined,
                              size: 12, color: cGold),
                          const SizedBox(width: 4),
                          Text(event.formattedDate,
                              style: GoogleFonts.poppins(
                                  fontSize: 12, color: cGold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
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
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              height: 1.6),
                          maxLines: 2,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: isFree ? cGreenBg : cOrangeBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isFree ? 'GRATIS' : event.formattedCurrency,
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isFree ? cGreen : cOrange),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 12, color: Color(0x66FFFFFF)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.displayAddress,
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: Color(0x66FFFFFF)),
                          maxLines: 1,
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
  }

  Widget _buildImage(String? url) {
    if (url != null && url.isNotEmpty) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallback(),
        loadingBuilder: (_, child, progress) =>
            progress == null ? child : _fallback(loading: true),
      );
    }
    return _fallback();
  }

  Widget _fallback({bool loading = false}) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2C1A0C), Color(0xFF6A3A15), Color(0xFFA06030)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: loading
            ? const CircularProgressIndicator(color: cGold, strokeWidth: 2)
            : const Icon(Icons.image_outlined, size: 32, color: Colors.white24),
      ),
    );
  }
}
