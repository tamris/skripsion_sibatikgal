import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Helper untuk memotong alamat panjang agar hanya mengambil nama jalan/daerah depan saja
String ambilNamaDepanAlamat(String fullAddress) {
  if (fullAddress.isEmpty) return 'Tegal';
  List<String> parts = fullAddress.split(',');
  return parts.isNotEmpty ? parts[0].trim() : fullAddress;
}

/// Widget Badge Kategori reusable untuk MappingPageView & DetailPageView
Widget buildSharedSingleBadge(String label) {
  final String cleanLabel = label.toLowerCase().trim();

  Color bgColor = const Color(0xFFF5EFE1); // Default Cokelat Premium
  Color textColor = const Color(0xFF8B7355);

  if (cleanLabel == 'pengrajin') {
    bgColor = const Color(0xFFE8F8F5); // Mint Green
    textColor = const Color(0xFF117864);
  } else if (cleanLabel == 'toko') {
    bgColor = const Color(0xFFEAF2F8); // Soft Blue
    textColor = const Color(0xFF2471A3);
  } else if (cleanLabel == 'sentra batik') {
    bgColor = const Color(0xFFF4ECF7); // Soft Purple
    textColor = const Color(0xFF6C3483);
  } else if (cleanLabel == 'edukasi') {
    bgColor = const Color(0xFFFEF9E7); // Soft Yellow Gold
    textColor = const Color(0xFFB7950B);
  } else if (cleanLabel == 'semua') {
    bgColor = const Color(0xFFFBEEE6); // Soft Terracotta
    textColor = const Color(0xFFA04000);
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      label,
      style: GoogleFonts.poppins(
        fontSize: 12,
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}