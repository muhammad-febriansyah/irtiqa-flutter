class DreamModel {
  final int id;
  final int userId;
  final String title;
  final String content;
  final String? emotionalState;
  final List<String> keywords;
  final String? classification;
  final bool consultationRecommended;
  final String? suggestedAction;
  final DateTime dreamDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  DreamModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    this.emotionalState,
    this.keywords = const [],
    this.classification,
    this.consultationRecommended = false,
    this.suggestedAction,
    required this.dreamDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DreamModel.fromJson(Map<String, dynamic> json) {
    return DreamModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      emotionalState: json['emotional_state'] as String?,
      keywords: json['keywords'] != null
          ? List<String>.from(json['keywords'] as List)
          : [],
      classification: json['classification'] as String?,
      consultationRecommended:
          json['consultation_recommended'] as bool? ?? false,
      suggestedAction: json['suggested_action'] as String?,
      dreamDate: DateTime.parse(json['dream_date'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'content': content,
      'emotional_state': emotionalState,
      'keywords': keywords,
      'classification': classification,
      'consultation_recommended': consultationRecommended,
      'suggested_action': suggestedAction,
      'dream_date': dreamDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get classificationText {
    switch (classification) {
      case 'khayali_nafsani':
        return 'Mimpi Biasa';
      case 'emotional':
        return 'Mimpi Emosional';
      case 'sensitive_indication':
        return 'Perlu Perhatian';
      case 'needs_consultation':
        return 'Saran Konsultasi';
      default:
        return 'Belum Diklasifikasi';
    }
  }
}
