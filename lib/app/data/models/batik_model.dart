class BatikModel {
  final String title;
  final String deskripsi;
  final String image;
  final DateTime? createdAt;
  // asset / url
  BatikModel({
    required this.title,
    required this.deskripsi,
    required this.image,
    this.createdAt,
  });
}