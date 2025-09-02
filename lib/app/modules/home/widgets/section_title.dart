import 'package:flutter/material.dart';

class HomeSectionTitle extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onTap;
  const HomeSectionTitle(
      {super.key, required this.title, this.action, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const Spacer(),
          if (action != null)
            GestureDetector(
              onTap: onTap,
              child: Text(action!,
                  style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8A5A44),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins')),
            ),
        ],
      ),
    );
  }
}
