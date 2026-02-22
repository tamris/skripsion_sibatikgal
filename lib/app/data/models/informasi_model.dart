import 'package:intl/intl.dart';

class InformasiModel {
  String? id;
  String? title;
  String? deskripsi;
  String? categori;
  String? gambarUrl;
  DateTime? createdAt;

  InformasiModel({
    this.id,
    this.title,
    this.deskripsi,
    this.categori,
    this.gambarUrl,
    this.createdAt,
  });

  factory InformasiModel.fromJson(Map<String, dynamic> json) {
    return InformasiModel(
      id: json['_id'],
      title: json['judul'],
      deskripsi: json['deskripsi'],
      categori: json['kategori'],
      gambarUrl: json['gambar_url'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  String get timeAgo {
    if (createdAt == null) return "Baru saja";

    final now = DateTime.now();
    final difference = now.difference(createdAt!);

    // Cek apakah di hari yang sama
    if (difference.inDays == 0) {
      if (difference.inHours >= 1) {
        return "${difference.inHours} jam yang lalu";
      } else if (difference.inMinutes >= 1) {
        return "${difference.inMinutes} menit yang lalu";
      } else {
        return "Baru saja";
      }
    } else {
      // Jika sudah beda hari, tampilkan tanggal
      return DateFormat('dd MMM yyyy').format(createdAt!);
    }
  }
}
