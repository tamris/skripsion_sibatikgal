import 'package:batikara/app/data/models/sejarah_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/sejarah_page_controller.dart';

class SejarahPageView extends GetView<SejarahPageController> {
  const SejarahPageView({super.key});

  // ── Warna brand ──────────────────────────────────────────
  static const Color cDark = Color(0xFF1A1208);
  static const Color cKrem = Color(0xFFF7F4EE);
  static const Color cKremCard = Color(0xFFFAF6EE);
  static const Color cKremChip = Color(0xFFF0EAD8);
  static const Color cBorder = Color(0xFFE8E4DC);
  static const Color cLine = Color(0xFFE0D8CC);
  static const Color cGold = Color(0xFFFFD264);
  static const Color cBrown = Color(0xFF7A3B10);
  static const Color cBrownMid = Color(0xFFC07840);
  static const Color cBrownLight = Color(0xFFC05A1A);
  static const Color cTextSub = Color(0xFF9C8B7A);
  static const Color cTextBody = Color(0xFF6B5A4A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cKrem,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildIntroBanner(),
                    const SizedBox(height: 8),
                    _buildTimeline(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── HEADER ─────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
      child: Row(
        children: [
          _circleBtn(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back, size: 20, color: cDark),
          ),
          Expanded(
            child: Column(
              children: [
                Text('SEJARAH',
                    style: GoogleFonts.lora(
                        fontSize: 12,
                        color: cTextSub,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w500)),
                SizedBox(height: 2),
                Text('Batik Tegalan',
                    style: GoogleFonts.lora(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: cDark,
                        letterSpacing: -0.3)),
              ],
            ),
          ),
          _circleBtn(
            onTap: controller.shareSejarah,
            child: const Icon(Icons.share, size: 20, color: cDark),
          ),
        ],
      ),
    );
  }

  Widget _circleBtn({required VoidCallback onTap, required Widget child}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 45,
        height: 45,
        child: Center(child: child),
      ),
    );
  }

  // ── INTRO BANNER ───────────────────────────────────────────
  Widget _buildIntroBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: cDark,
          borderRadius: BorderRadius.circular(22),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            // Ornamen lingkaran sudut kanan atas
            Positioned(
              right: -10,
              top: -10,
              child: Opacity(
                opacity: 0.07,
                child: CustomPaint(
                  size: const Size(110, 110),
                  painter: _CircleOrnamanetPainter(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Perjalanan panjang sejak',
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: Color(0x73FFFFFF))),
                  const SizedBox(height: 4),
                  Text('± Abad 17',
                      style: GoogleFonts.poppins(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: cGold,
                          letterSpacing: -1)),
                  const SizedBox(height: 6),
                  Text(
                    'Dari lereng selatan Tegal hingga dikenal sebagai warisan budaya pesisir Jawa yang kaya makna.',
                    style: GoogleFonts.mulish(
                        fontSize: 16, color: Color(0x73FFFFFF), height: 1.7),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.keyboard_arrow_down_rounded,
                          size: 16, color: cGold),
                      SizedBox(width: 4),
                      Text('Scroll untuk menjelajahi',
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Color(0x99FFD264))),
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

  // ── TIMELINE (FIXED) ───────────────────────────────────────
  Widget _buildTimeline() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Stack(
        // Menggunakan Stack menggantikan IntrinsicHeight + Row
        children: [
          // Garis vertikal yang posisinya mengunci dari atas sampai bawah card terakhir
          Positioned(
            left: 36, // Menyesuaikan jarak agar sejajar dengan posisi DOT
            top: 22, // Mulai dari titik tengah DOT pertama
            bottom:
                40, // Berhenti sebelum dasar card terakhir (sesuaikan estetika)
            child: Container(
              width: 1.5,
              color: cLine,
            ),
          ),

          // Konten Utama (Kumpulan Card)
          Column(
            children: [
              for (int i = 0; i < controller.sejarahList.length; i++) ...[
                _buildEraCard(controller.sejarahList[i], i),
                if (i < controller.connectors.length)
                  _buildConnector(controller.connectors[i]),
              ]
            ],
          ),
        ],
      ),
    );
  }

  // ── ERA CARD ───────────────────────────────────────────────
