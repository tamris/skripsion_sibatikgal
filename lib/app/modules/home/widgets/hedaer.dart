import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeHeader extends GetView<HomeController> {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          Expanded(
            child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sugeng Enjing!',
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                            fontFamily: 'Poppins')),
                    const SizedBox(height: 2),
                    Text(controller.userName.value,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color.fromARGB(255, 138, 90, 68))),
                  ],
                )),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Container(
              height: 50,
              width: 50,
              color: const Color(0xFFEAEAEA),
              child: const Icon(Icons.person, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
