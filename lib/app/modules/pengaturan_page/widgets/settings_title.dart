import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool hasChevron;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.hasChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    const textMuted = Color(0xFF6B7280);

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 84,
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color(0xFFF2F2F2),
              ),
              child: Icon(icon, size: 20, color: textMuted),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
            ),
            if (hasChevron)
              const Icon(Icons.chevron_right_rounded, color: textMuted),
          ],
        ),
      ),
    );
  }
}
