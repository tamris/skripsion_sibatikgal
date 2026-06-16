class MappingModel {
  bool? success;
  String? message;
  List<MappingModelData>? data;

  MappingModel({this.success, this.message, this.data});

  MappingModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MappingModelData>[];
      json['data'].forEach((v) {
        data!.add(MappingModelData.fromJson(v));
      });
    }
  }
}

class MappingModelData {
  String? id;
  String? userId;
  String? name;
  String? description;
  String? category;
  List<String>? categories;
  double? latitude;
  double? longitude;
  Map<String, dynamic>? address;
  String? bannerImageUrl; // Sesuai dengan User Correction Ledger kamu
  double? averageRating;
  int? totalReviews;
  double? distance;
  String? phone; 
  List<ReviewModel>? reviews; // <-- 1. DAFTARKAN LIST REVIEW MODEL DI SINI

  MappingModelData({
    this.id,
    this.userId,
    this.name,
    this.description,
    this.category,
    this.categories,
    this.latitude,
    this.longitude,
    this.address,
    this.bannerImageUrl,
    this.averageRating,
    this.totalReviews,
    this.distance,
    this.phone,
    this.reviews, // <-- 2. MASUKKAN KE CONSTRUCTOR
  });

  factory MappingModelData.fromJson(Map<String, dynamic> json) {
    double? parseCoordinate(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    return MappingModelData(
      id: json['_id'] ?? json['id'],
      userId: json['user_id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      categories: json['categories'] != null
          ? List<String>.from(json['categories'].map((x) => x.toString()))
          : [],
      latitude: parseCoordinate(json['latitude']),
      longitude: parseCoordinate(json['longitude']),
      address: json['address'],
      bannerImageUrl: json['banner_image_url'] ?? json['image_url'],
      averageRating: json['average_rating']?.toDouble() ?? 0.0,
      totalReviews: json['total_reviews'] ?? 0,
      phone: json['phone']?.toString(),
      
      // 3. PARSING DATA ARRAY OBJECT REVIEWS DARI MONGO SECARA AMAN
      reviews: json['reviews'] != null
          ? List<ReviewModel>.from(
              json['reviews'].map((x) => ReviewModel.fromJson(x)),
            )
          : [],
    );
  }
}

// 4. BUAT CLASS SUB-MODEL BARU UNTUK STRUKTUR DATA REVIEWS MONGO DB
class ReviewModel {
  String? reviewId;
  String? userId;
  String? username;
  double? rating;
  String? comment;
  String? createdAt;

  ReviewModel({
    this.reviewId,
    this.userId,
    this.username,
    this.rating,
    this.comment,
    this.createdAt,
  });

  ReviewModel.fromJson(Map<String, dynamic> json) {
    reviewId = json['review_id']?.toString();
    userId = json['user_id']?.toString();
    username = json['username'] ?? 'Anonim';
    rating = json['rating'] is num ? (json['rating'] as num).toDouble() : 0.0;
    comment = json['comment'] ?? '-';
    createdAt = json['created_at']?.toString();
  }
}