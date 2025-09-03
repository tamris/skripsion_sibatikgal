class NewsItem {
  final String title;
  final String subtitle;
  final String deskripsi;
  final String categori;
  final String image;
  final DateTime? createdAt;
  // asset / url
  NewsItem({
    required this.title,
    required this.subtitle,
    required this.deskripsi,
    required this.categori,
    required this.image,
    this.createdAt,
  });
}
