import 'package:batikara/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/pengaturan_page_controller.dart';
import '../widgets/settings_title.dart';
import '../widgets/logout_dialog.dart';

class PengaturanPageView extends GetView<PengaturanPageController> {
  const PengaturanPageView({super.key});

  @override
  Widget build(BuildContext context) {
    // Palette warna premium konsisten
    const bgCanvas = Color(0xFFFAF7F2); // Kanvas krem hangat
    const darkBrown = Color(0xFF1C1308); // Cokelat gelap pekat
    const textMuted = Color(0xFF7A7062); // Abu-abu kecokelatan pudar
    const accentGold = Color(0xFFFBBF24); // Emas aksen hangat
    const itemBgIcon = Color(0xFFF3EDE2); // Latar belakang lingkaran ikon menu

    return Scaffold(
      backgroundColor: bgCanvas,
      // ================= FIXED APP BAR (TIDAK IKUT SCROLL) =================
      appBar: AppBar(
        backgroundColor: bgCanvas,
        elevation: 0, // Menghilangkan shadow agar flat menyatu dengan canvas
        automaticallyImplyLeading: false, // Menghapus tombol back bawaan
        toolbarHeight:
            90, // Memberikan space vertikal yang cukup untuk title kustom
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'AKUN SAYA',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: textMuted,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Pengaturan',
                style: GoogleFonts.lora(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: darkBrown,
                ),
              ),
            ],
          ),
        ),
      ),

      // ================= SCROLLABLE CONTENT =================
      body: SafeArea(
        top: false, // AppBar sudah meng-handle area status bar atas
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= HEADER CARD (Welcome Profile) =================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: darkBrown,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    // Avatar Lingkaran dengan Border Tipis Emas
                    Obx(() {
                      final url = controller.photoUrl.value.trim();
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: const Color(0xFF524432), width: 1.5),
                        ),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: const Color(0xFF2E2214),
                          backgroundImage:
                              url.isNotEmpty ? NetworkImage(url) : null,
                          child: url.isEmpty
                              ? const Icon(Icons.person_outline_rounded,
                                  color: accentGold, size: 28)
                              : null,
                        ),
                      );
                    }),
                    const SizedBox(width: 16),

                    // Teks Greeting & Nama Pengguna
                    Expanded(
                      child: Obx(() => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.greeting.value,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: const Color(0xFF9A8D7C),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                controller.displayName.value,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )),
                    ),

                    // Tombol Logout dengan Dialog Box
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF2E2214),
                      ),
                      child: IconButton(
                        onPressed: () {
                          Get.dialog(
                            LogoutDialog(
                              onConfirm: () => controller.logout(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.logout_rounded,
                          color: Colors.white70,
                          size: 20,
                        ),
                        tooltip: 'Logout',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ================= SECTION: AKUN =================
              Text(
                'AKUN',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: textMuted,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    SettingsTile(
                      icon: Icons.account_circle_rounded,
                      label: 'Profil Pengguna',
                      onTap: controller.goToProfile,
                    ),
                    const Divider(
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                        color: Color(0xFFF3F4F6)),
                    SettingsTile(
                      icon: Icons.lock_outline_rounded,
                      label: 'Ubah Sandi',
                      onTap: controller.goToChangePassword,
                    ),
                    const Divider(
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                        color: Color(0xFFF3F4F6)),
                    SettingsTile(
                      icon: Icons.bookmark_border_rounded,
                      label: 'Item Tersimpan',
                      onTap: controller.goToSaveItem,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ================= SECTION: TENTANG =================
              Text(
                'TENTANG',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: textMuted,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    SettingsTile(
                      icon: Icons.help_outline_rounded,
                      label: 'FAQ & Bantuan',
                      onTap: controller.goToFaqs,
                    ),
                    const Divider(
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                        color: Color(0xFFF3F4F6)),

                    // ListTile Kustom untuk 'Tentang Aplikasi' + Version Code di kanan
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      onTap: controller.goToAbout,
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: itemBgIcon,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.info_outline_rounded,
                            color: Color(0xFF6B583D), size: 22),
                      ),
                      title: Text(
                        'Tentang Aplikasi',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: darkBrown,
                        ),
                      ),
                      trailing: Text(
                        'v1.0.0',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ================= INOVASI: AI CHATBOT ASSISTANT CARD =================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors
                      .white, // Putih bersih serasi dengan blok menu di atas
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Ikon dengan nuansa Smart Assistant AI
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(
                                0xFFFEF3C7), // Latar emas pudar yang sangat lembut
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons
                                .auto_awesome_outlined, // Bintang cerdas khas AI助理
                            color: Color(0xFFD97706), // Warna emas gelap pekat
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Asisten AI',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: darkBrown,
                                ),
                              ),
                              Text(
                                'Punya pertanyaan? Tanyakan ke Chatbot kami',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: textMuted,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Hubungkan ke route atau fungsi chatbot Anda
                        Get.toNamed(Routes.CHATBOT_PAGE);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkBrown,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(
                            double.infinity, 48), // Tinggi ringkas proporsional
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.forum_outlined,
                            color: accentGold,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Mulai Chat',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: accentGold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
