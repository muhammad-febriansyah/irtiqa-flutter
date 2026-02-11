class DreamModel {
  final int id;
  final int userId;
  final String dreamContent;
  final DateTime dreamDate;
  final String? dreamTime;
  final String? physicalCondition;
  final String? emotionalCondition;
  final String? classification;
  final String? autoAnalysis;
  final List<String> suggestedActions;
  final bool disclaimerChecked;
  final bool requestedConsultation;
  final int? consultationTicketId;
  final DateTime createdAt;
  final DateTime updatedAt;

  DreamModel({
    required this.id,
    required this.userId,
    required this.dreamContent,
    required this.dreamDate,
    this.dreamTime,
    this.physicalCondition,
    this.emotionalCondition,
    this.classification,
    this.autoAnalysis,
    this.suggestedActions = const [],
    this.disclaimerChecked = false,
    this.requestedConsultation = false,
    this.consultationTicketId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DreamModel.fromJson(Map<String, dynamic> json) {
    return DreamModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      dreamContent: json['dream_content'] as String,
      dreamDate: DateTime.parse(json['dream_date'] as String),
      dreamTime: json['dream_time'] as String?,
      physicalCondition: json['physical_condition'] as String?,
      emotionalCondition: json['emotional_condition'] as String?,
      classification: json['classification'] as String?,
      autoAnalysis: json['auto_analysis'] as String?,
      suggestedActions: json['suggested_actions'] != null
          ? List<String>.from(json['suggested_actions'] as List)
          : [],
      disclaimerChecked: json['disclaimer_checked'] as bool? ?? false,
      requestedConsultation: json['requested_consultation'] as bool? ?? false,
      consultationTicketId: json['consultation_ticket_id'] as int?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'dream_content': dreamContent,
      'dream_date': dreamDate.toIso8601String().split('T')[0],
      'dream_time': dreamTime,
      'physical_condition': physicalCondition,
      'emotional_condition': emotionalCondition,
      'classification': classification,
      'auto_analysis': autoAnalysis,
      'suggested_actions': suggestedActions,
      'disclaimer_checked': disclaimerChecked,
      'requested_consultation': requestedConsultation,
      'consultation_ticket_id': consultationTicketId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get classificationText {
    switch (classification) {
      case 'khayali_nafsani':
        return 'Mimpi Biasa';
      case 'emotional':
        return 'Terkait Emosi';
      case 'sensitive_indication':
        return 'Perlu Perhatian';
      case 'needs_consultation':
        return 'Perlu Konsultasi';
      default:
        return classification ?? 'Belum Diklasifikasi';
    }
  }

  String get dreamTimeText {
    switch (dreamTime) {
      case 'dawn':
        return 'Subuh';
      case 'morning':
        return 'Pagi';
      case 'afternoon':
        return 'Siang';
      case 'evening':
        return 'Sore';
      case 'night':
        return 'Malam';
      default:
        return dreamTime ?? 'Tidak Diketahui';
    }
  }

  String get physicalConditionText {
    switch (physicalCondition) {
      case 'healthy':
        return 'Sehat';
      case 'sick':
        return 'Sakit';
      case 'tired':
        return 'Lelah';
      case 'stressed':
        return 'Stress';
      default:
        return physicalCondition ?? '-';
    }
  }

  String get emotionalConditionText {
    switch (emotionalCondition) {
      case 'calm':
        return 'Tenang';
      case 'happy':
        return 'Senang';
      case 'sad':
        return 'Sedih';
      case 'anxious':
        return 'Gelisah';
      case 'angry':
        return 'Marah';
      default:
        return emotionalCondition ?? '-';
    }
  }

  bool get needsAttention {
    return classification == 'sensitive_indication' ||
        classification == 'needs_consultation';
  }
}