// ── ERA CARD (FIXED PADDING) ───────────────────────────────
  Widget _buildEraCard(SejarahModel data, int index) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // CARD (Sekarang menggunakan padding kiri 52 agar teks/card tidak menutupi garis)
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 60, bottom: 4),
          child: data.isAktif ? _buildCardAktif(data) : _buildCardNormal(data),
        ),
        // DOT (Diletakkan setelah card agar berada di layer atas, posisi di-pas-kan di atas garis)
        Positioned(
          left:
              30, // Jika ukuran terbesar dot adalah 20 (aktif), maka (36 - (20/2)) = 26 sampai 30 agar center dengan garis
          top: 22,
          child: _buildDot(data),
        ),
      ],
    );
  }

  Widget _buildDot(SejarahModel data) {
    if (data.isAktif) {
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: cDark,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: cDark.withOpacity(0.15),
              blurRadius: 0,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: cGold,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    }

    Color dotColor;
    if (data.era.contains('17')) {
      dotColor = cDark;
    } else if (data.era.contains('18')) {
      dotColor = cBrownMid;
    } else if (data.era.contains('19')) {
      dotColor = cBrown;
    } else {
      dotColor = const Color(0xFFEDE9E2);
    }

    final bool isHollow =
        data.era.contains('KOLONIAL') || data.era.contains('1950');

    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: isHollow ? const Color(0xFFEDE9E2) : dotColor,
        shape: BoxShape.circle,
        border: isHollow
            ? const Border.fromBorderSide(
                BorderSide(color: Color(0xFFC0B0A0), width: 2))
            : null,
        boxShadow: isHollow
            ? null
            : [
                BoxShadow(
                  color: dotColor.withOpacity(0.2),
                  blurRadius: 0,
                  spreadRadius: 4,
                ),
              ],
      ),
    );
  }

  // Card normal (light)
  Widget _buildCardNormal(SejarahModel data) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cBorder, width: 0.5),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ERA LABEL
          Text(data.era,
              style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: _eraColor(data.era),
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 5),
          // JUDUL
          Text(data.judul,
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: cDark,
                  height: 1.3)),
          const SizedBox(height: 8),
          // DIVIDER
          Container(width: 32, height: 1.5, color: cBorder),
          const SizedBox(height: 10),
          // DESKRIPSI
          Text(data.deskripsi,
              style: GoogleFonts.mulish(
                  fontSize: 14, color: cTextBody, height: 1.8)),
          // INFO CARD (abad 18)
          if (data.infoCardJudul != null) ...[
            const SizedBox(height: 12),
            _buildInfoCard(data),
          ],
          // QUOTE (kolonial)
          if (data.quote != null) ...[
            const SizedBox(height: 12),
            _buildQuoteCard(data.quote!),
          ],
          // STATS (1950-1990)
          if (data.stats != null) ...[
            const SizedBox(height: 12),
            _buildStats(data.stats!),
          ],
          // CHIPS (motif)
          if (data.motifChips.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: data.motifChips
                  .map((chip) => _buildChip(chip, dark: false))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  // Card era sekarang (dark)
  Widget _buildCardAktif(SejarahModel data) {
    return Container(
      decoration: BoxDecoration(
        color: cDark,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data.era,
                  style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Color(0x66FFFFFF),
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w500)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: cGold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: cGold.withOpacity(0.3), width: 0.5),
                ),
                child: Text('Kini',
                    style: GoogleFonts.poppins(fontSize: 10, color: cGold)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(data.judul,
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: cGold,
                  height: 1.3)),
          const SizedBox(height: 8),
          Container(width: 32, height: 1.5, color: Colors.white12),
          const SizedBox(height: 10),
          Text(data.deskripsi,
              style: GoogleFonts.mulish(
                  fontSize: 14, color: Color(0x80FFFFFF), height: 1.8)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: data.motifChips
                .map((chip) => _buildChip(chip, dark: true))
                .toList(),
          ),
        ],
      ),
    );
  }

  // ── SUB WIDGETS ────────────────────────────────────────────

  Widget _buildInfoCard(SejarahModel data) {
    return Container(
      decoration: BoxDecoration(
        color: cKremCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEDE9E2), width: 0.5),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center, // Aman untuk baris horizontal pendek
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: cKremChip,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: CustomPaint(
                size: const Size(24, 24),
                painter: _FlowerOrnamentPainter(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.infoCardJudul!,
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: cDark)),
                const SizedBox(height: 2),
                Text(data.infoCardDeskripsi!,
                    style: GoogleFonts.mulish(
                        fontSize: 12, color: cTextSub, height: 1.6)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteCard(String quote) {
    return Container(
      decoration: BoxDecoration(
        color: cKremCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEDE9E2), width: 0.5),
      ),
      child: IntrinsicHeight(
        // Membatasi tinggi Row agar mengikuti tinggi Text di dalamnya
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 3,
              decoration: const BoxDecoration(
                // Tambah const jika statis
                color: cBrownLight,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  quote,
                  style: GoogleFonts.mulish(
                      fontSize: 12,
                      color: Color(0xFF7A5030),
                      height: 1.75,
                      fontStyle: FontStyle.italic),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStats(Map<String, String> stats) {
    return Row(
      children: stats.entries.map((e) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: e.key == stats.keys.first ? 8 : 0),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cKremCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFEDE9E2), width: 0.5),
            ),
            child: Column(
              children: [
                Text(e.key,
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: cDark)),
                const SizedBox(height: 2),
                Text(e.value,
                    style: GoogleFonts.poppins(fontSize: 10, color: cTextSub)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChip(String label, {required bool dark}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
      decoration: BoxDecoration(
        color: dark ? cGold.withOpacity(0.12) : cKremChip,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: dark ? cGold.withOpacity(0.25) : Colors.transparent,
          width: 0.5,
        ),
      ),
      child: Text(label,
          style:
              GoogleFonts.poppins(fontSize: 10, color: dark ? cGold : cBrown)),
    );
  }

  // ── CONNECTOR ──────────────────────────────────────────────
  Widget _buildConnector(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 16, left: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(child: Container(height: 0.5, color: cLine)),
            const SizedBox(width: 8),
            Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 11, color: Color(0xFFB0A090))),
            const SizedBox(width: 8),
            Expanded(child: Container(height: 0.5, color: cLine)),
          ],
        ),
      ),
    );
  }

  // ── HELPER ─────────────────────────────────────────────────
  Color _eraColor(String era) {
    if (era.contains('17')) return cTextSub;
    if (era.contains('18')) return cBrownMid;
    if (era.contains('19')) return cBrown;
    return cTextSub;
  }
}

