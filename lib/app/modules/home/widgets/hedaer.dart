import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeHeader extends GetView<HomeController> {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      child: Row(
        children: [
          Expanded(
            child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(controller.greeting.value,
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                            fontFamily: 'Poppins'))),
                    const SizedBox(height: 2),
                    Text(controller.userName.value,
                        style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            color: Color.fromARGB(255, 138, 90, 68))),
                  ],
                )),
          ),
          GestureDetector(
            onTap: () => Get.toNamed('/profile-user'),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Container(
                height: 60,
                width: 60,
                // Hapus properti 'color' dan 'child' dari sini
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    // Arahkan ke gambar di folder assets Anda
                    image: AssetImage('assets/images/avatar.png'),
                    // Membuat gambar mengisi seluruh container
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
