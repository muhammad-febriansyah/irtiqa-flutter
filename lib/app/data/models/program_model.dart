class ProgramModel {
  final int id;
  final String? programNumber;
  final int userId;
  final int consultantId;
  final int packageId;
  final String title;
  final String? description;
  final List<String> goals;
  final String status;
  final int progressPercentage;
  final int totalSessions;
  final int completedSessions;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProgramModel({
    required this.id,
    this.programNumber,
    required this.userId,
    required this.consultantId,
    required this.packageId,
    required this.title,
    this.description,
    this.goals = const [],
    required this.status,
    this.progressPercentage = 0,
    this.totalSessions = 0,
    this.completedSessions = 0,
    this.startDate,
    this.endDate,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProgramModel.fromJson(Map<String, dynamic> json) {
    return ProgramModel(
      id: json['id'] as int,
      programNumber: json['program_number'] as String?,
      userId: json['user_id'] as int,
      consultantId: json['consultant_id'] as int,
      packageId: json['package_id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      goals: json['goals'] != null
          ? List<String>.from(json['goals'] as List)
          : [],
      status: json['status'] as String,
      progressPercentage: json['progress_percentage'] as int? ?? 0,
      totalSessions: json['total_sessions'] as int? ?? 0,
      completedSessions: json['completed_sessions'] as int? ?? 0,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'] as String)
          : null,
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'] as String)
          : null,
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'program_number': programNumber,
      'user_id': userId,
      'consultant_id': consultantId,
      'package_id': packageId,
      'title': title,
      'description': description,
      'goals': goals,
      'status': status,
      'progress_percentage': progressPercentage,
      'total_sessions': totalSessions,
      'completed_sessions': completedSessions,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get statusText {
    switch (status) {
      case 'pending':
        return 'Menunggu Persetujuan';
      case 'in_progress':
        return 'Sedang Berjalan';
      case 'completed':
        return 'Selesai';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return status;
    }
  }

  String get progressText {
    return '$completedSessions dari $totalSessions sesi ($progressPercentage%)';
  }

  bool get isActive => status == 'in_progress';
  bool get isCompleted => status == 'completed';
  bool get isPending => status == 'pending';
}
