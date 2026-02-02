import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../core/app_colors.dart';
import '../controllers/payment_controller.dart';

class PaymentManualTransferView extends GetView<PaymentController> {
  const PaymentManualTransferView({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedImage = Rx<File?>(null);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Transfer Manual'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(20.w),
              children: [
                // Info alert
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Iconsax.info_circle, color: Colors.blue, size: 20.sp),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          'Silakan transfer ke rekening di bawah ini, lalu upload bukti transfer Anda.',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.h),

                // Bank account info
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
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Icon(
                              Iconsax.bank,
                              color: AppColors.primary,
                              size: 24.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'Bank BCA',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      _buildCopyableInfo(
                        'No. Rekening',
                        '1234567890',
                      ),
                      SizedBox(height: 12.h),
                      _buildCopyableInfo(
                        'Atas Nama',
                        'PT IRTIQA SOLUTION',
                      ),
                      SizedBox(height: 12.h),
                      Obx(() {
                        final package = controller.selectedPackage.value;
                        return _buildCopyableInfo(
                          'Jumlah Transfer',
                          package?.formattedPrice ?? 'Rp 0',
                        );
                      }),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // Upload section
                Text(
                  'Upload Bukti Transfer',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 12.h),

                Obx(() {
                  if (selectedImage.value == null) {
                    return _buildUploadButton(() async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 80,
                      );
                      if (image != null) {
                        selectedImage.value = File(image.path);
                      }
                    });
                  } else {
                    return _buildImagePreview(
                      selectedImage.value!,
                      () => selectedImage.value = null,
                    );
                  }
                }),

                SizedBox(height: 16.h),

                // Instructions
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.yellow.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Iconsax.warning_2, color: Colors.orange, size: 18.sp),
                          SizedBox(width: 8.w),
                          Text(
                            'Perhatian',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade900,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '• Pastikan nominal transfer sesuai\n'
                        '• Upload bukti yang jelas dan dapat dibaca\n'
                        '• Verifikasi akan dilakukan maksimal 1x24 jam',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.orange.shade900,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
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
            child: Obx(() {
              return SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: selectedImage.value == null ||
                          controller.isLoading.value
                      ? null
                      : () async {
                          // Create transaction first
                          final created = await controller.createTransaction();
                          if (created && selectedImage.value != null) {
                            // Upload proof
                            final uploaded = await controller.uploadPaymentProof(
                              selectedImage.value!.path,
                            );
                            if (uploaded) {
                              Get.snackbar(
                                'Berhasil',
                                'Bukti transfer berhasil diupload. Kami akan memverifikasi dalam 1x24 jam.',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              Get.offAllNamed('/bottomnavigator');
                            }
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
                          'Upload & Konfirmasi',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCopyableInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.textMuted,
          ),
        ),
        SizedBox(height: 6.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Get.snackbar(
                  'Tersalin',
                  '$label berhasil disalin',
                  snackPosition: SnackPosition.BOTTOM,
                  duration: const Duration(seconds: 2),
                );
              },
              child: Container(
                padding: EdgeInsets.all(8.w),
                child: Icon(
                  Iconsax.copy,
                  size: 18.sp,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUploadButton(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200.h,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColors.border,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.gallery_add,
              size: 48.sp,
              color: AppColors.primary,
            ),
            SizedBox(height: 12.h),
            Text(
              'Pilih Gambar',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Format: JPG, PNG (Max 5MB)',
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(File image, VoidCallback onRemove) {
    return Container(
      height: 200.h,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Image.file(
              image,
              width: double.infinity,
              height: 200.h,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 8.h,
            right: 8.w,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Iconsax.trash,
                  size: 18.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
