import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../core/app_colors.dart';
import '../controllers/payment_controller.dart';

class PaymentProcessView extends GetView<PaymentController> {
  const PaymentProcessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final transaction = controller.currentTransaction.value;

      if (transaction == null) {
        return Scaffold(
          appBar: AppBar(title: const Text('Proses Pembayaran')),
          body: const Center(child: Text('Transaksi tidak ditemukan')),
        );
      }

      // If payment gateway, show WebView
      if (transaction.isPaymentGateway && transaction.duitkuPaymentUrl != null) {
        return _buildWebViewPayment(transaction.duitkuPaymentUrl!);
      }

      // Show payment instructions (VA, QRIS, etc.)
      return _buildPaymentInstructions(transaction);
    });
  }

  Widget _buildWebViewPayment(String paymentUrl) {
    final webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            // Check if payment is completed
            if (url.contains('success') || url.contains('return')) {
              controller.checkPaymentStatus().then((_) {
                if (controller.currentTransaction.value?.isPaid == true) {
                  Get.offAllNamed('/payment/success');
                }
              });
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(paymentUrl));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: WebViewWidget(controller: webViewController),
    );
  }

  Widget _buildPaymentInstructions(dynamic transaction) {
    Timer? statusCheckTimer;

    // Auto-check payment status every 10 seconds
    statusCheckTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) {
        controller.checkPaymentStatus().then((_) {
          if (controller.currentTransaction.value?.isPaid == true) {
            statusCheckTimer?.cancel();
            Get.offAllNamed('/payment/success');
          }
        });
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Instruksi Pembayaran'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(20.w),
        children: [
          // Timer countdown
          if (transaction.timeRemaining != null)
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Iconsax.clock, color: Colors.orange, size: 20.sp),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selesaikan pembayaran dalam',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.orange.shade700,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          transaction.timeRemainingText ?? '',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          SizedBox(height: 20.h),

          // Transaction info card
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Detail Pembayaran',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 16.h),

                // Invoice number
                _buildInfoRow('No. Invoice', transaction.invoiceNumber),

                // Virtual Account number (if available)
                if (transaction.duitkuVaNumber != null) ...[
                  SizedBox(height: 12.h),
                  _buildCopyableRow(
                    'No. Virtual Account',
                    transaction.duitkuVaNumber!,
                  ),
                ],

                SizedBox(height: 12.h),
                _buildInfoRow(
                  'Total Pembayaran',
                  transaction.formattedTotalAmount,
                  valueStyle: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // Payment instructions
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cara Pembayaran',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 12.h),
                _buildInstructionStep(
                  1,
                  'Buka aplikasi mobile banking atau m-banking Anda',
                ),
                _buildInstructionStep(
                  2,
                  'Pilih menu Transfer atau Bayar',
                ),
                _buildInstructionStep(
                  3,
                  'Masukkan nomor Virtual Account yang tertera di atas',
                ),
                _buildInstructionStep(
                  4,
                  'Periksa detail pembayaran dan konfirmasi',
                ),
                _buildInstructionStep(
                  5,
                  'Pembayaran akan diverifikasi otomatis',
                ),
              ],
            ),
          ),

          SizedBox(height: 24.h),

          // Check status button
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: OutlinedButton.icon(
              onPressed: () {
                controller.checkPaymentStatus().then((_) {
                  if (controller.currentTransaction.value?.isPaid == true) {
                    statusCheckTimer?.cancel();
                    Get.offAllNamed('/payment/success');
                  } else {
                    Get.snackbar(
                      'Info',
                      'Pembayaran belum diterima. Silakan coba lagi dalam beberapa saat.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                });
              },
              icon: const Icon(Iconsax.refresh),
              label: const Text('Cek Status Pembayaran'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {TextStyle? valueStyle}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: valueStyle ??
              TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
        ),
      ],
    );
  }

  Widget _buildCopyableRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.textSecondary,
          ),
        ),
        Row(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                letterSpacing: 1,
              ),
            ),
            SizedBox(width: 8.w),
            InkWell(
              onTap: () {
                // Copy to clipboard
                Get.snackbar(
                  'Tersalin',
                  'Nomor berhasil disalin',
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 2),
                );
              },
              child: Icon(
                Iconsax.copy,
                size: 18.sp,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInstructionStep(int number, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
