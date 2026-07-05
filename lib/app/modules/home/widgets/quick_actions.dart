import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/home_controller.dart';

class HomeQuickActions extends GetView<HomeController> {
  const HomeQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final items = controller.actions;
    return Padding(
      // Mengurangi padding bawah agar jarak ke konten berikutnya lebih proporsional
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
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

  const _ActionItem({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Palet warna premium konsisten Batikara
    const darkBrown = Color(0xFF1C1308); // Cokelat gelap utama
    const itemBgIcon = Color(0xFFF3EDE2); // Krem lembut penyelarasan global

    return InkWell(
      // Mengubah lengkungan efek gelombang sentuh menjadi membulat penuh sesuai ikon
      borderRadius: BorderRadius.circular(30),
      onTap: () {
        HapticFeedback
            .lightImpact(); // Inovasi: Sentuhan getar halus saat menu ditekan
        onTap?.call();
      },
      splashColor: darkBrown.withOpacity(0.05),
      highlightColor: Colors.transparent,
      child: SizedBox(
        width: 76, // Sedikit diperlebar agar distribusi teks 2 baris lebih aman
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Inovasi Visual: Mengubah bentuk kontainer dari kotak menjadi Lingkaran Premium
            Container(
              height:
                  56, // Ukuran dioptimalkan menjadi 56 agar terlihat compact dan pas
              width: 56,
              decoration: const BoxDecoration(
                color: itemBgIcon, // Memakai warna krem bawaan pengaturan Anda
                shape: BoxShape
                    .circle, // Bentuk lingkaran sempurna menghilangkan kesan kaku
              ),
              child: Icon(
                icon,
                color:
                    darkBrown, // Mengganti warna terracotta menjadi cokelat gelap
                size: 24,
              ),
            ),
            const SizedBox(height: 10),

            // Area teks dengan tinggi tetap untuk menjaga kerapian posisi grid menu
            SizedBox(
              height: 34,
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600, // Ketebalan semi-bold yang pas
                  color:
                      darkBrown, // Warna disamakan dengan teks utama aplikasi
                  height: 1.3, // Pengaturan jarak antar baris teks agar padat
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
