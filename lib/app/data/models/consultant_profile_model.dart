class ConsultantProfileModel {
  final int id;
  final int userId;
  final List<String> specialization;
  final String bio;
  final String certification;
  final bool isVerified;
  final double rating;
  final int totalConsultations;
  final String? level;
  final String? city;
  final String? province;

  ConsultantProfileModel({
    required this.id,
    required this.userId,
    required this.specialization,
    required this.bio,
    required this.certification,
    required this.isVerified,
    required this.rating,
    required this.totalConsultations,
    this.level,
    this.city,
    this.province,
  });

  factory ConsultantProfileModel.fromJson(Map<String, dynamic> json) {
    return ConsultantProfileModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      specialization: json['specialization'] != null
          ? (json['specialization'] is List
                ? List<String>.from(json['specialization'] as List)
                : [json['specialization'] as String])
          : [],
      bio: json['bio'] as String? ?? '',
      certification: json['certification'] as String? ?? '',
      isVerified: json['is_verified'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      totalConsultations: json['total_consultations'] as int? ?? 0,
      level: json['level'] as String?,
      city: json['city'] as String?,
      province: json['province'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'specialization': specialization,
      'bio': bio,
      'certification': certification,
      'is_verified': isVerified,
      'rating': rating,
      'total_consultations': totalConsultations,
      'level': level,
      'city': city,
      'province': province,
    };
  }
}
