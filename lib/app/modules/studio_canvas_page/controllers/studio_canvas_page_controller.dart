import 'dart:convert';
import 'package:batikara/app/data/models/studio_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_painter_v2/flutter_painter.dart';
import 'package:batikara/app/data/service/studio_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

enum CanvasTool { pen, eraser, zoom }

class StudioCanvasPageController extends GetxController {
  // --- Layanan & Penyimpanan Data ---
  final StudioService _studioService = StudioService();
  final GetStorage _storage = GetStorage();

  // --- Komponen Inti Lembar Gambar ---
  late PainterController painterController;
  final GlobalKey canvasGlobalKey = GlobalKey();

  // Default awal diubah ke Mode Zoom/Geser agar UX aman dari coretan tidak sengaja
  final Rx<CanvasTool> activeTool = CanvasTool.zoom.obs;
  final RxBool isDrawingMode = false.obs;

  // --- Manajemen Status Tampilan UI ---
  final RxBool isLoading = true.obs;
  final RxBool isError = false.obs;
  final RxBool isLoadingDrafts = false.obs;
  final RxList<StudioBatikModel> batikList = <StudioBatikModel>[].obs;
  final RxList<StudioBatikModel> savedDraftsList = <StudioBatikModel>[].obs;
  final RxInt selectedBatikIndex = 0.obs;

  // --- Pintasan Data Terpilih (Getters) ---
  StudioBatikModel? get currentSelectedBatik {
    if (batikList.isEmpty) return null;
    return batikList[selectedBatikIndex.value];
  }

  // --- Siklus Hidup (Lifecycle) ---
  @override
  void onInit() {
    super.onInit();
    _initializeStudioData();
  }

  @override
  void onClose() {
    painterController.dispose();
    super.onClose();
  }

  // --- Proses Ambil Data Awal ---
  Future<void> _initializeStudioData() async {
    try {
      isLoading(true);
      isError(false); // Reset status error sebelum memulai request

      // 1. Ambil master list motif batik
      final canvasResult = await _studioService.fetchCanvasList();
      if (canvasResult.isNotEmpty) {
        batikList.assignAll(canvasResult);
        selectedBatikIndex.value = 0;
        initPainter();
      }

      // 2. Ambil list riwayat draf milik user secara sinkron
      final tokenJwt = _storage.read<String>('token');
      if (tokenJwt != null && tokenJwt.isNotEmpty) {
        final draftsResult = await _studioService.fetchMySavedDrafts(tokenJwt);
        savedDraftsList.assignAll(draftsResult);
      }
    } catch (e) {
      isError(true); // Aktifkan state error jaringan ke UI
      debugPrint("Gagal mengunduh data studio (jaringan/server down): $e");
    } finally {
      isLoading(false);
    }
  }

  // Fungsi publik yang dipanggil oleh tombol Retry saat jaringan pengguna kembali aktif
  Future<void> fetchBatikCanvasData() async {
    await _initializeStudioData();
  }

  // Memuat ulang daftar draf secara independen (Misal setelah proses simpan berhasil)
  Future<void> fetchUserSavedDrafts() async {
    try {
      isLoadingDrafts(true);
      final tokenJwt = _storage.read<String>('token');
      if (tokenJwt != null && tokenJwt.isNotEmpty) {
        final result = await _studioService.fetchMySavedDrafts(tokenJwt);
        savedDraftsList.assignAll(result);
      }
    } catch (e) {
      debugPrint("Gagal memuat daftar karya tersimpan: $e");
    } finally {
      isLoadingDrafts(false);
    }
  }

  // --- Pengaturan Kuas & Lembar Gambar ---
  void initPainter() {
    // Diinisialisasi awal dengan mode 'none' agar sinkron dengan status zoom default
    painterController = PainterController(
      settings: const PainterSettings(
        freeStyle: FreeStyleSettings(
          color: Colors.brown,
          strokeWidth: 4.0,
          mode: FreeStyleMode.none,
        ),
      ),
    );
    activeTool.value = CanvasTool.zoom;
    isDrawingMode.value = false;
  }

  void clearCanvasState() {
    initPainter();
    update();
  }

  void selectBatik(int index) {
    selectedBatikIndex.value = index;
    clearCanvasState();
  }

  // --- FITUR UTAMA: SIMPAN & MUAT HASIL KARYA ---

