import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/deteksi_page_controller.dart';

class DeteksiPageView extends GetView<DeteksiPageController> {
  const DeteksiPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Deteksi Motif',
          style: GoogleFonts.lora(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // --- Area Gambar / Placeholder ---
              Obx(() => Container(
                    width: double.infinity,
                    height: 350,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: controller.isLoading.value
                        ? const Center(
                            child: CircularProgressIndicator(
                                color: Color(0xFF8D5D46))) // Tampilkan loading
                        : controller.selectedImagePath.value == ''
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.image_outlined,
                                      size: 80, color: Colors.black),
                                  const SizedBox(height: 16),
                                  Text('Pilih gambar untuk di deteksi!',
                                      style: GoogleFonts.poppins(
                                          color: Colors.grey)),
                                ],
                              )
                            : Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.file(
                                      File(controller.selectedImagePath.value),
                                      width: double.infinity,
                                      height: 350,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  // Tombol Hapus
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: GestureDetector(
                                      onTap: () => controller.resetDetection(),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: const BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle),
                                        child: const Icon(Icons.delete_outline,
                                            color: Colors.white, size: 20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                  )),

              const SizedBox(height: 20), // Jarak disesuaikan

              // Obx(
              //   () => controller.selectedImagePath.value != ''
              //       ? Padding(
              //           padding: const EdgeInsets.only(bottom: 20),
              //           child: OutlinedButton.icon(
              //             onPressed: () => controller.resetDetection(),
              //             icon: const Icon(Icons.delete, color: Colors.red),
              //             label: Text(
              //               'Hapus Foto',
              //               style: GoogleFonts.poppins(
              //                   color: Colors.red, fontWeight: FontWeight.bold),
              //             ),
              //             style: OutlinedButton.styleFrom(
              //               side: const BorderSide(color: Colors.red),
              //               shape: RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(10)),
              //             ),
              //           ),
              //         )
              //       : const SizedBox.shrink(),
              // ),

              // --- Tombol Kamera & Galeri ---
              Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.camera_alt_outlined,
                      label: 'Kamera',
                      onPressed: () => controller.pickImage(ImageSource.camera),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.image_outlined,
                      label: 'Galeri',
                      onPressed: () =>
                          controller.pickImage(ImageSource.gallery),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // --- Hasil Deteksi (Hanya muncul jika isDetected = true) ---
              Obx(() => controller.isDetected.value
                  ? Container(
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color:
                            const Color(0xFFF2E4DF), // Warna krem sesuai desain
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Motif : ${controller.motifName.value}',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Filosofi Makna :',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            controller.filosofi.value,
                            style: GoogleFonts.poppins(fontSize: 14),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () {
                              // Navigasi ke detail jika perlu
                            },
                            child: Text(
                              'Lihat selengkapnya',
                              style: GoogleFonts.poppins(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink()),
              const SizedBox(height: 100), // Ruang ekstra untuk navigasi bawah
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widget untuk tombol Kamera/Galeri
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.black),
      label: Text(
        label,
        style: GoogleFonts.poppins(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE0E0E0),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
      ),
    );
  }
}
