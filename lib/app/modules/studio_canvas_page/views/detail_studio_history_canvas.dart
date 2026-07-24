import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_painter_v2/flutter_painter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer_animation/shimmer_animation.dart'; // 🟢 Tambahkan import package shimmer milikmu
import '../controllers/studio_canvas_page_controller.dart';

class DetailStudioHistoryCanvas extends GetView<StudioCanvasPageController> {
  const DetailStudioHistoryCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    const Color cDark = Color(0xFF1A1208);

    return Scaffold(
      backgroundColor: const Color(0xfff8f9fa),
      appBar: AppBar(
        title: Obx(() {
          // Menampilkan nama batik secara dinamis dari database/state controller
          final namaBatik = controller.currentSelectedBatik?.name ?? '-';
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'MELANJUTKAN MEMBATIK',
                style: GoogleFonts.lora(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 2.0,
                  color: Colors.brown.shade600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Motif $namaBatik',
                style: GoogleFonts.lora(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: cDark,
                ),
              ),
            ],
          );
        }),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 20),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_rounded, color: cDark, size: 24),
            tooltip: 'Simpan Hasil Membatik',
            onPressed: () {
              final batikId = controller.currentSelectedBatik?.id ?? '';
              if (batikId.isNotEmpty) {
                controller.saveCanvasDraftToDatabase(batikId);
              }
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: GetBuilder<StudioCanvasPageController>(
        builder: (controller) {
          final currentBatik = controller.currentSelectedBatik;

          if (currentBatik == null) {
            return const Center(
              child: Text("Belum ada data sketsa draf batik yang dipilih."),
            );
          }

          return Column(
            children: [
              // 1. AREA UTAMA CANVAS MENGGAMBAR
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Obx(() {
                      bool isDrawMode = controller.isDrawingMode.value;

                      return InteractiveViewer(
                        maxScale: 6.0,
                        minScale: 0.5,
                        boundaryMargin: const EdgeInsets.all(200),
                        scaleEnabled: !isDrawMode,
                        panEnabled: !isDrawMode,
                        child: Center(
                          child: SizedBox(
                            width: screenSize.width - 32,
                            height: screenSize.height * 0.55,
                            child: Stack(
                              children: [
                                // Layer 1: Panduan Sketsa Latar Belakang Gambar dari Backend
                                Positioned.fill(
                                  child: Opacity(
                                    opacity: 0.35,
                                    child: Image.network(
                                      currentBatik.sketchImageUrl,
                                      fit: BoxFit.contain,
                                      // 🟢 MENGGANTI SPINNER LAMA DENGAN ANIMASI SHIMMER KAIN KANVAS
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Shimmer(
                                          duration: const Duration(
                                            seconds: 2,
                                          ),
                                          interval: const Duration(
                                            milliseconds: 100,
                                          ),
                                          color: Colors.grey.shade100,
                                          colorOpacity: 0.6,
                                          child: Container(
                                            color: Colors.grey.shade200,
                                            width: double.infinity,
                                            height: double.infinity,
                                          ),
                                        );
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                        Icons.broken_image,
                                        color: Colors.grey,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                ),

                                // Layer 2: Papan Menggambar Interaktif Baru & Restorasi Draf JSON
                                Positioned.fill(
                                  child: IgnorePointer(
                                    ignoring: !isDrawMode,
                                    child: FlutterPainter(
                                      controller: controller.painterController,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),

              // 2. KONTROL PANEL UTALITAS CANTING DIGITAL
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 14,
                      offset: Offset(0, -3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Baris Indikator Mode Kerja Kuas Canting
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Alat Membatik:",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        Obx(() {
                          String statusText = "Mode Geser/Zoom 📱";
                          Color statusColor = Colors.blue;

                          if (controller.activeTool.value == CanvasTool.pen) {
                            statusText = "Mode Menggambar 🖌️";
                            statusColor = Colors.brown;
                          } else if (controller.activeTool.value ==
                              CanvasTool.eraser) {
                            statusText = "Mode Menghapus 🧼";
                            statusColor = Colors.redAccent;
                          }

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              statusText,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: statusColor,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Palet Pilihan Warna Malam / Lilin Canting
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _colorPickerButton(Colors.brown, controller),
                        _colorPickerButton(const Color(0xff0f2042), controller),
                        _colorPickerButton(Colors.black, controller),
                        _colorPickerButton(Colors.redAccent, controller),
                        GestureDetector(
                          onTap: () =>
                              _showCustomColorPickerDialog(context, controller),
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey.shade400,
                                width: 1.5,
                              ),
                            ),
                            child: const Icon(
                              Icons.colorize,
                              size: 20,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(thickness: 1),
                    const SizedBox(height: 8),

                    // Slider Ketebalan Ukuran Kuas Malam Canting + Grup Alat Aktif
                    Row(
                      children: [
                        const Icon(
                          Icons.line_weight,
                          size: 20,
                          color: Colors.black54,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Slider(
                            value: controller
                                .painterController.freeStyleStrokeWidth,
                            min: 0.5,
                            max: 15.0,
                            activeColor: Colors.brown,
                            inactiveColor: Colors.brown.withValues(alpha: 0.15),
                            onChanged: (value) =>
                                controller.changeBrushSize(value),
                          ),
                        ),
                        SizedBox(
                          width: 42,
                          child: Text(
                            "${controller.painterController.freeStyleStrokeWidth.toStringAsFixed(1)} px",
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          child: SizedBox(
                            height: 24,
                            child: VerticalDivider(
                              thickness: 1.5,
                              color: Colors.black12,
                            ),
                          ),
                        ),

                        // DOCK ALAT TERPADU: Pen, Eraser, dan tombol Undo aksi langsung
                        Obx(
                          () => Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _toolButton(
                                tool: CanvasTool.pen,
                                icon: Icons.brush,
                                isSelected: controller.activeTool.value ==
                                    CanvasTool.pen,
                                controller: controller,
                              ),
                              const SizedBox(width: 4),
                              _toolButton(
                                tool: CanvasTool.eraser,
                                icon: Icons.cleaning_services,
                                isSelected: controller.activeTool.value ==
                                    CanvasTool.eraser,
                                controller: controller,
                              ),
                              const SizedBox(width: 4),

                              // Tombol Undo Aksi Instan Samping Eraser
                              GestureDetector(
                                onTap: () => controller.undoDrawing(),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.undo,
                                    size: 20,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- Widget Generator Kontrol Bilah Alat ---
  Widget _toolButton({
    required CanvasTool tool,
    required IconData icon,
    required bool isSelected,
    required StudioCanvasPageController controller,
  }) {
    return GestureDetector(
      onTap: () => controller.changeTool(tool),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.brown.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? Colors.brown.withValues(alpha: 0.3)
                : Colors.transparent,
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isSelected ? Colors.brown : Colors.black54,
        ),
      ),
    );
  }

  Widget _colorPickerButton(
    Color color,
    StudioCanvasPageController controller,
  ) {
    bool isSelected = controller.painterController.freeStyleColor == color;
    return GestureDetector(
      onTap: () => controller.changeBrushColor(color),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(color: Colors.orange, width: 3)
              : Border.all(color: Colors.grey.shade300, width: 1),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.orange.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
      ),
    );
  }

  void _showCustomColorPickerDialog(
    BuildContext context,
    StudioCanvasPageController controller,
  ) {
    Color selectedColor = controller.painterController.freeStyleColor;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Pilih Warna Kustom',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: controller.painterController.freeStyleColor,
              onColorChanged: (color) => selectedColor = color,
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
              onPressed: () => Get.back(),
            ),
            TextButton(
              child: const Text(
                'Terapkan',
                style: TextStyle(
                  color: Colors.brown,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                controller.changeBrushColor(selectedColor);
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }
}
