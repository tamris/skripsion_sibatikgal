import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/models/event_model.dart';

class DetailBottomAction extends StatelessWidget {
  final EventModel event;
  final double bottomPadding;
  final Function(String lat, String lng) onOpenMap;
  final Function(String url) onOpenRegistration;

  static const Color cBorder = Color(0xFFE8E4DC);
  static const Color cDark = Color(0xFF1A1208);
  static const Color cGold = Color(0xFFFFD264);
  static const Color cBrown = Color(0xFF7A3B10);

  const DetailBottomAction({
    super.key,
    required this.event,
    required this.bottomPadding,
    required this.onOpenMap,
    required this.onOpenRegistration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 10, 16, 14 + bottomPadding * 0.5),
      decoration: const BoxDecoration(
        color: Color(0xFAF7F4EE),
        border: Border(top: BorderSide(color: cBorder, width: 0.5)),
      ),
      child: event.hasRegistrationUrl ? _buildCtaDua() : _buildCtaSatu(),
    );
  }

  // CTA 1 tombol asli milikmu jika tidak ada link
  Widget _buildCtaSatu() {
    return GestureDetector(
      onTap: () => onOpenMap(
        event.latitude ?? '0',
        event.longitude ?? '0',
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: cDark,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.navigation_rounded, size: 16, color: cGold),
            const SizedBox(width: 8),
            Text('Arahkan ke Lokasi',
                style: GoogleFonts.poppins(
                    fontSize: 13, fontWeight: FontWeight.w500, color: cGold)),
          ],
        ),
      ),
    );
  }

  // CTA 2 tombol asli milikmu jika ada link pendaftaran
  Widget _buildCtaDua() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => onOpenMap(
            event.latitude ?? '0',
            event.longitude ?? '0',
          ),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: cBorder, width: 0.5),
            ),
            child: const Icon(Icons.navigation_outlined, size: 20, color: cBrown),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () => onOpenRegistration(event.registrationUrl!),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                color: cDark,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.copy, size: 16, color: cGold),
                  const SizedBox(width: 8),
                  Text('Daftar Sekarang',
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: cGold)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}