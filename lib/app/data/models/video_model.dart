import 'package:intl/intl.dart';

class VideoModel {
  String? id;
  String? judul;
  String? deskripsi;
  String? kategori;
  String? youtubeUrl;
  String? videoId;
  String? thumbnailUrl;
  int? viewCount;
  int? durationMinutes;
  int? durationSeconds;
  String? channelName;
  DateTime? createdAt;

  VideoModel({
    this.id,
    this.judul,
    this.deskripsi,
    this.kategori,
    this.youtubeUrl,
    this.videoId,
    this.thumbnailUrl,
    this.viewCount,
    this.durationMinutes,
    this.durationSeconds,
    this.channelName,
    this.createdAt,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['_id']?.toString(),
      judul: json['title'],
      deskripsi: json['description'],
      kategori: json['category'],
      youtubeUrl: json['youtube_url'],
      videoId: json['video_id'],
      thumbnailUrl: json['thumbnail_url'],
      viewCount: json['view_count'] != null
          ? int.tryParse(json['view_count'].toString())
          : null,
      durationMinutes: json['duration_minutes'] != null
          ? int.tryParse(json['duration_minutes'].toString())
          : null,
      durationSeconds: json['duration_seconds'] != null
          ? int.tryParse(json['duration_seconds'].toString())
          : null,
      channelName: json['channel_name'],
      createdAt: json['created_at'] != null && json['created_at'] is String
          ? DateFormat("yyyy-MM-dd HH:mm:ss").parse(json['created_at'])
          : null,
    );
  }

  /// Thumbnail: prioritas dari DB, fallback generate dari URL
  String get getThumbnail {
    if (thumbnailUrl != null && thumbnailUrl!.isNotEmpty) return thumbnailUrl!;

    final url = youtubeUrl ?? '';
    if (url.isEmpty) return '';
    final uri = Uri.parse(url);
    String? vid;
    if (uri.host.contains('youtu.be')) {
      vid = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
    } else if (uri.host.contains('youtube.com')) {
      vid = uri.queryParameters['v'];
    }
    return vid != null ? 'https://img.youtube.com/vi/$vid/hqdefault.jpg' : '';
  }

  /// Format views: 4200 → "4.2rb", 1500000 → "1.5jt"
  String get formattedViews {
    if (viewCount == null) return '';
    if (viewCount! >= 1000000) {
      return '${(viewCount! / 1000000).toStringAsFixed(1)}jt ditonton';
    } else if (viewCount! >= 1000) {
      return '${(viewCount! / 1000).toStringAsFixed(1)}rb ditonton';
    }
    return '$viewCount ditonton';
  }

  // 743 detik → "12:23"
  String get formattedDuration {
    if (durationSeconds == null) return '';
    final m = durationSeconds! ~/ 60;
    final s = durationSeconds! % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String get timeAgo {
    if (createdAt == null) return 'Baru saja';
    final diff = DateTime.now().difference(createdAt!);
    if (diff.inDays == 0) return 'Hari ini';
    return DateFormat('dd MMM yyyy').format(createdAt!);
  }
}