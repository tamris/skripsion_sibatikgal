import 'package:batikara/app/data/models/batik_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import '../controllers/galeri_page_controller.dart';

class BatikDetailPage extends StatelessWidget {
  BatikDetailPage({super.key});

  final GaleriPageController galeriC = Get.find<GaleriPageController>();

  BatikModel _resolveItem() {
    final args = Get.arguments;
    if (args is BatikModel) return args;
    if (args is Map && args['item'] is BatikModel) return args['item'];
    if (args is int && args >= 0 && args < galeriC.batikList.length) {
      return galeriC.batikList[args];
    }
    return galeriC.batikList.first;
  }

  @override
  Widget build(BuildContext context) {
    final item = _resolveItem();
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ======== BODY ========
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero image bergaya kartu (rounded + shadow)
                      Hero(
                        tag: 'batik_image_${item.image}', // samakan dengan list
                        // ⬇️ Tambahkan padding setinggi status bar AGAR gambar tidak nabrak
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Image.asset(
                                item.image,
                                fit: BoxFit.cover,
                                // (opsional) Fade-in halus
                                frameBuilder: (ctx, child, frame, wasSync) {
                                  if (wasSync) return child;
                                  return AnimatedOpacity(
                                    opacity: frame == null ? 0 : 1,
                                    duration: const Duration(milliseconds: 250),
                                    child: child,
                                  );
                                },
                                errorBuilder: (_, __, ___) => Container(
                                  color: Colors.grey.shade200,
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.image_not_supported),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Judul artikel
                      Text(
                        'Motif ${item.title}',
                        style: GoogleFonts.lora(
                          fontSize: (textTheme.headlineSmall?.fontSize ?? 22),
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Paragraf / deskripsi
                      Text(
                        item.deskripsi,
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.mulish(
                          fontSize: (textTheme.bodyLarge?.fontSize ?? 16),
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ======== TOP ACTIONS (Back + Share + Bookmark) ========
          Positioned(
            top: MediaQuery.of(context).padding.top + 24, // masuk ke area image
            left: 24,
            right: 24,
            child: Row(
              children: [
                _SquareIconButton(
                  icon: Icons.arrow_back,
                  onTap: () => Get.back(),
                ),
                const Spacer(),
                _SquareIconButton(
                  icon: Icons.share_outlined,
                  onTap: () async {
                    final text =
                        '${item.image}\n\n${item.title}\n\n${item.deskripsi}\n\n(Sumber: Aplikasi Batikara)';
                    await Share.share(text, subject: item.title);
                  },
                ),
                const SizedBox(width: 10),
                _SquareIconButton(
                  icon: Icons.bookmark_border,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Fitur bookmark belum tersedia')),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SquareIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _SquareIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35), // abu-abu gelap transparan
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(10),
        child: Icon(
          icon,
          size: 22,
          color: Colors.white, // biar kontras di atas foto
        ),
      ),
    );
  }
}
