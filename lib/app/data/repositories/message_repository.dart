import 'package:dio/dio.dart';
import '../../core/api_client.dart';
import '../models/message_model.dart';

class MessageRepository {
  /// Get messages untuk consultation
  Future<List<MessageModel>> getConsultationMessages(int consultationId) async {
    try {
      final response = await ApiClient.get(
        '/consultations/$consultationId/messages',
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => MessageModel.fromJson(json)).toList();
      }

      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Send message untuk consultation
  Future<MessageModel?> sendConsultationMessage({
    required int consultationId,
    required String content,
  }) async {
    try {
      final response = await ApiClient.post(
        '/consultations/$consultationId/messages',
        data: {'content': content},
      );

      if (response.statusCode == 201 && response.data['success'] == true) {
        return MessageModel.fromJson(response.data['data']);
      }

      return null;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Get messages untuk program (pembimbingan berbayar)
  Future<List<MessageModel>> getProgramMessages(int programId) async {
    try {
      final response = await ApiClient.get(
        '/programs/$programId/messages',
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => MessageModel.fromJson(json)).toList();
      }

      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Send message untuk program
  Future<MessageModel?> sendProgramMessage({
    required int programId,
    required String content,
  }) async {
    try {
      final response = await ApiClient.post(
        '/programs/$programId/messages',
        data: {'content': content},
      );

      if (response.statusCode == 201 && response.data['success'] == true) {
        return MessageModel.fromJson(response.data['data']);
      }

      return null;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response?.data != null && e.response?.data['message'] != null) {
      return e.response!.data['message'];
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Koneksi timeout. Silakan coba lagi.';
      case DioExceptionType.connectionError:
        return 'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
      default:
        return 'Terjadi kesalahan. Silakan coba lagi.';
    }
  }
}
