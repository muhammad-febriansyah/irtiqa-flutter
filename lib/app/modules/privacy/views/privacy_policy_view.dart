import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:irtiqa/app/core/app_colors.dart';
import 'package:irtiqa/app/modules/privacy/controllers/privacy_controller.dart';
import 'package:irtiqa/app/routes/app_pages.dart';

class PrivacyPolicyView extends GetView<PrivacyController> {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    final isTerms = Get.currentRoute == Routes.TERMS_AND_CONDITIONS;

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
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: Icon(
                            Iconsax.arrow_left,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          isTerms ? 'Syarat & Ketentuan' : 'Kebijakan Privasi',
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      final policy = isTerms
                          ? controller.termsAndConditions.value
                          : controller.privacyPolicy.value;

                      if (controller.isLoading.value || policy == null) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        );
                      }

                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.all(20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header info
                              Container(
                                padding: EdgeInsets.all(20.w),
                                decoration: BoxDecoration(
                                  color: AppColors.card,
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                    color: AppColors.border,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(12.w),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                      ),
                                      child: Icon(
                                        isTerms
                                            ? Iconsax.document_text
                                            : Iconsax.shield_tick,
                                        color: AppColors.primary,
                                        size: 24.sp,
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            isTerms
                                                ? 'Syarat & Ketentuan'
                                                : 'Kebijakan Privasi',
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          SizedBox(height: 4.h),
                                          Text(
                                            'Versi ${policy.version} • Diperbarui ${policy.lastUpdated}',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              color: AppColors.textMuted,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 24.h),

                              // Sections
                              ...policy.sections.asMap().entries.map((entry) {
                                final section = entry.value;
                                return Container(
                                  margin: EdgeInsets.only(bottom: 16.h),
                                  padding: EdgeInsets.all(20.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.card,
                                    borderRadius: BorderRadius.circular(16.r),
                                    border: Border.all(
                                      color: AppColors.border,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (section.title.isNotEmpty)
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 12.h),
                                          child: Text(
                                            section.title,
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ),
                                      Html(
                                        data: section.content,
                                        style: {
                                          "body": Style(
                                            margin: Margins.zero,
                                            padding: HtmlPaddings.zero,
                                            fontSize: FontSize(14.sp),
                                            color: AppColors.textSecondary,
                                            lineHeight: LineHeight.number(1.6),
                                          ),
                                          "p": Style(
                                            margin: Margins.only(
                                              bottom: 8.h,
                                            ),
                                            fontSize: FontSize(14.sp),
                                            color: AppColors.textSecondary,
                                            lineHeight: LineHeight.number(1.6),
                                          ),
                                          "strong": Style(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                          "b": Style(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                          "h1": Style(
                                            fontSize: FontSize(20.sp),
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                            margin: Margins.only(
                                              bottom: 12.h,
                                            ),
                                          ),
                                          "h2": Style(
                                            fontSize: FontSize(18.sp),
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                            margin: Margins.only(
                                              bottom: 10.h,
                                            ),
                                          ),
                                          "h3": Style(
                                            fontSize: FontSize(16.sp),
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                            margin: Margins.only(
                                              bottom: 8.h,
                                            ),
                                          ),
                                          "ul": Style(
                                            margin: Margins.only(
                                              left: 8.w,
                                              bottom: 8.h,
                                            ),
                                            padding: HtmlPaddings.zero,
                                          ),
                                          "ol": Style(
                                            margin: Margins.only(
                                              left: 8.w,
                                              bottom: 8.h,
                                            ),
                                            padding: HtmlPaddings.zero,
                                          ),
                                          "li": Style(
                                            fontSize: FontSize(14.sp),
                                            color: AppColors.textSecondary,
                                            lineHeight: LineHeight.number(1.5),
                                            margin: Margins.only(
                                              bottom: 4.h,
                                            ),
                                          ),
                                          "a": Style(
                                            color: AppColors.primary,
                                            textDecoration:
                                                TextDecoration.underline,
                                          ),
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }),

                              SizedBox(height: 8.h),

                              // Footer
                              Container(
                                padding: EdgeInsets.all(16.w),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.08,
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.2,
                                    ),
                                    width: 1,
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
                                        'Dengan menggunakan layanan IRTIQA, Anda menyetujui ${isTerms ? "syarat dan ketentuan" : "kebijakan privasi"} ini.',
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          color: AppColors.textPrimary,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 24.h),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
