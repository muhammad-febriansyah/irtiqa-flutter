import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/app_colors.dart';
import '../../../data/models/package_model.dart';
import '../controllers/package_controller.dart';

class PackageListView extends GetView<PackageController> {
  const PackageListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Pilih Paket Pembimbingan'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.packages.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty &&
            controller.packages.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.close_circle, size: 64.sp, color: Colors.red),
                SizedBox(height: 16.h),
                Text(
                  'Gagal memuat paket',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
                SizedBox(height: 24.h),
                ElevatedButton(
                  onPressed: controller.loadPackages,
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }

        if (controller.packages.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.box, size: 64.sp, color: AppColors.textMuted),
                SizedBox(height: 16.h),
                Text(
                  'Belum ada paket tersedia',
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
          onRefresh: controller.loadPackages,
          child: ListView(
            padding: EdgeInsets.all(20.w),
            children: [
              // Info message
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Iconsax.info_circle,
                      color: AppColors.primary,
                      size: 20.sp,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        'Pilih paket yang sesuai dengan kebutuhan pendampingan Anda',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // Featured packages
              if (controller.featuredPackages.isNotEmpty) ...[
                Text(
                  'Paket Unggulan',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 12.h),
                ...controller.featuredPackages.map(
                  (package) => _buildPackageCard(package, isFeatured: true),
                ),
                SizedBox(height: 20.h),
              ],

              // Regular packages
              if (controller.regularPackages.isNotEmpty) ...[
                Text(
                  controller.featuredPackages.isNotEmpty
                      ? 'Paket Lainnya'
                      : 'Paket Tersedia',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 12.h),
                ...controller.regularPackages.map(_buildPackageCard),
              ],
            ],
          ),
        );
      }),
    );
  }

  Widget _buildPackageCard(PackageModel package, {bool isFeatured = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16.r),
        border: isFeatured
            ? Border.all(color: AppColors.primary, width: 2)
            : Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          if (isFeatured)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14.r),
                  topRight: Radius.circular(14.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.star1, color: Colors.white, size: 16.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'PAKET UNGGULAN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),

          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title & Price
                Text(
                  package.name,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  package.formattedPrice,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),

                // Sessions & Duration
                if (package.sessionsCount != null ||
                    package.durationDays != null) ...[
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      if (package.sessionsCount != null) ...[
                        Icon(Iconsax.calendar,
                            size: 16.sp, color: AppColors.textSecondary),
                        SizedBox(width: 6.w),
                        Text(
                          package.sessionsText,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                      if (package.sessionsCount != null &&
                          package.durationDays != null)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: Text('•',
                              style:
                                  TextStyle(color: AppColors.textSecondary)),
                        ),
                      if (package.durationDays != null) ...[
                        Icon(Iconsax.clock,
                            size: 16.sp, color: AppColors.textSecondary),
                        SizedBox(width: 6.w),
                        Text(
                          package.durationText,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],

                // Description
                SizedBox(height: 12.h),
                Text(
                  package.description,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),

                // Features
                if (package.features != null && package.features!.isNotEmpty) ...[
                  SizedBox(height: 16.h),
                  ...package.features!.map(
                    (feature) => Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Iconsax.tick_circle5,
                            size: 18.sp,
                            color: Colors.green,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              feature,
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                // Voice call info
                if (package.includesVoiceCall) ...[
                  SizedBox(height: 12.h),
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Iconsax.call,
                            color: Colors.green, size: 16.sp),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            package.voiceCallCount != null
                                ? 'Termasuk ${package.voiceCallCount}x panggilan suara'
                                : 'Termasuk panggilan suara',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Action button
                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/payment/checkout',
                          arguments: {'package': package});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFeatured
                          ? AppColors.primary
                          : AppColors.primary.withValues(alpha: 0.9),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Pilih Paket Ini',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
