import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/home_controller.dart';

class HomeHeader extends GetView<HomeController> {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // Palet warna premium konsisten Batikara
    const darkBrown = Color(0xFF1C1308); // Cokelat gelap utama
    const textMuted = Color(0xFF7A7062); // Warna teks pasif/sekunder
    const borderColor = Color(0xFFE6DFD5); // Garis tepi tipis premium

    // Mengoptimalkan style font dengan GoogleFonts global
    final greetingStyle = GoogleFonts.poppins(
      color: textMuted,
      fontSize: 13,
      fontWeight: FontWeight.w500,
    );

    final headlineStyle = GoogleFonts.lora(
      fontSize: 24, // Sedikit dinaikkan dari 20 agar lebih tegas dan mengundang
      fontWeight: FontWeight.w700,
      color: darkBrown, // Mengganti warna cokelat kemerahan lama
      height: 1.2,
    );

    return Padding(
      // Padding disesuaikan agar pas diletakkan di bagian paling atas beranda
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment
            .center, // Diubah ke center agar sejajar vertikal dengan avatar
        children: [
          Expanded(
            child: Obx(() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.greeting.value,
                    style: greetingStyle,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Eksplor Batik Tegalan",
                    style: headlineStyle,
                  ),
                ],
              );
            }),
          ),
          const SizedBox(width: 16),

          // --- AVATAR BINGKAI PREMIUM (SMOOTH-SQUIRCLE) ---
          GestureDetector(
            onTap: () => Get.toNamed('/profile-user'), // Navigasi tetap aman
            child: Container(
              height: 48, // Ukuran dioptimalkan menjadi 48 agar proporsional
              width: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF2ECE0),
                borderRadius: BorderRadius.circular(
                    16), // Kelengkungan sudut yang moderen dan rapi
                border: Border.all(
                  color:
                      borderColor, // Mengganti warna terracotta lama dengan krem gelap tipis
                  width: 1.5,
                ),
                image: const DecorationImage(
                  image: AssetImage('assets/images/avatar.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
