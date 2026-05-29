import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/event_page_controller.dart';

class EventFilterChips extends StatelessWidget {
  const EventFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EventPageController>();

    return Obx(() {
      final cats = controller.categories;

      return SizedBox(
        height: 42,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: cats.length,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (_, i) {
            final cat = cats[i];

            return Obx(() {
              final isSelected = controller.selectedCategory.value == cat;

              return GestureDetector(
                onTap: () => controller.onCategoryChanged(cat),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF1A1208) : const Color(0xFFEDE9E2),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Text(
                      cat,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? const Color(0xFFFFD264) : const Color(0xFF5A4A3A),
                      ),
                    ),
                  ),
                ),
              );
            });
          },
        ),
      );
    });
  }
}