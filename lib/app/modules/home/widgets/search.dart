import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/home_controller.dart';

class HomeSearchBar extends GetView<HomeController> {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    const darkBrown = Color(0xFF1C1308);
    const textMuted = Color(0xFF7A7062);
    const borderColor = Color(0xFFE6DFD5);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: TextField(
        controller: controller.searchC,
        cursorColor: darkBrown,
        style: GoogleFonts.poppins(
            fontSize: 15, color: darkBrown, fontWeight: FontWeight.w500),
        textInputAction: TextInputAction.search,
        // =========================================================================
        // ON SUBMITTED: Ketika tombol enter/kaca pembesar ditekan, lempar ke GlobalSearch
        // =========================================================================
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            Get.toNamed('/global-search', arguments: value);
            controller.searchC
                .clear(); // Pastikan rute '/global-search' sesuai di app_pages.dart
          }
        },
        decoration: InputDecoration(
          hintText: 'Cari motif, artikel, video, atau event...',
          hintStyle: GoogleFonts.poppins(
              color: textMuted.withValues(alpha: 0.5), fontSize: 14),
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(Icons.search_rounded,
              color: textMuted.withValues(alpha: 0.7), size: 20),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: borderColor, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: darkBrown, width: 1.5),
          ),
        ),
      ),
    );
  }
}
