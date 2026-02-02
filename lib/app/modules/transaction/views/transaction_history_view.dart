import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../core/app_colors.dart';
import '../controllers/transaction_controller.dart';

class TransactionHistoryView extends GetView<TransactionController> {
  const TransactionHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.transactions.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.transactions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.receipt_minus,
                    size: 64.sp, color: AppColors.textMuted),
                SizedBox(height: 16.h),
                Text(
                  'Belum ada transaksi',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.loadTransactions(refresh: true),
          child: ListView.builder(
            padding: EdgeInsets.all(20.w),
            itemCount: controller.transactions.length + 1,
            itemBuilder: (context, index) {
              if (index == controller.transactions.length) {
                // Load more trigger
                if (controller.hasMorePages.value) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: Center(
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator()
                          : TextButton(
                              onPressed: controller.loadMore,
                              child: const Text('Muat Lebih Banyak'),
                            ),
                    ),
                  );
                }
                return const SizedBox();
              }

              final transaction = controller.transactions[index];
              return _buildTransactionCard(transaction);
            },
          ),
        );
      }),
    );
  }

  Widget _buildTransactionCard(dynamic transaction) {
    Color statusColor;
    IconData statusIcon;

    switch (transaction.status) {
      case 'paid':
        statusColor = Colors.green;
        statusIcon = Iconsax.tick_circle5;
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Iconsax.clock;
        break;
      case 'failed':
      case 'expired':
        statusColor = Colors.red;
        statusIcon = Iconsax.close_circle;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Iconsax.info_circle;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Get.toNamed('/transaction/detail/${transaction.id}');
          },
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Status & Date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(statusIcon, size: 14.sp, color: statusColor),
                          SizedBox(width: 6.w),
                          Text(
                            transaction.statusText,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      DateFormat('dd MMM yyyy').format(transaction.createdAt),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                // Invoice number
                Text(
                  transaction.invoiceNumber,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),

                // Package name
                if (transaction.package != null) ...[
                  SizedBox(height: 6.h),
                  Text(
                    transaction.package!.name,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],

                SizedBox(height: 12.h),

                const Divider(height: 1),

                SizedBox(height: 12.h),

                // Amount & Payment method
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          transaction.isPaymentGateway
                              ? Iconsax.wallet
                              : Iconsax.bank,
                          size: 14.sp,
                          color: AppColors.textMuted,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          transaction.paymentMethodText,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      transaction.formattedTotalAmount,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),

                // Countdown for pending transactions
                if (transaction.isPending && transaction.timeRemaining != null) ...[
                  SizedBox(height: 12.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Iconsax.clock, size: 12.sp, color: Colors.orange),
                        SizedBox(width: 6.w),
                        Text(
                          'Sisa waktu: ${transaction.timeRemainingText}',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.orange.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
