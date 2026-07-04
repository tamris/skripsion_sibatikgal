import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TypingIndicatorWidget extends StatefulWidget {
  final Color dotsColor;
  final Duration animationDuration;

  const TypingIndicatorWidget({
    super.key,
    required this.dotsColor,
    required this.animationDuration,
  });

  @override
  State<TypingIndicatorWidget> createState() => _TypingIndicatorWidgetState();
}

class _TypingIndicatorWidgetState extends State<TypingIndicatorWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Properti warna premium diselaraskan dengan palet utama Anda
    const darkBrown = Color(0xFF1C1308);
    const textMuted = Color(0xFF7A7062);

    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label nama kecil TikAI di atas indikator biar serasi dengan chat asli
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Text(
              "TikAI",
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: textMuted,
              ),
            ),
          ),

          // Gelembung Kartu Melayang Indikator Mengetik
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            child: Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors
                    .white, // Putih solid agar kontras di atas bgCanvas krem
                boxShadow: [
                  BoxShadow(
                    color: darkBrown.withOpacity(0.03),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft:
                      Radius.circular(4), // Sudut ekor asimetris khas chat AI
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'sedang mengetik',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        color: textMuted,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Animasi Kedip 3 Titik Emas/Cokelat Gelap
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Row(
                        children: List.generate(3, (index) {
                          final delay = index * 0.2;
                          final animValue =
                              (_animation.value - delay).clamp(0.0, 1.0);
                          final opacity = (animValue * 2 - 1).abs();

                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 1.5),
                            child: Opacity(
                              opacity: (1 - opacity).clamp(0.1, 1.0),
                              child: Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: widget
                                      .dotsColor, // Menggunakan parameter dinamis dari view
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
