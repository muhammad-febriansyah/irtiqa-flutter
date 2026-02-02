import 'package:irtiqa/app/data/models/package_model.dart';

class TransactionModel {
  final int id;
  final String invoiceNumber;
  final int userId;
  final PackageModel? package;
  final double amount;
  final double adminFee;
  final double totalAmount;
  final String paymentMethod;
  final String status;
  final String? duitkuReference;
  final String? duitkuPaymentUrl;
  final String? duitkuVaNumber;
  final String? duitkuQrString;
  final String? transferProofUrl;
  final DateTime? paidAt;
  final DateTime? expiredAt;
  final String? escrowStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  TransactionModel({
    required this.id,
    required this.invoiceNumber,
    required this.userId,
    this.package,
    required this.amount,
    required this.adminFee,
    required this.totalAmount,
    required this.paymentMethod,
    required this.status,
    this.duitkuReference,
    this.duitkuPaymentUrl,
    this.duitkuVaNumber,
    this.duitkuQrString,
    this.transferProofUrl,
    this.paidAt,
    this.expiredAt,
    this.escrowStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as int,
      invoiceNumber: json['invoice_number'] as String,
      userId: json['user_id'] as int,
      package: json['package'] != null
          ? PackageModel.fromJson(json['package'] as Map<String, dynamic>)
          : null,
      amount: double.parse(json['amount'].toString()),
      adminFee: double.parse(json['admin_fee'].toString()),
      totalAmount: double.parse(json['total_amount'].toString()),
      paymentMethod: json['payment_method'] as String,
      status: json['status'] as String,
      duitkuReference: json['duitku_reference'] as String?,
      duitkuPaymentUrl: json['duitku_payment_url'] as String?,
      duitkuVaNumber: json['duitku_va_number'] as String?,
      duitkuQrString: json['duitku_qr_string'] as String?,
      transferProofUrl: json['transfer_proof_url'] as String?,
      paidAt: json['paid_at'] != null
          ? DateTime.parse(json['paid_at'] as String)
          : null,
      expiredAt: json['expired_at'] != null
          ? DateTime.parse(json['expired_at'] as String)
          : null,
      escrowStatus: json['escrow_status'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoice_number': invoiceNumber,
      'user_id': userId,
      'package': package?.toJson(),
      'amount': amount,
      'admin_fee': adminFee,
      'total_amount': totalAmount,
      'payment_method': paymentMethod,
      'status': status,
      'duitku_reference': duitkuReference,
      'duitku_payment_url': duitkuPaymentUrl,
      'duitku_va_number': duitkuVaNumber,
      'duitku_qr_string': duitkuQrString,
      'transfer_proof_url': transferProofUrl,
      'paid_at': paidAt?.toIso8601String(),
      'expired_at': expiredAt?.toIso8601String(),
      'escrow_status': escrowStatus,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  bool get isPending => status == 'pending';
  bool get isPaid => status == 'paid';
  bool get isFailed => status == 'failed';
  bool get isExpired => status == 'expired';

  bool get isPaymentGateway => paymentMethod == 'payment_gateway';
  bool get isManualTransfer => paymentMethod == 'manual_transfer';

  String get statusText {
    switch (status) {
      case 'pending':
        return 'Menunggu Pembayaran';
      case 'paid':
        return 'Lunas';
      case 'failed':
        return 'Gagal';
      case 'expired':
        return 'Kadaluarsa';
      default:
        return status;
    }
  }

  String get paymentMethodText {
    switch (paymentMethod) {
      case 'payment_gateway':
        return 'Payment Gateway';
      case 'manual_transfer':
        return 'Transfer Manual';
      default:
        return paymentMethod;
    }
  }

  String get formattedTotalAmount {
    return 'Rp ${totalAmount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }

  bool get isExpiredByTime {
    if (expiredAt == null) return false;
    return DateTime.now().isAfter(expiredAt!);
  }

  Duration? get timeRemaining {
    if (expiredAt == null || !isPending) return null;
    final now = DateTime.now();
    if (now.isAfter(expiredAt!)) return null;
    return expiredAt!.difference(now);
  }

  String? get timeRemainingText {
    final remaining = timeRemaining;
    if (remaining == null) return null;

    final hours = remaining.inHours;
    final minutes = remaining.inMinutes.remainder(60);

    if (hours > 0) {
      return '$hours jam $minutes menit';
    } else {
      return '$minutes menit';
    }
  }
}
