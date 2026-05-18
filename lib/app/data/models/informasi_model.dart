import 'package:intl/intl.dart';

class InformasiModel {
  String? id;
  String? title;
  String? deskripsi;
  String? categori;
  String? imageUrl;
  DateTime? createdAt;

  InformasiModel({
    this.id,
    this.title,
    this.deskripsi,
    this.categori,
    this.imageUrl,
    this.createdAt,
  });

  factory InformasiModel.fromJson(Map<String, dynamic> json) {
    return InformasiModel(
      id: json['_id'],
      title: json['title'],
      deskripsi: json['description'],
      categori: json['category'],
      imageUrl: json['image_url'],
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
