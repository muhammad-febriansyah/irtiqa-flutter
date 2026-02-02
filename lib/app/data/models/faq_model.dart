class FaqModel {
  final int id;
  final String question;
  final String answer;
  final String category;
  final int order;
  final bool isPublished;
  final int viewsCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  FaqModel({
    required this.id,
    required this.question,
    required this.answer,
    required this.category,
    this.order = 0,
    this.isPublished = true,
    this.viewsCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['id'] as int? ?? 0,
      question: json['question'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
      category: json['category'] as String? ?? 'general',
      order: json['order'] as int? ?? 0,
      isPublished: json['is_published'] as bool? ?? true,
      viewsCount: json['views_count'] as int? ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'category': category,
      'order': order,
      'is_published': isPublished,
      'views_count': viewsCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get categoryText {
    switch (category) {
      case 'psycho_spiritual':
        return 'Psiko-Spiritual';
      case 'dream_sleep':
        return 'Mimpi & Tidur';
      case 'waswas_worship':
        return 'Waswas & Ibadah';
      case 'family_children':
        return 'Keluarga & Anak';
      case 'facing_trials':
        return 'Adab Menghadapi Ujian';
      case 'general':
        return 'Umum';
      default:
        return category;
    }
  }
}
