import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeteksiColors {
  static const Color cDark = Color(0xFF1A1208);
  static const Color cKrem = Color(0xFFF7F4EE);
  static const Color cKremChip = Color(0xFFF0EAD8);
  static const Color cBorder = Color(0xFFE8E4DC);
  static const Color cGold = Color(0xFFFFD264);
  static const Color cBrown = Color(0xFF7A3B10);
  static const Color cBrownLight = Color(0xFFC05A1A);
  static const Color cTextSub = Color(0xFF9C8B7A);
  static const Color cTextBody = Color(0xFF6B5A4A);
  static const Color cGreen = Color(0xFF2E7D32);
  static const Color cOrange = Color(0xFFE65100);
  static const Color cRed = Color(0xFFC62828);
}

class CircleBtn extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const CircleBtn({super.key, required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 45,
        height: 45,
        decoration: const BoxDecoration(
          color: DeteksiColors.cKremChip,
          shape: BoxShape.circle,
        ),
        child: Center(child: child),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String label;
  const SectionHeader({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: DeteksiColors.cBrownLight,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: DeteksiColors.cDark,
          ),
        ),
      ],
    );
  }
}

class SDivider extends StatelessWidget {
  const SDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: Divider(color: DeteksiColors.cBorder, thickness: 0.5, height: 20),
    );
  }
}

class GradientBar extends StatelessWidget {
  final double value;
  const GradientBar({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double totalWidth = constraints.maxWidth;
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: 7,
            width: totalWidth,
            child: Stack(
              children: [
                Container(
                  width: totalWidth,
                  height: 7,
                  color: DeteksiColors.cKremChip,
                ),
                ClipRect(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    widthFactor: value,
                    child: Container(
                      width: totalWidth,
                      height: 7,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFC07840),
                            Color(0xFFE9B44C),
                            Color(0xFF2E7D32),
                          ],
                          stops: [0.0, 0.55, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
