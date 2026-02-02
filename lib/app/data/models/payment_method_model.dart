class PaymentMethodModel {
  final String paymentMethod;
  final String paymentName;
  final String paymentImage;
  final int totalFee;
  final int paymentFee;

  PaymentMethodModel({
    required this.paymentMethod,
    required this.paymentName,
    required this.paymentImage,
    required this.totalFee,
    required this.paymentFee,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      paymentMethod: json['paymentMethod'] as String,
      paymentName: json['paymentName'] as String,
      paymentImage: json['paymentImage'] as String,
      totalFee: json['totalFee'] as int,
      paymentFee: json['paymentFee'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentMethod': paymentMethod,
      'paymentName': paymentName,
      'paymentImage': paymentImage,
      'totalFee': totalFee,
      'paymentFee': paymentFee,
    };
  }

  String get formattedTotalFee {
    return 'Rp ${totalFee.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }

  String get formattedPaymentFee {
    return 'Rp ${paymentFee.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }

  // Helper getters for common payment methods
  bool get isVirtualAccount => paymentMethod.toUpperCase().contains('VA');
  bool get isEWallet =>
      ['SP', 'OV', 'DA', 'LF', 'SA'].contains(paymentMethod);
  bool get isQRIS => paymentMethod == 'NQ';
  bool get isRetail => ['IR', 'FT'].contains(paymentMethod);
}
