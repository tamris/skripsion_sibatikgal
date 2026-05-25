import 'package:intl/intl.dart';

class InformasiModel {
  String? id;
  String? title;
  String? deskripsi;
  String? categori;
  String? imageUrl;
  DateTime? createdAt;
  // TAMBAHKAN FIELD INI
  String? authorName;

  InformasiModel({
    this.id,
    this.title,
    this.deskripsi,
    this.categori,
    this.imageUrl,
    this.createdAt,
    this.authorName, // Tambahkan di constructor
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
      // PETAKAN FIELD DARI BACKEND DI SINI
      // Sesuaikan key 'author_name' atau 'created_by' dengan response JSON dari Flask kamu
      authorName:
          json['author_name'] ?? json['created_by'] ?? "Admin Batik Tegal",
    );
  }

  // Helper untuk mendapatkan inisial nama (Misal: "Ahmad Dani" -> "AD")
  String get authorInitial {
    if (authorName == null || authorName!.isEmpty) return "AD";
    List<String> words = authorName!.trim().split(' ');
    if (words.length > 1) {
      return (words[0][0] + words[1][0]).toUpperCase();
    }
    return words[0][0].toUpperCase();
  }

  String get timeAgo {
    if (createdAt == null) return "Baru saja";
    final now = DateTime.now();
    final difference = now.difference(createdAt!);

    if (difference.inDays == 0) {
      if (difference.inHours >= 1) {
        return "${difference.inHours} jam yang lalu";
      } else if (difference.inMinutes >= 1) {
        return "${difference.inMinutes} menit yang lalu";
      } else {
        return "Baru saja";
      }
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      final hours = difference.inHours % 24;
      if (hours > 0) {
        return "$days hari $hours jam yang lalu";
      }
      return "$days hari yang lalu";
    } else {
      return DateFormat('dd MMM yyyy | HH:mm WIB').format(createdAt!);
    }
  }
}