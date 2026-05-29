import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/event_page_controller.dart';

class EventSearchBar extends GetView<EventPageController> {
  const EventSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: TextField(
        onChanged: controller.onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Cari event...',
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: Colors.black.withValues(alpha: 0.5),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(
              color: Colors.grey.shade200,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Colors.black,
              width: 1.5,
            ),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.black.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}
