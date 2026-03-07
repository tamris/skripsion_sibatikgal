class BatikModel {
  String? id;
  String title;
  String deskripsi;
  String image;

  BatikModel({
    this.id,
    required this.title,
    required this.deskripsi,
    required this.image,
  });

  // Fungsi untuk konversi JSON dari API ke Object
  factory BatikModel.fromJson(Map<String, dynamic> json) {
    return BatikModel(
      id: json['_id'],
      title: json['nama'] ?? '',
      deskripsi: json['makna'] ?? json['makna'] ?? '',
      // Jika dari API, biasanya image berupa URL
      image: json['gambar_url'] ?? '',
    );
  }
}
