import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/models/event_model.dart';

class DetailHeaderSection extends StatelessWidget {
  final EventModel event;
  
  // Ambil warna static dari view utama
  static const Color cDark = Color(0xFF1A1208);
  static const Color cKremChip = Color(0xFFF0EAD8);
  static const Color cGold = Color(0xFFFFD264);

  const DetailHeaderSection({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(),
        _buildImage(event),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _CircleBtn(
            child: const Icon(Icons.arrow_back, size: 16, color: cDark),
            onTap: () => Get.back(),
          ),
          Text('Detail Event',
              style: GoogleFonts.lora(
                  fontSize: 20, fontWeight: FontWeight.w500, color: cDark)),
          _CircleBtn(
            child: const Icon(Icons.share_outlined, size: 16, color: cDark),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildImage(EventModel event) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 250,
          width: double.infinity,
          child: Hero(
            tag: 'event-${event.id}',
            child: _buildImageContent(event),
          ),
        ),
      ),
    );
  }

  Widget _buildImageContent(EventModel event) {
    final hasImage =
        event.bannerImageUrl != null && event.bannerImageUrl!.isNotEmpty;

    if (hasImage) {
      return Image.network(
        event.bannerImageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildImageFallback(),
        loadingBuilder: (_, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildImageFallback(isLoading: true);
        },
      );
    }
    return _buildImageFallback();
  }

  Widget _buildImageFallback({bool isLoading = false}) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2C1A0C), Color(0xFF6A3A15), Color(0xFFA06030)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator(color: cGold, strokeWidth: 2)
            : const Icon(Icons.image_outlined, size: 36, color: Colors.white24),
      ),
    );
  }
}

// Tombol bulat bawaan kode aslimu
class _CircleBtn extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const _CircleBtn({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 45,
        height: 45,
        decoration: const BoxDecoration(
          color: Color(0xFFF0EAD8),
          shape: BoxShape.circle,
        ),
        child: Center(child: child),
      ),
    );
  }
}