class BatikModel {
  String? id;
  String title;
  String category;
  String deskripsi;
  String image;

  BatikModel({
    this.id,
    required this.title,
    required this.category,
    required this.deskripsi,
    required this.image,
  });

  // Fungsi untuk konversi JSON dari API ke Object
  factory BatikModel.fromJson(Map<String, dynamic> json) {
    return BatikModel(
      id: json['_id'],
      title: json['name'] ?? '',
      category: json['category'] ?? '',
      deskripsi: json['makna'] ?? json['makna'] ?? '',
      // Jika dari API, biasanya image berupa URL
      image: json['image_url'] ?? '',
    );
  }
}
