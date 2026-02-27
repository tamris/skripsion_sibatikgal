import 'package:intl/intl.dart';

class EventModel {
  String? id;
  String? title;
  String? kategori;
  String? description;
  String? bannerImageUrl;
  String? eventDate;
  String? latitude;
  String? longitude;
  dynamic address;
  bool? isFree;
  String? price;

  EventModel({
    this.id,
    this.title,
    this.kategori,
    this.description,
    this.bannerImageUrl,
    this.eventDate,
    this.latitude,
    this.longitude,
    this.address,
    this.isFree,
    this.price,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['_id']?.toString(), // Pastikan ID selalu string
      title: json['title'],
      kategori: json['kategori'],
      description: json['description'],
      bannerImageUrl: json['banner_image_url'],
      // Cek tipe data sebelum parse untuk menghindari crash
      eventDate: json['event_date'] is String ? json['event_date'] : null,
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
      address: json['address'],
      isFree: json['is_free'] ?? false,
      price: json['price']?.toString(),
    );
  }

  // Helper untuk memisahkan Tanggal dan Waktu dari format "2026-02-25T06:54"
  String get formattedDate {
    if (eventDate == null || eventDate!.isEmpty) return "-";
    try {
      final dt = DateTime.parse(eventDate!);
      // Setelah main.dart diperbaiki, baris ini akan berjalan lancar
      return DateFormat('d MMMM yyyy', 'id_ID').format(dt);
    } catch (e) {
      return "-"; // Balikkan strip jika format string dari API salah
    }
  }

  String get formattedTime {
    if (eventDate == null) return "-";
    final dt = DateTime.parse(eventDate!);
    return DateFormat('HH:mm').format(dt) + " WIB";
  }

  String get displayAddress {
    if (address == null) return "Lokasi tidak tersedia";

    // Jika di DB kamu simpan langsung sebagai teks (String)
    if (address is String) return address as String;

    // Jika di DB berupa Objek {}
    if (address is Map) {
      final Map<String, dynamic> map = Map<String, dynamic>.from(address);

      // Cek satu per satu kunci yang mungkin kamu gunakan
      return map['full_address']?.toString() ??
          map['alamat']?.toString() ??
          map['location']?.toString() ??
          map['name']?.toString() ??
          // Jika semua kunci di atas tidak ada, ambil nilai pertama apa pun di dalam objek itu
          (map.values.isNotEmpty
              ? map.values.first.toString()
              : "Detail lokasi tidak lengkap");
    }

    return "Lokasi tidak tersedia";
  }
}
