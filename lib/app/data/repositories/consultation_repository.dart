import 'package:dio/dio.dart';
import '../models/consultation_model.dart';
import '../models/message_model.dart';
import '../providers/consultation_provider.dart';

class ConsultationRepository {
  final ConsultationProvider _provider = ConsultationProvider();

  Future<List<ConsultationModel>> getConsultations({int page = 1}) async {
    try {
      final response = await _provider.getConsultations(page: page);

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] as List;
        return data.map((json) => ConsultationModel.fromJson(json)).toList();
      }

      return [];
    } on DioException {
      return [];
    }
  }

  Future<ConsultationModel?> createConsultation({
    required int categoryId,
    required String subject,
    required String description,
    required String urgency,
    Map<String, dynamic>? screeningAnswers,
    bool isAnonymous = false,
  }) async {
    try {
      final response = await _provider.createConsultation(
        categoryId: categoryId,
        subject: subject,
        description: description,
        urgency: urgency,
        screeningAnswers: screeningAnswers,
        isAnonymous: isAnonymous,
      );

      if (response.data['success'] == true) {
        return ConsultationModel.fromJson(response.data['data']);
      }

      return null;
    } on DioException {
      rethrow;
    }
  }

  Future<ConsultationModel?> getConsultationDetails(int id) async {
    try {
      final response = await _provider.getConsultationDetails(id);

      if (response.data['success'] == true) {
        return ConsultationModel.fromJson(response.data['data']);
      }

      return null;
    } on DioException {
      return null;
    }
  }

  Future<List<MessageModel>> getMessages(int consultationId) async {
    try {
      final response = await _provider.getMessages(consultationId);

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] as List;
        return data.map((json) => MessageModel.fromJson(json)).toList();
      }

      return [];
    } on DioException {
      return [];
    }
  }

  Future<MessageModel?> sendMessage(int consultationId, String content) async {
    try {
      final response = await _provider.sendMessage(consultationId, content);

      if (response.data['success'] == true) {
        return MessageModel.fromJson(response.data['data']);
      }

      return null;
    } on DioException {
      rethrow;
    }
  }

  Future<bool> cancelConsultation(int id, {String? reason}) async {
    try {
      final response = await _provider.cancelConsultation(id, reason: reason);
      return response.data['success'] == true;
    } on DioException {
      return false;
    }
  }
}
