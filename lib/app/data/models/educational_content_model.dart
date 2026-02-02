import 'user_model.dart';

class EducationalContentModel {
  final int id;
  final String title;
  final String? excerpt;
  final String content;
  final String category;
  final String? thumbnailUrl;
  final String? audioUrl;
  final int? duration; // in seconds for audio
  final bool isFeatured;
  final bool isPublished;
  final int viewsCount;
  final DateTime? publishedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserModel? author;

  EducationalContentModel({
    required this.id,
    required this.title,
    this.excerpt,
    required this.content,
    required this.category,
    this.thumbnailUrl,
    this.audioUrl,
    this.duration,
    this.isFeatured = false,
    this.isPublished = true,
    this.viewsCount = 0,
    this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
    this.author,
  });

  factory EducationalContentModel.fromJson(Map<String, dynamic> json) {
    return EducationalContentModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      excerpt: json['excerpt'] as String?,
      content: json['content'] as String? ?? '',
      category: json['category'] as String? ?? 'general',
      thumbnailUrl: json['thumbnail_url'] as String?,
      audioUrl: json['audio_url'] as String?,
      duration: json['duration'] as int?,
      isFeatured: json['is_featured'] as bool? ?? false,
      isPublished: json['is_published'] as bool? ?? true,
      viewsCount: json['views_count'] as int? ?? 0,
      publishedAt: json['published_at'] != null
          ? DateTime.parse(json['published_at'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
      author: json['author'] != null
          ? UserModel.fromJson(json['author'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'excerpt': excerpt,
      'content': content,
      'category': category,
      'thumbnail_url': thumbnailUrl,
      'audio_url': audioUrl,
      'duration': duration,
      'is_featured': isFeatured,
      'is_published': isPublished,
      'views_count': viewsCount,
      'published_at': publishedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'author': author?.toJson(),
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
      default:
        return category;
    }
  }

  bool get hasAudio => audioUrl != null && audioUrl!.isNotEmpty;

  String get durationText {
    if (duration == null) return '';
    final minutes = duration! ~/ 60;
    final seconds = duration! % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
