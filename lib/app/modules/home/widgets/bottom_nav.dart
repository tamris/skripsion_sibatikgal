import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      height: 64,
      selectedIndex: 0, // nanti diganti kalau pakai root tabs global
      onDestinationSelected: (i) {
        switch (i) {
          case 0: Get.offAllNamed('/home'); break;
          case 1: Get.offAllNamed('/gallery'); break;
          case 2: Get.offAllNamed('/detect'); break;
          case 3: Get.offAllNamed('/mapping'); break;
          case 4: Get.offAllNamed('/profile'); break;
        }
      },
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Beranda'),
        NavigationDestination(icon: Icon(Icons.style_outlined), selectedIcon: Icon(Icons.style), label: 'Galeri'),
        NavigationDestination(icon: Icon(Icons.center_focus_strong), label: 'Deteksi'),
        NavigationDestination(icon: Icon(Icons.map_outlined), selectedIcon: Icon(Icons.map), label: 'Peta'),
        NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil'),
      ],
    );
  }
}
