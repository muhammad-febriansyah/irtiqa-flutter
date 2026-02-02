class PackageModel {
  final int id;
  final String name;
  final String slug;
  final String description;
  final String? type;
  final int? sessionsCount;
  final int? durationDays;
  final double price;
  final List<String>? features;
  final String? tier;
  final bool isPublic;
  final int? maxSessions;
  final bool includesVoiceCall;
  final int? voiceCallCount;
  final int? voiceCallDurationMinutes;
  final bool isActive;
  final bool isFeatured;
  final int? sortOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PackageModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    this.type,
    this.sessionsCount,
    this.durationDays,
    required this.price,
    this.features,
    this.tier,
    required this.isPublic,
    this.maxSessions,
    required this.includesVoiceCall,
    this.voiceCallCount,
    this.voiceCallDurationMinutes,
    required this.isActive,
    required this.isFeatured,
    this.sortOrder,
    this.createdAt,
    this.updatedAt,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['id'] as int,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String? ?? '',
      type: json['type'] as String?,
      sessionsCount: json['sessions_count'] as int?,
      durationDays: json['duration_days'] as int?,
      price: double.parse(json['price'].toString()),
      features: json['features'] != null
          ? List<String>.from(json['features'] as List)
          : null,
      tier: json['tier'] as String?,
      isPublic: json['is_public'] as bool? ?? true,
      maxSessions: json['max_sessions'] as int?,
      includesVoiceCall: json['includes_voice_call'] as bool? ?? false,
      voiceCallCount: json['voice_call_count'] as int?,
      voiceCallDurationMinutes: json['voice_call_duration_minutes'] as int?,
      isActive: json['is_active'] as bool? ?? true,
      isFeatured: json['is_featured'] as bool? ?? false,
      sortOrder: json['sort_order'] as int?,
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
      'slug': slug,
      'description': description,
      'type': type,
      'sessions_count': sessionsCount,
      'duration_days': durationDays,
      'price': price,
      'features': features,
      'tier': tier,
      'is_public': isPublic,
      'max_sessions': maxSessions,
      'includes_voice_call': includesVoiceCall,
      'voice_call_count': voiceCallCount,
      'voice_call_duration_minutes': voiceCallDurationMinutes,
      'is_active': isActive,
      'is_featured': isFeatured,
      'sort_order': sortOrder,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  String get formattedPrice {
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }

  String get sessionsText {
    if (sessionsCount == null) return '';
    return '$sessionsCount Sesi';
  }

  String get durationText {
    if (durationDays == null) return '';
    return '$durationDays Hari';
  }
}
