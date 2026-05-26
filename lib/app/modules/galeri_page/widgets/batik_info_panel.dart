import 'package:flutter/material.dart';
import 'package:batikara/app/data/models/batik_model.dart';
import 'package:google_fonts/google_fonts.dart';

class BatikInfoPanel extends StatelessWidget {
  final BatikModel batik;
  final Color textDark;

  const BatikInfoPanel({
    super.key,
    required this.batik,
    required this.textDark,
  });

  Color hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.tryParse(buffer.toString(), radix: 16) ?? 0xFF9E9E9E);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.info_outline, size: 20, color: textDark),
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
        _buildDetailRow('Teknik', batik.technique),
        _buildDetailRow('Filosofi', batik.filosophy),

        // Warna Dominan Row
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
                flex:
                    5, // Dibuat lebih lebar agar bulatan warna punya ruang mepet ke kanan
                child: batik.dominantColors.isEmpty
                    ? Text(
                        '-',
                        textAlign:
                            TextAlign.right, // Teks strip juga ikut rata kanan
                        style: GoogleFonts.mulish(color: textDark),
                      )
                    : Wrap(
                        alignment: WrapAlignment
                            .end, // <--- KUNCINYA DI SINI: Memaksa isi Wrap rata kanan
                        spacing: 6.0,
                        runSpacing: 4.0,
                        children: batik.dominantColors.map((hexCode) {
                          return _buildColorCircle(hexToColor(hexCode));
                        }).toList(),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
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