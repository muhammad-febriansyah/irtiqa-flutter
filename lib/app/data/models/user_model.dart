class UserModel {
  final int id;
  final String name;
  final String email;
  final String? avatar;
  final String? avatarUrl;
  final DateTime? emailVerifiedAt;
  final List<String>? roles;
  final UserProfile? profile;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.avatarUrl,
    this.emailVerifiedAt,
    this.roles,
    this.profile,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'User',
      email: json['email'] as String? ?? '',
      avatar: json['avatar'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'] as String)
          : null,
      roles: json['roles'] != null
          ? List<String>.from(json['roles'] as Iterable)
          : null,
      profile: json['profile'] != null
          ? UserProfile.fromJson(json['profile'] as Map<String, dynamic>)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'avatar_url': avatarUrl,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'roles': roles,
      'profile': profile?.toJson(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  bool get isConsultant =>
      roles?.any((r) => r.toLowerCase() == 'consultant') ?? false;
  bool get isAdmin => roles?.any((r) => r.toLowerCase() == 'admin') ?? false;
  bool get isUser => !isAdmin && !isConsultant;
}

class UserProfile {
  final int id;
  final DateTime? birthDate;
  final String? gender;
  final String? phone;
  final String? address;
  final String? province;
  final String? city;
  final String? district;
  final String? postalCode;
  final String? bio;
  final DateTime? disclaimerAcceptedAt;
  final bool onboardingCompleted;

  UserProfile({
    required this.id,
    this.birthDate,
    this.gender,
    this.phone,
    this.address,
    this.province,
    this.city,
    this.district,
    this.postalCode,
    this.bio,
    this.disclaimerAcceptedAt,
    this.onboardingCompleted = false,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      birthDate: json['birth_date'] != null
          ? DateTime.parse(json['birth_date'])
          : null,
      gender: json['gender'],
      phone: json['phone'],
      address: json['address'],
      province: json['province'],
      city: json['city'],
      district: json['district'],
      postalCode: json['postal_code'],
      bio: json['bio'],
      disclaimerAcceptedAt: json['disclaimer_accepted_at'] != null
          ? DateTime.parse(json['disclaimer_accepted_at'])
          : null,
      onboardingCompleted: json['onboarding_completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'birth_date': birthDate?.toIso8601String(),
      'gender': gender,
      'phone': phone,
      'address': address,
      'province': province,
      'city': city,
      'district': district,
      'postal_code': postalCode,
      'bio': bio,
      'disclaimer_accepted_at': disclaimerAcceptedAt?.toIso8601String(),
      'onboarding_completed': onboardingCompleted,
    };
  }
}
