import 'package:batikara/app/data/models/sejarah_model.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class SejarahPageController extends GetxController {
  // List data sejarah dari hardcode
  final List<SejarahModel> sejarahList = sejarahData;
  final List<String> connectors = connectorLabels;

  // Scroll controller kalau butuh track posisi
  // (opsional, bisa dipakai kalau mau animasi dot aktif saat scroll)

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> shareSejarah() async {
    final buffer = StringBuffer();

    buffer.writeln("📜 SEJARAH BATIK TEGALAN");
    buffer.writeln("━━━━━━━━━━━━━━━━━━━━━━");
    buffer.writeln();

    for (final item in sejarahList) {
      buffer.writeln("📍 ${item.tahun}");
      buffer.writeln(item.judul.replaceAll('\n', ' '));
      buffer.writeln(item.deskripsi);

      if (item.motifChips.isNotEmpty) {
        buffer.writeln("🏷 ${item.motifChips.join(" • ")}");
      }

      if (item.infoCardJudul != null) {
        buffer.writeln();
        buffer.writeln("💡 ${item.infoCardJudul}");
        buffer.writeln(item.infoCardDeskripsi);
      }

      if (item.quote != null) {
        buffer.writeln();
        buffer.writeln(item.quote);
      }

      if (item.stats != null) {
        buffer.writeln();
        item.stats!.forEach((k, v) {
          buffer.writeln("• $k : $v");
        });
      }

      buffer.writeln();
      buffer.writeln("━━━━━━━━━━━━━━━━━━━━━━");
      buffer.writeln();
    }

    buffer.writeln(
        "🇮🇩 Mari lestarikan Batik Tegalan sebagai bagian dari kekayaan budaya Indonesia.");
    buffer.writeln();
    buffer.writeln("📲 Dibagikan dari aplikasi Sibatikgal.");

    await SharePlus.instance.share(
      ShareParams(
        subject: "Sejarah Batik Tegalan",
        text: buffer.toString(),
      ),
    );
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
