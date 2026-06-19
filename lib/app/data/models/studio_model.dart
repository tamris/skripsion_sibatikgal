class StudioBatikModel {
  final String id;
  final String name;
  final String category;
  final String technique;
  final String philosophy;
  final String imageUrl;
  final String sketchImageUrl;
  final bool isSketsaAvailable;

  StudioBatikModel({
    required this.id,
    required this.name,
    required this.category,
    required this.technique,
    required this.philosophy,
    required this.imageUrl,
    required this.sketchImageUrl,
    required this.isSketsaAvailable,
  });

  factory StudioBatikModel.fromJson(Map<String, dynamic> json) {
    return StudioBatikModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      technique: json['technique'] ?? '',
      philosophy: json['philosophy'] ?? '',
      imageUrl: json['image_url'] ?? '',
      sketchImageUrl: json['sketch_image_url'] ?? '',
      isSketsaAvailable: json['is_sketsa_available'] ?? true,
    );
  }
}