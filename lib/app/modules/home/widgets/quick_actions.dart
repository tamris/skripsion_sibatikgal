import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeQuickActions extends GetView<HomeController> {
  const HomeQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final items = controller.actions;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.map((a) {
          return _ActionItem(icon: a.icon, label: a.label, onTap: a.onTap);
        }).toList(),
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const _ActionItem({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: SizedBox(
        width: 72, // fix lebar biar rata
        child: Column(
          children: [
            Container(
              height: 68,
              width: 68,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 138, 90, 68),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Icon(icon, color: const Color(0xFFF7F5F2)),
            ),
            const SizedBox(height: 8),

            // Area teks punya tinggi fix (contoh 32 px)
            SizedBox(
              height: 32, // cukup untuk 2 baris teks
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: Color(0xFF3D2B1F),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
