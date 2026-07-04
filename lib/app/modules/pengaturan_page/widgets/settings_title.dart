import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool hasChevron;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.hasChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    // Menyesuaikan palet warna cokelat & krem sesuai mockup baru
    const darkBrown = Color(0xFF1C1308); 
    const itemBgIcon = Color(0xFFF3EDE2); // Background krem lembut untuk kontainer ikon
    const iconColor = Color(0xFF6B583D);   // Warna ikon cokelat hangat
    const chevronColor = Color(0xFFD1C7BD); // Warna chevron yang lebih soft

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16), // Menjaga efek ripple tetap rapi di dalam card
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Kontainer Ikon Bulat Kotak (Squircle) sesuai Mockup
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: itemBgIcon,
              ),
              child: Icon(icon, size: 22, color: iconColor),
            ),
            const SizedBox(width: 14),
            
            // Label Menu
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: darkBrown,
                ),
              ),
            ),
            
            // Chevron Arrow / Tanda Panah Kanan
            if (hasChevron)
              Icon(
                Icons.chevron_right_rounded, 
                color: chevronColor,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}