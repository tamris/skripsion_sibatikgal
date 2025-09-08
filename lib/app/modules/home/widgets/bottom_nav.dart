import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeBottomNav extends StatelessWidget {
  /// Kalau mau set tab aktif dari luar, tinggal ganti param ini.
  final int currentIndex;
  const HomeBottomNav({super.key, this.currentIndex = 0});

  @override
  Widget build(BuildContext context) {
    const terracotta = Color(0xFF8A5A44);
    const textMuted = Color(0xFF6B7280); // abu-abu label

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: NavigationBarTheme(
              data: NavigationBarThemeData(
                height: 64,
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.transparent,
                indicatorColor: terracotta.withOpacity(0.12),
                indicatorShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                labelTextStyle:
                    WidgetStateProperty.resolveWith<TextStyle>((states) {
                  final selected = states.contains(WidgetState.selected);
                  return TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected ? terracotta : textMuted,
                  );
                }),
                iconTheme:
                    WidgetStateProperty.resolveWith<IconThemeData>((states) {
                  final selected = states.contains(WidgetState.selected);
                  return IconThemeData(
                    size: 24,
                    color: selected ? terracotta : textMuted,
                  );
                }),
              ),
              child: NavigationBar(
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                selectedIndex:
                    currentIndex, // default 0; bisa diganti dari luar
                onDestinationSelected: (i) {
                  HapticFeedback.selectionClick();
                  switch (i) {
                    case 0:
                      Get.offAllNamed('/home');
                      break;
                    case 1:
                      Get.offAllNamed('/galeri-page');
                      break;
                    case 2:
                      Get.offAllNamed('/detect');
                      break;
                    case 3:
                      Get.offAllNamed('/mapping');
                      break;
                    case 4:
                      Get.offAllNamed('/profile');
                      break;
                  }
                },
                destinations: const [
                  NavigationDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home),
                    label: 'Beranda',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.style_outlined),
                    selectedIcon: Icon(Icons.style),
                    label: 'Galeri',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.center_focus_strong),
                    label: 'Deteksi',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.chat_bubble_outline),
                    selectedIcon: Icon(Icons.chat_bubble),
                    label: 'TikAI',
                  ),
                  NavigationDestination(
                    icon: Icon(Icons.settings_outlined),
                    selectedIcon: Icon(Icons.settings),
                    label: 'Pengaturan',
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
