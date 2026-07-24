import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Impor cache gambar premium
import 'package:shimmer_animation/shimmer_animation.dart'; // Impor paket shimmer andalanmu
import 'package:batikara/app/data/models/batik_model.dart';

class BatikHeroImage extends StatelessWidget {
  final BatikModel batik;
  const BatikHeroImage({super.key, required this.batik});

  @override
  Widget build(BuildContext context) {
    const Color bgImage = Color(0xFFEEDCC5);
    const Color textMuted = Color(0xFF7A7062);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.34,
          decoration: const BoxDecoration(color: bgImage),
          child: batik.image.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: batik.image,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  // Taktik Shimmer Internal Lembut saat gambar utama dimuat
                  placeholder: (context, url) => Shimmer(
                    color: const Color(0xFFFAF7F2),
                    colorOpacity: 0.5,
                    duration: const Duration(milliseconds: 1200),
                    child: Container(
                      color: const Color(0xFFE6DFD5),
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: const Color(0xFFE6DFD5),
                    child: const Icon(
                      Icons.broken_image_rounded,
                      color: textMuted,
                      size: 48,
                    ),
                  ),
                )
              : const Center(
                  child: Icon(Icons.image_not_supported_rounded, size: 64, color: textMuted),
                ),
        ),
      ),
    );
  }
}