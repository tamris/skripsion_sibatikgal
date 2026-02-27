import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/event_page_controller.dart';
import 'event_card.dart';

class EventListSection extends GetView<EventPageController> {
  const EventListSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const SliverFillRemaining(
          child: Center(child: CircularProgressIndicator()),
        );
      }

      final events = controller.filteredEvents;

      if (events.isEmpty) {
        return const SliverFillRemaining(
          child: Center(child: Text('Tidak ada event ditemukan')),
        );
      }

      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return EventCard(event: events[index]);
            },
            childCount: events.length,
          ),
        ),
      );
    });
  }
}