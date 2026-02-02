import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/app_colors.dart';

class DreamEducationGateView extends StatefulWidget {
  const DreamEducationGateView({super.key});

  @override
  State<DreamEducationGateView> createState() => _DreamEducationGateViewState();
}

class _DreamEducationGateViewState extends State<DreamEducationGateView> {
  bool _hasAcceptedEducation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: [
            Container(
              height: 200.h,
              decoration: BoxDecoration(
                color: AppColors.primary,
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => Get.back(),
                              icon: Icon(
                                Iconsax.arrow_left,
                                color: Colors.white,
                                size: 24.sp,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              'Tentang Mimpi',
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Container(
                          padding: EdgeInsets.all(24.w),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: AppColors.border, width: 1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Icon
                              Center(
                                child: Container(
                                  padding: EdgeInsets.all(20.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Iconsax.moon5,
                                    size: 48.sp,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),

                              SizedBox(height: 24.h),

                              // Title
                              Text(
                                'Memahami Mimpi dengan Bijak',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                                textAlign: TextAlign.center,
                              ),

                              SizedBox(height: 16.h),

                              // Education content
                              Container(
                                padding: EdgeInsets.all(18.w),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: AppColors.primary.withValues(alpha: 0.15),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildEducationPoint(
                                      'Mimpi bisa berasal dari banyak hal',
                                      'Tidak semua mimpi memiliki makna khusus atau perlu ditafsirkan.',
                                    ),
                                    SizedBox(height: 14.h),
                                    _buildEducationPoint(
                                      'Hindari tafsir berlebihan',
                                      'Menafsirkan mimpi secara berlebihan dapat menimbulkan sugesti yang tidak sehat.',
                                    ),
                                    SizedBox(height: 14.h),
                                    _buildEducationPoint(
                                      'Fokus pada ibadah & stabilitas mental',
                                      'Jaga keseimbangan ibadah dan kesehatan mental Anda.',
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 24.h),

                              // Important note
                              Container(
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: Colors.amber.withValues(alpha: 0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Iconsax.info_circle5,
                                      size: 20.sp,
                                      color: Colors.amber.shade700,
                                    ),
                                    SizedBox(width: 12.w),
                                    Expanded(
                                      child: Text(
                                        'Jika mimpi membuat gelisah, sebaiknya diabaikan dan ditutup dengan doa.',
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          color: Colors.amber.shade900,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 24.h),

                              // Checkbox
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _hasAcceptedEducation =
                                        !_hasAcceptedEducation;
                                  });
                                },
                                borderRadius: BorderRadius.circular(8.r),
                                child: Container(
                                  padding: EdgeInsets.all(14.w),
                                  decoration: BoxDecoration(
                                    color: _hasAcceptedEducation
                                        ? AppColors.primary.withValues(alpha: 0.05)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(
                                      color: _hasAcceptedEducation
                                          ? AppColors.primary
                                          : AppColors.border,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 22.w,
                                        height: 22.h,
                                        decoration: BoxDecoration(
                                          color: _hasAcceptedEducation
                                              ? AppColors.primary
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            4.r,
                                          ),
                                          border: Border.all(
                                            color: _hasAcceptedEducation
                                                ? AppColors.primary
                                                : AppColors.border,
                                            width: 2,
                                          ),
                                        ),
                                        child: _hasAcceptedEducation
                                            ? Icon(
                                                Icons.check,
                                                size: 16.sp,
                                                color: Colors.white,
                                              )
                                            : null,
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Text(
                                          'Saya memahami mimpi tidak selalu perlu ditafsirkan',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: AppColors.textPrimary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: 24.h),

                              // Continue button
                              SizedBox(
                                width: double.infinity,
                                height: 52.h,
                                child: ElevatedButton(
                                  onPressed: _hasAcceptedEducation
                                      ? () {
                                          Get.back();
                                          Get.toNamed('/dream/create');
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.r),
                                    ),
                                    disabledBackgroundColor: AppColors.border
                                        .withValues(alpha: 0.3),
                                  ),
                                  child: Text(
                                    'Lanjutkan',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: _hasAcceptedEducation
                                          ? Colors.white
                                          : AppColors.textMuted,
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: 16.h),

                              // Learn more button
                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    // Navigate to education about dreams
                                    Get.snackbar(
                                      'Info',
                                      'Artikel tentang mimpi akan ditampilkan',
                                      backgroundColor: AppColors.primary
                                          .withValues(alpha: 0.1),
                                      colorText: AppColors.primary,
                                      snackPosition: SnackPosition.BOTTOM,
                                      margin: EdgeInsets.all(16.w),
                                      borderRadius: 12.r,
                                    );
                                  },
                                  child: Text(
                                    'Pelajari Sikap Terhadap Mimpi',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationPoint(String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 2.h),
          width: 6.w,
          height: 6.h,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
