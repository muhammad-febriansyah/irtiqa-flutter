import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/app_colors.dart';
import '../../../data/models/package_model.dart';
import '../controllers/payment_controller.dart';

class PaymentCheckoutView extends GetView<PaymentController> {
  const PaymentCheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get package from arguments
    final PackageModel? package = Get.arguments?['package'];
    final int? consultationId = Get.arguments?['consultation_id'];
    final int? ticketId = Get.arguments?['ticket_id'];

    if (package != null) {
      controller.setPackage(package);
      controller.setConsultationContext(
        consultId: consultationId,
        ticketIdValue: ticketId,
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.selectedPackage.value == null) {
          return const Center(
            child: Text('Paket tidak ditemukan'),
          );
        }

        final pkg = controller.selectedPackage.value!;

        return ListView(
          padding: EdgeInsets.all(20.w),
          children: [
            // Package summary card
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
                    'Paket yang Dipilih',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    pkg.name,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (pkg.sessionsCount != null || pkg.durationDays != null) ...[
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        if (pkg.sessionsCount != null) ...[
                          Icon(Iconsax.calendar,
                              size: 14.sp, color: AppColors.textSecondary),
                          SizedBox(width: 6.w),
                          Text(
                            pkg.sessionsText,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                        if (pkg.sessionsCount != null && pkg.durationDays != null)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Text('•',
                                style: TextStyle(color: AppColors.textSecondary)),
                          ),
                        if (pkg.durationDays != null) ...[
                          Icon(Iconsax.clock,
                              size: 14.sp, color: AppColors.textSecondary),
                          SizedBox(width: 6.w),
                          Text(
                            pkg.durationText,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                  SizedBox(height: 16.h),
                  const Divider(),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Harga Paket',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        pkg.formattedPrice,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Biaya Admin',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        'Rp 0',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Pembayaran',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          pkg.formattedPrice,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Payment method selection
            Text(
              'Pilih Metode Pembayaran',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),

            // Payment Gateway (Duitku)
            _buildPaymentTypeCard(
              icon: Iconsax.wallet_2,
              title: 'Payment Gateway',
              subtitle: 'VA, E-Wallet, QRIS, dll',
              value: 'duitku',
              isSelected: controller.selectedPaymentType.value == 'duitku',
              onTap: () => controller.selectPaymentType('duitku'),
            ),

            SizedBox(height: 12.h),

            // Manual Transfer
            _buildPaymentTypeCard(
              icon: Iconsax.bank,
              title: 'Transfer Manual',
              subtitle: 'Transfer ke rekening IRTIQA',
              value: 'manual_transfer',
              isSelected: controller.selectedPaymentType.value == 'manual_transfer',
              onTap: () => controller.selectPaymentType('manual_transfer'),
            ),

            SizedBox(height: 32.h),

            // Continue button
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () {
                        if (controller.selectedPaymentType.value == 'duitku') {
                          // Load payment methods and go to selection
                          controller.loadPaymentMethods().then((_) {
                            if (controller.paymentMethods.isNotEmpty) {
                              Get.toNamed('/payment/method-selection');
                            }
                          });
                        } else {
                          // Go to manual transfer
                          Get.toNamed('/payment/manual-transfer');
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: controller.isLoading.value
                    ? SizedBox(
                        height: 20.h,
                        width: 20.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'Lanjutkan',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildPaymentTypeCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: (isSelected ? AppColors.primary : Colors.grey.shade400)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.primary : Colors.grey.shade600,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
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
