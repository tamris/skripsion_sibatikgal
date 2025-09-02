import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeSearchBar extends GetView<HomeController> {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      child: TextField(
        controller: controller.searchC,
        decoration: InputDecoration(
          hintText: 'Cari kempenye alam...',
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            // 1. Ganti warna hint agar lebih hangat
            color: Colors.brown.withOpacity(0.5),
          ),
          filled: true,
          // 2. Warna latar ini sudah bagus, bisa dipertahankan
          fillColor: const Color.fromARGB(255, 255, 246, 241),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 20),

          // 3. Atur garis tepi di sini
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            // Beri garis tepi warna abu-abu hangat yang halus
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            // Saat diklik, garis tepinya pakai warna aksen utama
            borderSide: const BorderSide(color: Color(0xFF8A5A44), width: 1.5),
          ),
        ),
      ),
    );
  }
}
