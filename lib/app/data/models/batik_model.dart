class BatikModel {
  String? id;
  String title;
  String category;
  String deskripsi;
  String filosophy;
  String technique;
  String history;
  List<String> dominantColors;
  String image;
  bool
      isLiked; // <--- 1. TAMBAHKAN VARIABEL UNTUK MENAMPUNG STATUS FAVORIT USER

  BatikModel({
    this.id,
    required this.title,
    required this.category,
    required this.deskripsi,
    required this.filosophy,
    required this.technique,
    required this.history,
    required this.dominantColors,
    required this.image,
    this.isLiked = false, // <--- 2. BERIKAN DEFAULT VALUE FALSE AGAR AMAN
  });

  factory BatikModel.fromJson(Map<String, dynamic> json) {
    var colorsFromJson = json['dominant_color'];
    List<String> parsedColors = [];
    if (colorsFromJson != null && colorsFromJson is List) {
      parsedColors = List<String>.from(colorsFromJson.map((x) => x.toString()));
    }

    print(
        "DEBUG MODEL -> Batik: ${json['name']}, Ambil 'is_liked' dari server: ${json['is_liked']}");

    return BatikModel(
      id: json['_id']?.toString(),
      title: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      deskripsi: json['makna']?.toString() ?? '',
      filosophy: json['philosophy']?.toString() ?? '',
      technique: json['technique']?.toString() ?? '',
      history: json['history']?.toString() ?? '',
      dominantColors: parsedColors,
      image: json['image_url']?.toString() ?? '',
      // --- 3. SINKRONISASI DARI BACKEND FLASK ---
      isLiked: json['is_liked'] ?? false,
    );
  }
}
