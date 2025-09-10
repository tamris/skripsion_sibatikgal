import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pengaturan_page_controller.dart';
import '../widgets/settings_title.dart';

class PengaturanPageView extends GetView<PengaturanPageController> {
  const PengaturanPageView({super.key});

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF7F5F2); // canvas belakang
    const terracotta = Color(0xFF0F172A); // judul gelap (boleh diganti)
    const cardBorder = Color(0x1A000000); // 10% hitam

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                'Pengaturan',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: terracotta,
                ),
              ),
              const SizedBox(height: 16),

              // Header card (welcome + avatar + action)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: cardBorder),
                ),
                child: Row(
                  children: [
                    Obx(() {
                      final url = controller.photoUrl.value.trim();
                      return CircleAvatar(
                        radius: 30,
                        backgroundColor: const Color(0xFFE5E7EB),
                        backgroundImage:
                            url.isNotEmpty ? NetworkImage(url) : null,
                        child: url.isEmpty
                            ? const Icon(Icons.person, color: Color(0xFF6B7280))
                            : null,
                      );
                    }),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Obx(() => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.greeting.value,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  color: Color(0xFF9CA3AF),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                controller.displayName.value,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF111827),
                                ),
                              ),
                            ],
                          )),
                    ),
                    IconButton(
                      onPressed: controller.goToProfile,
                      icon: const Icon(Icons.open_in_new_rounded,
                          color: Color(0xFF6B7280)),
                      tooltip: 'Lihat Profil',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // List settings (card)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: cardBorder),
                ),
                child: Column(
                  children: [
                    SettingsTile(
                      icon: Icons.person_outline,
                      label: 'User Profile',
                      onTap: controller.goToProfile,
                    ),
                    const Divider(height: 1, color: Color(0xFFE5E7EB)),
                    SettingsTile(
                      icon: Icons.lock_outline,
                      label: 'Ubah Sandi',
                      onTap: controller.goToChangePassword,
                    ),
                    const Divider(height: 1, color: Color(0xFFE5E7EB)),
                    SettingsTile(
                      icon: Icons.bookmark_outline,
                      label: 'Item Tersimpan',
                      onTap: controller.goToChangePassword,
                    ),
                    const Divider(height: 1, color: Color(0xFFE5E7EB)),
                    SettingsTile(
                      icon: Icons.history,
                      label: 'Riwayat Deteksi Batik',
                      onTap: controller.goToChangePassword,
                    ),
                    const Divider(height: 1, color: Color(0xFFE5E7EB)),
                    SettingsTile(
                      icon: Icons.help_outline,
                      label: 'FAQs',
                      onTap: controller.goToFaqs,
                    ),
                    const Divider(height: 1, color: Color(0xFFE5E7EB)),

                    // Switch row (custom biar mirip desain)
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Support card (WhatsApp Us)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      'If you have any other query you can reach out to us.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        color: Color(0xFF374151),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: controller.contactWhatsApp,
                      child: const Text(
                        'WhatsApp Us',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                        ),
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
