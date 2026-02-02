import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:irtiqa/app/core/app_colors.dart';
import 'package:irtiqa/app/modules/privacy/controllers/privacy_controller.dart';

class DataManagementView extends GetView<PrivacyController> {
  const DataManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text(
          'Kelola Data Saya',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Export data card
            _buildActionCard(
              icon: Iconsax.document_download5,
              title: 'Unduh Data Saya',
              description: 'Dapatkan salinan lengkap data pribadi Anda',
              color: AppColors.info,
              onTap: () => _showExportConfirmation(context),
            ),

            SizedBox(height: 16.h),

            // Delete account card
            _buildActionCard(
              icon: Iconsax.trash5,
              title: 'Hapus Akun',
              description: 'Hapus akun dan semua data Anda secara permanen',
              color: AppColors.error,
              onTap: () => _showDeleteConfirmation(context),
            ),

            SizedBox(height: 24.h),

            // Data retention info
            Obx(() {
              final info = controller.dataRetentionInfo;
              if (info.isEmpty) return SizedBox.shrink();

              return Container(
                padding: EdgeInsets.all(18.w),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: AppColors.warning.withValues(alpha: 0.15),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Iconsax.info_circle5,
                          color: AppColors.warning,
                          size: 20.sp,
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          'Informasi Penyimpanan Data',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      '• Data konsultasi disimpan selama ${info['consultation_retention_days'] ?? 365} hari\n'
                      '• Data jurnal disimpan selama ${info['journal_retention_days'] ?? 730} hari\n'
                      '• Data akun yang dihapus akan dianonimkan, bukan dihapus permanen',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, size: 24.sp, color: color),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Iconsax.arrow_right_3, size: 20.sp, color: color),
          ],
        ),
      ),
    );
  }

  void _showExportConfirmation(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(Iconsax.document_download, color: AppColors.info, size: 24.sp),
            SizedBox(width: 12.w),
            Text(
              'Unduh Data',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          'Kami akan mengirimkan link unduhan ke email Anda. Proses ini mungkin memakan waktu beberapa menit.',
          style: TextStyle(fontSize: 14.sp, height: 1.5),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Batal')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.exportMyData();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.info),
            child: Text('Lanjutkan'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    final passwordController = TextEditingController();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Row(
          children: [
            Icon(Iconsax.danger, color: AppColors.error, size: 24.sp),
            SizedBox(width: 12.w),
            Text(
              'Hapus Akun',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                '⚠️ Tindakan ini tidak dapat dibatalkan. Data Anda akan dianonimkan dan tidak dapat dipulihkan.',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.error,
                  height: 1.4,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Masukkan password untuk konfirmasi:',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (passwordController.text.isEmpty) {
                Get.snackbar(
                  'Perhatian',
                  'Silakan masukkan password',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }
              Get.back();
              controller.deleteAccount(passwordController.text);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text('Hapus Akun'),
          ),
        ],
      ),
    );
  }
}