// ── CUSTOM PAINTERS ────────────────────────────────────────

class _CircleOrnamanetPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, size.width * 0.45, paint);
    paint.strokeWidth = 0.6;
    canvas.drawCircle(center, size.width * 0.30, paint);
    paint.strokeWidth = 0.5;
    canvas.drawCircle(center, size.width * 0.15, paint);

    paint.strokeWidth = 0.4;
    canvas.drawLine(
        Offset(center.dx, 0), Offset(center.dx, size.height), paint);
    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _FlowerOrnamentPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFC07840)
      ..style = PaintingStyle.fill;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.4;

    // 4 kelopak
    final path1 = Path()
      ..moveTo(cx, cy - r)
      ..quadraticBezierTo(cx + r * 0.5, cy - r * 0.5, cx, cy)
      ..quadraticBezierTo(cx - r * 0.5, cy - r * 0.5, cx, cy - r);
    canvas.drawPath(
        path1, paint..color = const Color(0xFFC07840).withOpacity(0.5));

    final path2 = Path()
      ..moveTo(cx + r, cy)
      ..quadraticBezierTo(cx + r * 0.5, cy + r * 0.5, cx, cy)
      ..quadraticBezierTo(cx + r * 0.5, cy - r * 0.5, cx + r, cy);
    canvas.drawPath(path2, paint);

    final path3 = Path()
      ..moveTo(cx, cy + r)
      ..quadraticBezierTo(cx - r * 0.5, cy + r * 0.5, cx, cy)
      ..quadraticBezierTo(cx + r * 0.5, cy + r * 0.5, cx, cy + r);
    canvas.drawPath(
        path3, paint..color = const Color(0xFFC07840).withOpacity(0.5));

    final path4 = Path()
      ..moveTo(cx - r, cy)
      ..quadraticBezierTo(cx - r * 0.5, cy - r * 0.5, cx, cy)
      ..quadraticBezierTo(cx - r * 0.5, cy + r * 0.5, cx - r, cy);
    canvas.drawPath(path4, paint..color = const Color(0xFFC07840));

    // tengah
    canvas.drawCircle(Offset(cx, cy), r * 0.25,
        paint..color = const Color(0xFF7A3B10).withOpacity(0.5));
  }

  @override
  bool shouldRepaint(_) => false;
}
