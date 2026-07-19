import 'package:batikara/app/data/config/app_config.dart';
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
    // =========================================================================
    // FIX LOGIC FOR AUTHOR NAME: Antisipasi jika data yang dikirim adalah Object/Map
    // =========================================================================
    String extractedAuthor = "Admin Batik Tegal";

    String rawImage =
        json['image_url']?.toString() ?? json['image']?.toString() ?? '';

    // KUNCI UTAMA: Cek secara otomatis. Jika belum ada domain 'http', otomatis tambahkan baseUrl!
    if (rawImage.isNotEmpty && !rawImage.startsWith('http')) {
      rawImage = '${AppConfig.baseUrl}/static/img/informasi/$rawImage';
    }

    // 1. Cek dari field 'author_name' atau 'created_by'
    var authorRaw = json['author_name'] ?? json['created_by'];
    if (authorRaw != null) {
      if (authorRaw is Map) {
        extractedAuthor = authorRaw['name']?.toString() ?? "Admin Batik Tegal";
      } else {
        extractedAuthor = authorRaw.toString();
      }
    }
    // 2. Cek fallback dari field pipeline 'admin_data' yang dikirim backend Flask
    else if (json['admin_data'] != null && json['admin_data'] is Map) {
      extractedAuthor = json['admin_data']['name']?.toString() ??
          json['admin_data']['username']?.toString() ??
          "Admin Batik Tegal";
    }

    return InformasiModel(
      id: json['_id']?.toString(), // Amankan agar selalu dikonversi string
      title: json['title']?.toString(),
      deskripsi: json['description']?.toString(),
      categori: json['category']?.toString(),
      imageUrl: rawImage, // Gunakan nilai yang sudah diperbaiki
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      authorName: extractedAuthor, // Masukkan data author aman
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
