import 'package:irtiqa/app/data/models/payment_method_model.dart';
import 'package:irtiqa/app/data/models/transaction_model.dart';
import 'package:irtiqa/app/data/providers/payment_provider.dart';

class PaymentRepository {
  final PaymentProvider _provider = PaymentProvider();

  Future<List<PaymentMethodModel>> getPaymentMethods({
    required int amount,
  }) async {
    try {
      final response = await _provider.getPaymentMethods(amount: amount);

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> data = response['data'];
        return data
            .map((json) => PaymentMethodModel.fromJson(json))
            .toList();
      }

      throw Exception('Failed to load payment methods');
    } catch (e) {
      rethrow;
    }
  }

  Future<TransactionModel> createTransaction({
    required int packageId,
    required String paymentMethod,
    int? consultationId,
    int? ticketId,
    String? paymentChannel,
  }) async {
    try {
      final response = await _provider.createTransaction(
        packageId: packageId,
        paymentMethod: paymentMethod,
        consultationId: consultationId,
        ticketId: ticketId,
        paymentChannel: paymentChannel,
      );

      if (response['success'] == true && response['data'] != null) {
        return TransactionModel.fromJson(response['data']);
      }

      throw Exception(response['message'] ?? 'Failed to create transaction');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TransactionModel>> getTransactions({int page = 1}) async {
    try {
      final response = await _provider.getTransactions(page: page);

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> data = response['data'];
        return data.map((json) => TransactionModel.fromJson(json)).toList();
      }

      throw Exception('Failed to load transactions');
    } catch (e) {
      rethrow;
    }
  }

  Future<TransactionModel> getTransactionDetail(int id) async {
    try {
      final response = await _provider.getTransactionDetail(id);

      if (response['success'] == true && response['data'] != null) {
        return TransactionModel.fromJson(response['data']);
      }

      throw Exception('Failed to load transaction detail');
    } catch (e) {
      rethrow;
    }
  }

  Future<TransactionModel> checkTransactionStatus(int id) async {
    try {
      final response = await _provider.checkTransactionStatus(id);

      if (response['success'] == true && response['data'] != null) {
        return TransactionModel.fromJson(response['data']);
      }

      throw Exception('Failed to check transaction status');
    } catch (e) {
      rethrow;
    }
  }

  Future<TransactionModel> uploadPaymentProof(
    int transactionId,
    String filePath,
  ) async {
    try {
      final response = await _provider.uploadPaymentProof(
        transactionId,
        filePath,
      );

      if (response['success'] == true && response['data'] != null) {
        return TransactionModel.fromJson(response['data']);
      }

      throw Exception(
          response['message'] ?? 'Failed to upload payment proof');
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> cancelTransaction(int transactionId, {String? reason}) async {
    try {
      final response = await _provider.cancelTransaction(
        transactionId,
        reason: reason,
      );

      return response['success'] == true;
    } catch (e) {
      rethrow;
    }
  }
}
