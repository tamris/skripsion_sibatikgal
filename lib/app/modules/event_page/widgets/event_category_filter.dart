import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/event_page_controller.dart';

class EventCategoryFilter extends GetView<EventPageController> {
  const EventCategoryFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Obx(() => Wrap(
            spacing: 10,
            runSpacing: 10,
            children: controller.categories.map((cat) {
              final isSelected =
                  controller.selectedCategory.value == cat;

              return GestureDetector(
                onTap: () => controller.onCategoryChanged(cat),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF4E342E)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    cat,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : Colors.grey.shade600,
                    ),
                  ),
                ),
              );
            }).toList(),
          )),
    );
  }
}