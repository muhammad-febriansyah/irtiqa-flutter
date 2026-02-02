import 'package:dio/dio.dart';
import 'package:irtiqa/app/core/api_client.dart';

class ConsultationProvider {
  Future<Response> getConsultations({int page = 1}) async {
    return await ApiClient.get(
      '/consultations',
      queryParameters: {'page': page},
    );
  }

  Future<Response> createConsultation({
    required int categoryId,
    required String subject,
    required String description,
    required String urgency,
    Map<String, dynamic>? screeningAnswers,
    bool isAnonymous = false,
  }) async {
    return await ApiClient.post(
      '/consultations',
      data: {
        'category_id': categoryId,
        'subject': subject,
        'description': description,
        'urgency': urgency,
        'screening_answers': screeningAnswers,
        'is_anonymous': isAnonymous,
      },
    );
  }

  Future<Response> getConsultationDetails(int id) async {
    return await ApiClient.get('/consultations/$id');
  }

  Future<Response> sendMessage(int consultationId, String content) async {
    return await ApiClient.post(
      '/consultations/$consultationId/messages',
      data: {'content': content},
    );
  }

  Future<Response> getMessages(int consultationId) async {
    return await ApiClient.get('/consultations/$consultationId/messages');
  }

  Future<Response> cancelConsultation(int id, {String? reason}) async {
    return await ApiClient.post(
      '/consultations/$id/cancel',
      data: {'reason': reason},
    );
  }
}
