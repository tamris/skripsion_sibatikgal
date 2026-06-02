// lib/app/modules/deteksi_page/widget/deteksi_bottom_buttons.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'deteksi_shared_components.dart';

class SmallBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const SmallBtn({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          color: DeteksiColors.cKremChip,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, size: 22, color: DeteksiColors.cBrown),
      ),
    );
  }
}

class PrimaryBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const PrimaryBtn({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: DeteksiColors.cDark,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 22, color: DeteksiColors.cGold),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: DeteksiColors.cGold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}