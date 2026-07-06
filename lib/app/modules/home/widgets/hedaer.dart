import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/home_controller.dart';

class HomeHeader extends GetView<HomeController> {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    const darkBrown = Color(0xFF1C1308);
    const textMuted = Color(0xFF7A7062);
    const borderColor = Color(0xFFE6DFD5);

    final greetingStyle = GoogleFonts.poppins(
      color: textMuted,
      fontSize: 13,
      fontWeight: FontWeight.w500,
    );

    final headlineStyle = GoogleFonts.lora(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: darkBrown,
      height: 1.2,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Obx(() {
              String displayGreeting = controller.username.value.isNotEmpty
                  ? "${controller.greeting.value} ${controller.username.value}!"
                  : controller.greeting.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayGreeting,
                    style: greetingStyle,
                    maxLines: 1,
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

          // --- AVATAR BINGKAI LINGKARAN PREMIUM (CIRCLE) ---
          GestureDetector(
            onTap: () async {
              // Menunggu halaman profil ditutup, lalu refresh data local storage di beranda
              await Get.toNamed('/profile-user');
              controller.updateGreetingAndProfile();
            },
            child: Obx(() {
              // MENGAMANKAN BINDING: Lakukan pengecekan validitas URL gambar secara ketat
              final String photoUrl = controller.profilePictureUrl.value;

              final ImageProvider imageProvider =
                  (photoUrl.isNotEmpty && photoUrl.startsWith('http'))
                      ? NetworkImage(photoUrl)
                      : const AssetImage('assets/images/avatar.png')
                          as ImageProvider;

              return Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFF2ECE0),
                  border: Border.all(
                    color: borderColor,
                    width: 1.5,
                  ),
                  image: DecorationImage(
                    image:
                        imageProvider, // Otomatis aman dari crash/blank data kosong saat login
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
