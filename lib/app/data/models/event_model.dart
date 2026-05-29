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
  String? registrationUrl;
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
    this.registrationUrl,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['_id']?.toString(), // Pastikan ID selalu string
      title: json['title'],
      kategori: json['category']?.toString() ?? '',
      description: json['description'],
      bannerImageUrl: json['banner_image_url'],
      // Cek tipe data sebelum parse untuk menghindari crash
      eventDate: json['event_date'] is String ? json['event_date'] : null,
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
      address: json['address'],
      isFree: json['is_free'] ?? false,
      price: json['price']?.toString(),
      registrationUrl: json['registration_url']?.toString(),
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

  // Tambahkan di dalam class EventModel kamu
  String get formattedPrice {
    if (price == null || price == '0' || price!.isEmpty) {
      return '0';
    }

    // Hapus karakter non-angka jika API mengirimkan string seperti "Rp 25.000"
    final cleanPrice = price!.replaceAll(RegExp(r'[^0-9]'), '');
    final double numPrice = double.tryParse(cleanPrice) ?? 0;

    if (numPrice == 0) return '0';

    if (numPrice >= 1000000) {
      // Jika 1.000.000+ -> 1M atau 1.5M
      double result = numPrice / 1000000;
      // Menghilangkan .0 jika angka bulat (misal 1.0 M jadi 1M)
      return result % 1 == 0
          ? '${result.toInt()}M'
          : '${result.toStringAsFixed(1)}M';
    } else if (numPrice >= 1000) {
      // Jika 1.000+ -> 25K atau 150K
      double result = numPrice / 1000;
      return result % 1 == 0
          ? '${result.toInt()}K'
          : '${result.toStringAsFixed(1)}K';
    }

    return cleanPrice;
  }

  /// Formatted currency in Indonesian locale, e.g. "Rp 50.000"
  String get formattedCurrency {
    try {
      if (price == null || price == '0' || price!.isEmpty) return 'Rp 0';
      final cleanPrice = price!.replaceAll(RegExp(r'[^0-9]'), '');
      final double numPrice = double.tryParse(cleanPrice) ?? 0;
      final formatter = NumberFormat.currency(
          locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
      return formatter.format(numPrice);
    } catch (_) {
      return 'Rp 0';
    }
  }

  bool get hasRegistrationUrl =>
      registrationUrl != null && registrationUrl!.trim().isNotEmpty;
}
