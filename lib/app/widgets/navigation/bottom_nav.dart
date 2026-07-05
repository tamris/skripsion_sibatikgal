import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;

  const BottomNav({
    super.key,
    this.currentIndex = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Palet warna premium konsisten Batikara
    const bgCanvas = Color(0xFFFAF7F2); // Kanvas krem hangat belakang nav
    const darkBrown = Color(0xFF1C1308); // Cokelat gelap utama saat dipilih
    const textMuted = Color(0xFF7A7062); // Warna pasif saat tidak dipilih
    const accentGold = Color(0xFFFBBF24); // Warna emas aksen indikator

    // Daftar menu navigasi (Ikon pasif, Ikon aktif, dan Label)
    final List<Map<String, dynamic>> navItems = [
      {
        'icon': Icons.home_outlined,
        'selectedIcon': Icons.home_rounded,
        'label': 'Beranda'
      },
      {
        'icon': Icons.style_outlined,
        'selectedIcon': Icons.style_rounded,
        'label': 'Galeri'
      },
      {
        'icon': Icons.center_focus_strong_outlined,
        'selectedIcon': Icons.center_focus_strong_rounded,
        'label': 'Deteksi'
      },
      {
        'icon': Icons.map_outlined,
        'selectedIcon': Icons.map_rounded,
        'label': 'Peta'
      },
      {
        'icon': Icons.settings_outlined,
        'selectedIcon': Icons.settings_rounded,
        'label': 'Pengaturan'
      },
    ];

    return SafeArea(
      top: false,
      child: Container(
        color: bgCanvas, // Latar belakang menyatu dengan kanvas halaman
        padding: const EdgeInsets.fromLTRB(
            16, 4, 16, 12), // Padding melayang presisi[cite: 15]
        child: Container(
          height:
              72, // Sedikit ditinggikan untuk memberikan ruang translasi vertikal yang lega
          decoration: BoxDecoration(
            color: Colors.white, // Dermaga utama berwarna putih solid[cite: 15]
            borderRadius:
                BorderRadius.circular(22), // Sudut melengkung premium[cite: 15]
            boxShadow: [
              BoxShadow(
                color: darkBrown.withOpacity(
                    0.04), // Bayangan halus cokelat gelap[cite: 15]
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(navItems.length, (index) {
              final isSelected = currentIndex == index;
              final item = navItems[index];

              return Expanded(
                child: InkWell(
                  onTap: () {
                    if (!isSelected) {
                      HapticFeedback
                          .selectionClick(); // Efek getar bawaan tetap terjaga[cite: 15]
                      onTap?.call(index);
                    }
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      // Inovasi Visual 1: Garis Takik Top-Bar Indicator berwarna Emas untuk menu aktif
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        width: isSelected ? 24 : 0,
                        height: 3,
                        decoration: BoxDecoration(
                          color: accentGold,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(3),
                            bottomRight: Radius.circular(3),
                          ),
                        ),
                      ),

                      // Inovasi Visual 2: Efek translasi naik ke atas saat item terpilih
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves
                            .easeOutBack, // Memberikan efek memantul halus saat naik
                        transform: Matrix4.translationValues(
                            0, isSelected ? -4 : 0, 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                                height: 4), // Kompensasi ruang takik atas
                            Icon(
                              isSelected ? item['selectedIcon'] : item['icon'],
                              color: isSelected ? darkBrown : textMuted,
                              size: 22,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['label'],
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSelected ? darkBrown : textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
