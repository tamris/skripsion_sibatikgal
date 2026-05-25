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
  });


  factory BatikModel.fromJson(Map<String, dynamic> json) {

    var colorsFromJson = json['dominant_color'];
    List<String> parsedColors = [];
    if (colorsFromJson != null && colorsFromJson is List) {
      parsedColors = List<String>.from(colorsFromJson.map((x) => x.toString()));
    }

    return BatikModel(
      id: json['_id']?.toString(), // Amankan konversi id ke string
      title: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      deskripsi: json['makna']?.toString() ?? '',
      filosophy: json['philosophy']?.toString() ?? '',
      technique: json['technique']?.toString() ?? '',
      history: json['history']?.toString() ?? '',
      dominantColors: parsedColors,
      // Disesuaikan menggunakan image_url agar sinkron dengan struktur data backend
      image: json['image_url']?.toString() ?? '',
    );
  }
}
