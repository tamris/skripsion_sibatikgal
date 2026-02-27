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
          hintText: 'Cari acara batik...',
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: Colors.brown.withValues(alpha: 0.5),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Colors.grey.shade200,
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Color(0xFF8A5A44),
              width: 1.5,
            ),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.brown.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}