import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/home_controller.dart';

class HomeHeader extends GetView<HomeController> {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final greetingStyle = TextStyle(
      color: Colors.grey.shade600,
      fontSize: 14,
      fontFamily: 'Poppins',
    );

    final headlineStyle = GoogleFonts.lora(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: Color(0xFF5A3E36), // sedikit lebih gelap biar kuat
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(height: 6),
                  Text(
                    "Eksplor Batik Tegalan",
                    style: headlineStyle,
                  ),
                ],
              );
            }),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => Get.toNamed('/profile-user'),
            child: Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF8A5A44),
                  width: 1.2,
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