  /// Mengonversi goresan canting menjadi teks terstruktur untuk disimpan aman di server
  Future<void> saveCanvasDraftToDatabase(String batikId) async {
    try {
      final List<Drawable> drawables = painterController.value.drawables;
      final List<Map<String, dynamic>> jsonList = [];

      for (var drawable in drawables) {
        if (drawable is FreeStyleDrawable) {
          jsonList.add({
            'type': 'freeStyle',
            'points': drawable.path.map((p) => {'x': p.dx, 'y': p.dy}).toList(),
            'color': drawable.color.value,
            'strokeWidth': drawable.strokeWidth,
          });
        }
      }

      final String finalJsonString = jsonEncode(jsonList);
      final tokenJwt = _storage.read<String>('token');

      if (tokenJwt == null || tokenJwt.isEmpty) {
        _showSnackbar(
          'Sesi Berakhir',
          'Silakan masuk ke akun Anda kembali untuk menyimpan karya.',
        );
        return;
      }

      final isSuccess = await _studioService.saveCanvasDraft(
        batikId,
        finalJsonString,
        tokenJwt,
      );

      if (isSuccess) {
        await fetchUserSavedDrafts(); // Mengambil draf terbaru setelah berhasil disimpan
        Get.back();
        _showSnackbar(
          'Karya Disimpan',
          'Goresan canting Anda berhasil diamankan! Anda bisa melanjutkan atau mengubahnya kapan saja.',
          isSuccessStyle: true,
        );
      }
    } catch (e) {
      _showSnackbar(
        'Gagal Menyimpan',
        'Terjadi kendala saat mengamankan goresan canting Anda.',
      );
    }
  }

  /// Membaca data goresan dari server lalu menyusunnya kembali menjadi objek kuas yang aktif
  Future<void> loadUserCanvasDraft(String batikId) async {
    try {
      isLoading(true);
      final tokenJwt = _storage.read<String>('token');

      if (tokenJwt == null || tokenJwt.isEmpty) {
        _showSnackbar(
          'Sesi Berakhir',
          'Silakan masuk ke akun Anda kembali untuk memuat karya.',
        );
        return;
      }

      clearCanvasState();

      final dynamic canvasData = await _studioService.loadUserCanvasDraft(
        batikId,
        tokenJwt,
      );

      if (canvasData != null) {
        final List<dynamic> decodedList = canvasData is String
            ? jsonDecode(canvasData)
            : canvasData as List<dynamic>;

        final List<Drawable> restoredDrawables = [];

        for (var item in decodedList) {
          if (item['type'] == 'freeStyle') {
            final pointsData = item['points'] as List;
            final List<Offset> points = pointsData.map((p) {
              return Offset(
                (p['x'] as num).toDouble(),
                (p['y'] as num).toDouble(),
              );
            }).toList();

            restoredDrawables.add(
              FreeStyleDrawable(
                path: points,
                color: Color(item['color'] as int),
                strokeWidth: (item['strokeWidth'] as num).toDouble(),
              ),
            );
          }
        }

        painterController.value = painterController.value.copyWith(
          drawables: restoredDrawables,
        );

        // Catatan: Ketika berhasil memuat draf lama, kita tetap kembalikan ke default Mode Geser/Zoom demi kenyamanan UX
        painterController.freeStyleMode = FreeStyleMode.none;
        activeTool.value = CanvasTool.zoom;
        isDrawingMode.value = false;
      }
    } catch (e) {
      debugPrint("Gagal merestorasi kanvas: $e");
      _showSnackbar(
        'Belum Ada Coretan',
        'Lembar kerja ini masih kosong. Yuk, mulai buat goresan canting pertamamu!',
      );
    } finally {
      isLoading(false);
      update();
    }
  }

  // --- Navigasi & Kendali Bilah Alat Kontrol (Toolbar) ---
  void changeTool(CanvasTool tool) {
    if (activeTool.value == tool) {
      activeTool.value = CanvasTool.zoom;
      isDrawingMode.value = false;
      painterController.freeStyleMode = FreeStyleMode.none;
    } else {
      activeTool.value = tool;
      if (tool == CanvasTool.pen) {
        isDrawingMode.value = true;
        painterController.freeStyleMode = FreeStyleMode.draw;
      } else if (tool == CanvasTool.eraser) {
        isDrawingMode.value = true;
        painterController.freeStyleMode = FreeStyleMode.erase;
      }
    }
    update();
  }

  void changeBrushColor(Color color) {
    painterController.freeStyleColor = color;
    if (activeTool.value == CanvasTool.zoom ||
        activeTool.value == CanvasTool.eraser) {
      changeTool(CanvasTool.pen);
    }
    update();
  }

  void changeBrushSize(double size) {
    painterController.freeStyleStrokeWidth = size;
    update();
  }

  void undoDrawing() {
    painterController.undo();
    update();
  }

  // --- Komponen Pembantu UI (Snackbar) ---
  void _showSnackbar(
    String title,
    String message, {
    bool isSuccessStyle = false,
  }) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isSuccessStyle
          ? const Color(0xFF1A1208)
          : Colors.red.shade800,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 8,
    );
  }
}