import 'dart:io';
import 'package:dio/dio.dart';
import 'package:irtiqa/app/core/api_client.dart';

class PaymentProvider {
  /// Get available payment methods from Duitku
  Future<Map<String, dynamic>> getPaymentMethods({int amount = 10000}) async {
    try {
      final response = await ApiClient.get(
        '/payment/methods',
        queryParameters: {'amount': amount},
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  /// Create new transaction
  Future<Map<String, dynamic>> createTransaction({
    required int packageId,
    required String paymentMethod,
    int? consultationId,
    int? ticketId,
    String? paymentChannel,
  }) async {
    try {
      final response = await ApiClient.post(
        '/transactions',
        data: {
          'package_id': packageId,
          'payment_method': paymentMethod,
          if (consultationId != null) 'consultation_id': consultationId,
          if (ticketId != null) 'ticket_id': ticketId,
          if (paymentChannel != null) 'payment_channel': paymentChannel,
        },
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  /// Get transaction list
  Future<Map<String, dynamic>> getTransactions({int page = 1}) async {
    try {
      final response = await ApiClient.get(
        '/transactions',
        queryParameters: {'page': page},
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  /// Get transaction detail
  Future<Map<String, dynamic>> getTransactionDetail(int id) async {
    try {
      final response = await ApiClient.get('/transactions/$id');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  /// Check transaction status
  Future<Map<String, dynamic>> checkTransactionStatus(int id) async {
    try {
      final response = await ApiClient.get('/transactions/$id/status');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  /// Upload payment proof (for manual transfer)
  Future<Map<String, dynamic>> uploadPaymentProof(
    int transactionId,
    String filePath,
  ) async {
    try {
      final file = File(filePath);
      final fileName = file.path.split('/').last;

      final formData = FormData.fromMap({
        'payment_proof': await MultipartFile.fromFile(
          filePath,
          filename: fileName,
        ),
      });

      final response = await ApiClient.post(
        '/transactions/$transactionId/upload-proof',
        data: formData,
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  /// Cancel transaction
  Future<Map<String, dynamic>> cancelTransaction(
    int transactionId, {
    String? reason,
  }) async {
    try {
      final response = await ApiClient.post(
        '/transactions/$transactionId/cancel',
        data: {
          if (reason != null) 'reason': reason,
        },
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }
}
