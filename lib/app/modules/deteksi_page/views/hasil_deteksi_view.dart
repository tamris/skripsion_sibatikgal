// lib/app/modules/deteksi_page/views/hasil_deteksi_view.dart

import 'dart:io';
import 'package:batikara/app/data/service/galeri_service.dart';
import 'package:batikara/app/modules/galeri_page/views/galeri_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:batikara/app/modules/deteksi_page/controllers/deteksi_page_controller.dart';
import '../widget/deteksi_shared_components.dart';
import '../widget/deteksi_bottom_buttons.dart';

class HasilDeteksiView extends StatelessWidget {
  final DeteksiPageController controller;

  const HasilDeteksiView({super.key, required this.controller});

  double _parseConfidence() {
    final raw = controller.confidence.value.replaceAll('%', '').trim();
    return (double.tryParse(raw) ?? 0) / 100;
  }

  bool get _isLowConfidence => _parseConfidence() < 0.65;

  Future<void> _openDetectedMotifDetail() async {
    final name = controller.motifName.value.trim();
    if (name.isEmpty) {
      Get.snackbar(
        'Motif tidak tersedia',
        'Hasil deteksi belum memiliki nama motif yang valid.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.dialog(const Center(child: CircularProgressIndicator()),
        barrierDismissible: false);
    final batik = await GaleriService.fetchBatikByMotifName(name);
    if (Get.isDialogOpen ?? false) Get.back();

    if (batik == null) {
      Get.snackbar(
        'Detail tidak ditemukan',
        'Motif "$name" belum tersedia di data galeri.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    Get.to(() => GaleriDetailView(batik: batik));
  }

  void _resetToDeteksi() {
    controller.selectedImagePath.value = '';
    controller.isDetected.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: DeteksiColors.cKrem,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  const SliverToBoxAdapter(child: SizedBox(height: 72)),
                  SliverToBoxAdapter(child: _buildImage()),
                  SliverToBoxAdapter(child: _buildConfidenceBar()),
                  const SliverToBoxAdapter(child: SDivider()),
                  SliverToBoxAdapter(child: _buildNamaMotif()),
                  const SliverToBoxAdapter(child: SDivider()),
                  SliverToBoxAdapter(child: _buildMakna()),
                  const SliverToBoxAdapter(child: SizedBox(height: 10)),
                  SliverToBoxAdapter(child: _buildTimestamp()),
                  const SliverToBoxAdapter(child: SizedBox(height: 110)),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child:
                  Container(color: DeteksiColors.cKrem, child: _buildHeader()),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomCta(bottomPadding),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleBtn(
            child: const Icon(Icons.arrow_back_rounded,
                size: 20, color: DeteksiColors.cDark),
            onTap: _resetToDeteksi,
          ),
          Text(
            'Hasil Deteksi',
            style: GoogleFonts.lora(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: DeteksiColors.cDark),
          ),
          CircleBtn(
            child:
                const Icon(Icons.share, size: 20, color: DeteksiColors.cDark),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: SizedBox(
          height: 300,
          width: double.infinity,
          child: controller.selectedImagePath.value.isNotEmpty
              ? Image.file(File(controller.selectedImagePath.value),
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _imageFallback())
              : _imageFallback(),
        ),
      ),
    );
  }

  Widget _imageFallback() {
    return Container(
      color: const Color(0xFF2C1A0C),
      child: const Center(
          child: Icon(Icons.image_not_supported_outlined,
              size: 36, color: Colors.white24)),
    );
  }

  Widget _buildConfidenceBar() {
    final pct = _parseConfidence();
    final pctLabel = controller.confidence.value.isNotEmpty
        ? controller.confidence.value
        : '–';
    final Color pctColor =
        _isLowConfidence ? DeteksiColors.cOrange : DeteksiColors.cGreen;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          if (_isLowConfidence)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFF57F17), width: 0.5),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      size: 22, color: Color(0xFFF57F17)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Hasil kurang akurat. Coba foto ulang dengan pencahayaan lebih baik.',
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: const Color(0xFF9C6B00),
                          height: 1.6),
                    ),
                  ),
                ],
              ),
            ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: DeteksiColors.cBorder, width: 0.5),
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tingkat Keyakinan',
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: DeteksiColors.cDark)),
                    Text(pctLabel,
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: pctColor)),
                  ],
                ),
                const SizedBox(height: 12),
                GradientBar(value: pct.clamp(0.0, 1.0)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Kurang yakin',
                        style: GoogleFonts.poppins(
                            fontSize: 14, color: const Color(0xFFC8BEB0))),
                    Text('Sangat yakin',
                        style: GoogleFonts.poppins(
                            fontSize: 14, color: const Color(0xFFC8BEB0))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNamaMotif() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(label: 'Nama Motif'),
          const SizedBox(height: 12),
          Container(
            constraints: const BoxConstraints(minHeight: 84),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: DeteksiColors.cBorder, width: 0.5),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                      color: DeteksiColors.cKremChip,
                      borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.palette_outlined,
                      size: 22, color: DeteksiColors.cBrown),
                ),
                const SizedBox(width: 14),
                Obx(() => Text(
                      controller.motifName.value.isNotEmpty
                          ? controller.motifName.value
                          : 'Tidak diketahui',
                      style: GoogleFonts.poppins(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: DeteksiColors.cDark),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMakna() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(label: 'Makna Motif'),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: DeteksiColors.cBorder, width: 0.5),
            ),
            padding: const EdgeInsets.all(14),
            child: Obx(() => Text(
                  controller.filosofi.value.isNotEmpty
                      ? controller.filosofi.value
                      : 'Makna tidak tersedia.',
                  style: GoogleFonts.mulish(
                      fontSize: 14,
                      color: DeteksiColors.cTextBody,
                      height: 1.85),
                  textAlign: TextAlign.justify,
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildTimestamp() {
    final waktu = controller.historyList.isNotEmpty
        ? (controller.historyList[0]['waktu_relatif'] ?? 'Baru saja')
        : 'Baru saja';
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: Container(
        decoration: BoxDecoration(
            color: DeteksiColors.cKremChip,
            borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            const Icon(Icons.access_time_rounded,
                size: 15, color: DeteksiColors.cBrown),
            const SizedBox(width: 8),
            Expanded(
                child: Text.rich(TextSpan(
              style: GoogleFonts.poppins(
                  fontSize: 14, color: DeteksiColors.cBrown),
              children: [
                const TextSpan(text: 'Dideteksi '),
                TextSpan(
                    text: waktu,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              ],
            ))),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomCta(double bottomPadding) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 10, 16, 14 + bottomPadding * 0.5),
      decoration: const BoxDecoration(
        color: Color(0xFAF7F4EE),
        border:
            Border(top: BorderSide(color: DeteksiColors.cBorder, width: 0.5)),
      ),
      child: _isLowConfidence
          ? _buildCtaLowConfidence()
          : _buildCtaHighConfidence(),
    );
  }

  Widget _buildCtaHighConfidence() {
    return Row(
      children: [
        SmallBtn(icon: Icons.refresh_rounded, onTap: _resetToDeteksi),
        const SizedBox(width: 8),
        Expanded(
            child: PrimaryBtn(
                icon: Icons.menu_book_rounded,
                label: 'Lihat Detail Motif',
                onTap: _openDetectedMotifDetail)),
      ],
    );
  }

  Widget _buildCtaLowConfidence() {
    return Row(
      children: [
        Expanded(
            child: PrimaryBtn(
                icon: Icons.refresh_rounded,
                label: 'Deteksi Ulang',
                onTap: _resetToDeteksi)),
        const SizedBox(width: 8),
        SmallBtn(
            icon: Icons.menu_book_rounded, onTap: _openDetectedMotifDetail),
      ],
    );
  }
}
