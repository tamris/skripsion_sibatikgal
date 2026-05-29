import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/models/event_model.dart';

class DetailContentSection extends StatelessWidget {
  final EventModel event;
  final Function(String lat, String lng) onOpenMap;
  final Function(String url) onOpenRegistration;

  // Satukan semua konfigurasi warna asli racikanmu di sini
  static const Color cDark = Color(0xFF1A1208);
  static const Color cBorder = Color(0xFFE8E4DC);
  static const Color cKremChip = Color(0xFFF0EAD8);
  static const Color cBrown = Color(0xFF7A3B10);
  static const Color cBrownLight = Color(0xFFC05A1A);
  static const Color cTextSub = Color(0xFF9C8B7A);
  static const Color cTextBody = Color(0xFF6B5A4A);
  static const Color cGreen = Color(0xFF2E7D32);
  static const Color cGold = Color(0xFFFFD264);

  const DetailContentSection({
    super.key,
    required this.event,
    required this.onOpenMap,
    required this.onOpenRegistration,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Bagian Judul & Kategori
        _buildTitleSection(event),

        // 2. Bagian Grid Info (Waktu & Tiket)
        _buildInfoGrid(event),

        const _SDivider(),

        // 3. Bagian Tentang Event (Deskripsi)
        _buildDeskripsi(event),

        const _SDivider(),

        // 4. Bagian Lokasi Event
        _buildLokasi(event),

        // 5. Bagian Pendaftaran — Hanya muncul jika ada registration_url
        if (event.hasRegistrationUrl) ...[
          const _SDivider(),
          _buildPendaftaran(event),
        ],
      ],
    );
  }

  // ── 1. TITLE SECTION ─────────────────────────────────────
  Widget _buildTitleSection(EventModel event) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (event.kategori != null && event.kategori!.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: cKremChip,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                event.kategori!,
                style: GoogleFonts.poppins(
                    fontSize: 12, fontWeight: FontWeight.w500, color: cBrown),
              ),
            ),
          Text(
            event.title ?? '-',
            style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: cDark,
                height: 1.3,
                letterSpacing: -0.3),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined,
                  size: 13, color: cBrownLight),
              const SizedBox(width: 6),
              Text(
                '${event.formattedDate} · ${event.formattedTime}',
                style: GoogleFonts.poppins(fontSize: 12, color: cTextSub),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── 2. INFO GRID ─────────────────────────────────────────
  Widget _buildInfoGrid(EventModel event) {
    final bool isFree = event.isFree == true;
    final String tiketLabel = isFree ? 'Gratis' : event.formattedCurrency;
    final Color tiketColor = isFree ? cGreen : cBrown;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      child: Row(
        children: [
          Expanded(
            child: _InfoCard(
              icon: Icons.access_time_rounded,
              label: 'Waktu Mulai',
              value: event.formattedTime,
              valueColor: cDark,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _InfoCard(
              icon: Icons.confirmation_number_outlined,
              label: 'Tiket',
              value: tiketLabel,
              valueColor: tiketColor,
            ),
          ),
        ],
      ),
    );
  }

  // ── 3. DESKRIPSI ─────────────────────────────────────────
  Widget _buildDeskripsi(EventModel event) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(label: 'Tentang Event'),
          const SizedBox(height: 10),
          Text(
            event.description?.isNotEmpty == true
                ? event.description!
                : 'Tidak ada deskripsi tersedia.',
            style: GoogleFonts.mulish(
                fontSize: 14, color: cTextBody, height: 1.85),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  // ── 4. LOKASI ────────────────────────────────────────────
  Widget _buildLokasi(EventModel event) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(label: 'Lokasi Event'),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: cBorder, width: 0.5),
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: cKremChip,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.location_on_outlined,
                          size: 20, color: cBrown),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        event.displayAddress,
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: cDark,
                            height: 1.55),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: () => onOpenMap(
                    event.latitude ?? '0',
                    event.longitude ?? '0',
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    decoration: BoxDecoration(
                      color: cKremChip,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.navigation_outlined,
                            size: 15, color: cBrown),
                        const SizedBox(width: 8),
                        Text('Buka di Google Maps',
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: cBrown)),
                      ],
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

  // ── 5. PENDAFTARAN ───────────────────────────────────────
  Widget _buildPendaftaran(EventModel event) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(label: 'Pendaftaran'),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: cBorder, width: 0.5),
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: cKremChip,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.copy, size: 20, color: cBrown),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Daftar Sekarang',
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: cDark)),
                          const SizedBox(height: 2),
                          Text('Klik tombol di bawah untuk mendaftar',
                              style: GoogleFonts.poppins(
                                  fontSize: 10, color: cTextSub)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => onOpenRegistration(event.registrationUrl!),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    decoration: BoxDecoration(
                      color: cDark,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.open_in_new_rounded,
                            size: 15, color: cGold),
                        const SizedBox(width: 8),
                        Text('Buka Link Pendaftaran',
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: cGold)),
                      ],
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

// ── REUSABLE INTERNAL SUB-WIDGETS ─────────────────────────
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E4DC), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: const Color(0xFFF0EAD8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 15, color: const Color(0xFF7A3B10)),
          ),
          const SizedBox(height: 8),
          Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 9.5, color: const Color(0xFF9C8B7A))),
          const SizedBox(height: 2),
          Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: valueColor)),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: const Color(0xFFC05A1A),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1A1208))),
      ],
    );
  }
}

class _SDivider extends StatelessWidget {
  const _SDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: Divider(
          color: Color.fromARGB(255, 199, 199, 199),
          thickness: 0.5,
          height: 28),
    );
  }
}
