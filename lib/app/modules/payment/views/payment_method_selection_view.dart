import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/app_colors.dart';
import '../controllers/payment_controller.dart';

class PaymentMethodSelectionView extends GetView<PaymentController> {
  const PaymentMethodSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Pilih Metode Pembayaran'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.paymentMethods.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.paymentMethods.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.wallet_remove,
                    size: 64.sp, color: AppColors.textMuted),
                SizedBox(height: 16.h),
                Text(
                  'Metode pembayaran tidak tersedia',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 24.h),
                ElevatedButton(
                  onPressed: controller.loadPaymentMethods,
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(20.w),
                children: [
                  // Virtual Account
                  if (controller.virtualAccountMethods.isNotEmpty) ...[
                    _buildSectionHeader('Virtual Account'),
                    ...controller.virtualAccountMethods
                        .map((method) => _buildMethodCard(method)),
                    SizedBox(height: 16.h),
                  ],

                  // E-Wallet
                  if (controller.eWalletMethods.isNotEmpty) ...[
                    _buildSectionHeader('E-Wallet'),
                    ...controller.eWalletMethods
                        .map((method) => _buildMethodCard(method)),
                    SizedBox(height: 16.h),
                  ],

                  // QRIS
                  if (controller.qrisMethods.isNotEmpty) ...[
                    _buildSectionHeader('QRIS'),
                    ...controller.qrisMethods
                        .map((method) => _buildMethodCard(method)),
                    SizedBox(height: 16.h),
                  ],

                  // Retail
                  if (controller.retailMethods.isNotEmpty) ...[
                    _buildSectionHeader('Retail / Outlet'),
                    ...controller.retailMethods
                        .map((method) => _buildMethodCard(method)),
                  ],
                ],
              ),
            ),

            // Bottom action
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: AppColors.card,
                border: Border(
                  top: BorderSide(color: AppColors.border, width: 1),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (controller.selectedPaymentMethod.value != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Bayar',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          controller.selectedPaymentMethod.value!
                              .formattedTotalFee,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    if (controller.selectedPaymentMethod.value!.paymentFee > 0) ...[
                      SizedBox(height: 4.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Termasuk biaya ${controller.selectedPaymentMethod.value!.formattedPaymentFee}',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                    SizedBox(height: 16.h),
                  ],
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: controller.selectedPaymentMethod.value == null ||
                              controller.isLoading.value
                          ? null
                          : () async {
                              final success =
                                  await controller.createTransaction();
                              if (success &&
                                  controller.currentTransaction.value != null) {
                                Get.toNamed('/payment/process');
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        disabledBackgroundColor: Colors.grey.shade300,
                      ),
                      child: controller.isLoading.value
                          ? SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              'Bayar Sekarang',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildMethodCard(dynamic method) {
    final isSelected =
        controller.selectedPaymentMethod.value?.paymentMethod ==
            method.paymentMethod;

    return GestureDetector(
      onTap: () => controller.selectPaymentMethod(method),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Logo
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  method.paymentImage,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Iconsax.wallet,
                      color: Colors.grey.shade400,
                      size: 24.sp,
                    );
                  },
                ),
              ),
            ),
            SizedBox(width: 16.w),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.paymentName,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (method.paymentFee > 0) ...[
                    SizedBox(height: 4.h),
                    Text(
                      'Biaya ${method.formattedPaymentFee}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Radio
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? AppColors.primary : Colors.grey.shade400,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }
}
