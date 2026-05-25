// lib/app/modules/deteksi_page/views/components/loading_stepper_view.dart

import 'dart:io';
import 'package:batikara/app/modules/deteksi_page/controllers/deteksi_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingStepperView extends StatelessWidget {
  final DeteksiPageController controller;
  final Color colorPrimary;
  final Color textDark;

  const LoadingStepperView({
    super.key,
    required this.controller,
    required this.colorPrimary,
    required this.textDark,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          // Preview Gambar + Overlay Gelap Analisis
          Container(
            width: double.infinity,
            height: 330,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              image: DecorationImage(
                image: FileImage(File(controller.selectedImagePath.value)),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: colorPrimary.withOpacity(0.85),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 56,
                    height: 56,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Menganalisis motif...',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Mohon tunggu sebentar',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Render Urutan Stepper Berdasarkan Nilai Reactive Controller
          _buildStepRow('Gambar diterima', controller.loadingStep.value >= 0, controller.loadingStep.value > 0),
          _buildStepRow('Pra-pemrosesan gambar', controller.loadingStep.value >= 1, controller.loadingStep.value > 1),
          _buildStepRow('Mendeteksi motif...', controller.loadingStep.value >= 2, controller.loadingStep.value > 2),
          _buildStepRow('Menyiapkan hasil', controller.loadingStep.value >= 3, controller.loadingStep.value > 3),
        ],
      );
    });
  }

  // Widget Item Baris Stepper Tunggal
  Widget _buildStepRow(String title, bool isActive, bool isDone) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDone
                  ? colorPrimary
                  : (isActive ? colorPrimary.withOpacity(0.15) : const Color(0xFFEFE7DD).withOpacity(0.6)),
              border: isDone ? null : Border.all(color: isActive ? colorPrimary : Colors.transparent, width: 2),
            ),
            child: isDone
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : (isActive
                    ? Center(child: Container(width: 10, height: 10, decoration: BoxDecoration(shape: BoxShape.circle, color: colorPrimary)))
                    : null),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? textDark : textDark.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }
}