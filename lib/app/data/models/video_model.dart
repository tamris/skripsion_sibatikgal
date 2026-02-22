// lib/app/data/models/video_model.dart
import 'package:intl/intl.dart';

class VideoModel {
  String? id;
  String? judul;
  String? deskripsi;
  String? kategori;
  String? youtubeUrl; // Sesuai image_11d821.png
  DateTime? createdAt;

  VideoModel({this.id, this.judul, this.deskripsi, this.kategori, this.youtubeUrl, this.createdAt});

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['_id']?.toString(),
      judul: json['judul'], // Sesuai image_11d821.png
      deskripsi: json['deskripsi'],
      kategori: json['kategori'],
      youtubeUrl: json['youtube_url'], // Sesuai image_11d821.png
      // Gunakan pengecekan tipe data untuk menghindari error _Map
      createdAt: json['created_at'] != null && json['created_at'] is String
          ? DateFormat("yyyy-MM-dd HH:mm:ss").parse(json['created_at'])
          : null,
    );
  }

  // Fungsi ambil thumbnail YouTube
  String get getYoutubeThumbnail {
    if (youtubeUrl == null || youtubeUrl!.isEmpty) return '';
    
    // Support link youtu.be dan youtube.com
    final uri = Uri.parse(youtubeUrl!);
    String? videoId;
    
    if (uri.host.contains('youtu.be')) {
      videoId = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
    } else if (uri.host.contains('youtube.com')) {
      videoId = uri.queryParameters['v'];
    }

    return videoId != null 
        ? 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg' 
        : '';
  }

  String get timeAgo {
    if (createdAt == null) return "Baru saja";
    final diff = DateTime.now().difference(createdAt!);
    if (diff.inDays == 0) return "Hari ini";
    return DateFormat('dd MMM yyyy').format(createdAt!);
  }
}