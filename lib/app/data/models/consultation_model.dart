class ConsultationModel {
  final int id;
  final int userId;
  final int? consultantId;
  final int categoryId;
  final String subject;
  final String problemDescription;
  final String status;
  final String type; // 'initial_free' or 'paid_program'
  final String? urgency;
  final String? riskLevel;
  final bool isAnonymous;
  final Map<String, dynamic>? screeningAnswers;
  final String? cancellationReason;
  final DateTime? cancelledAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  ConsultationModel({
    required this.id,
    required this.userId,
    this.consultantId,
    required this.categoryId,
    required this.subject,
    required this.problemDescription,
    required this.status,
    this.type = 'initial_free',
    this.urgency,
    this.riskLevel,
    this.isAnonymous = false,
    this.screeningAnswers,
    this.cancellationReason,
    this.cancelledAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ConsultationModel.fromJson(Map<String, dynamic> json) {
    return ConsultationModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      consultantId: json['consultant_id'] as int?,
      categoryId: json['category_id'] as int,
      subject: json['subject'] as String,
      problemDescription: json['problem_description'] as String,
      status: json['status'] as String,
      type: json['type'] as String? ?? 'initial_free',
      urgency: json['urgency'] as String?,
      riskLevel: json['risk_level'] as String?,
      isAnonymous: json['is_anonymous'] as bool? ?? false,
      screeningAnswers: json['screening_answers'] as Map<String, dynamic>?,
      cancellationReason: json['cancellation_reason'] as String?,
      cancelledAt: json['cancelled_at'] != null
          ? DateTime.parse(json['cancelled_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'consultant_id': consultantId,
      'category_id': categoryId,
      'subject': subject,
      'problem_description': problemDescription,
      'status': status,
      'type': type,
      'urgency': urgency,
      'risk_level': riskLevel,
      'is_anonymous': isAnonymous,
      'screening_answers': screeningAnswers,
      'cancellation_reason': cancellationReason,
      'cancelled_at': cancelledAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get statusText {
    switch (status) {
      case 'waiting':
        return 'Sedang Ditinjau';
      case 'in_progress':
        return 'Pendampingan Aktif';
      case 'completed':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return status;
    }
  }

  String get typeText {
    switch (type) {
      case 'initial_free':
        return 'Konsultasi Awal (Gratis)';
      case 'paid_program':
        return 'Program Pembimbingan';
      default:
        return type;
    }
  }

  bool get isInitialFree => type == 'initial_free';
  bool get isPaidProgram => type == 'paid_program';
}
