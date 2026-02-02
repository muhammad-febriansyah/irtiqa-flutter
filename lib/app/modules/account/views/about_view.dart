import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/api_client.dart';
import '../../../core/app_colors.dart';
import '../controllers/about_us_controller.dart';

class AboutView extends GetView<AboutUsController> {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AboutUsController>()) {
      Get.put(AboutUsController());
    }

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
                          'Tentang Kami',
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
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final data = controller.aboutUs.value;
                      if (data == null) {
                        return const Center(child: Text('Gagal memuat data'));
                      }

                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: EdgeInsets.all(20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                padding: EdgeInsets.all(24.w),
                                decoration: BoxDecoration(
                                  color: AppColors.card,
                                  borderRadius: BorderRadius.circular(24.r),
                                  border: Border.all(
                                    color: AppColors.border,
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    if (data.image != null)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          16.r,
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: ApiClient.getAssetUrl(
                                            data.image,
                                          ),
                                          height: 120.h,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Container(
                                                color: AppColors.background,
                                                child: const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                                color: AppColors.background,
                                                child: const Icon(
                                                  Iconsax.image,
                                                ),
                                              ),
                                        ),
                                      )
                                    else
                                      Container(
                                        width: 80.w,
                                        height: 80.h,
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withValues(
                                            alpha: 0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            20.r,
                                          ),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Iconsax.heart5,
                                            size: 40.sp,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      data.title ?? 'IRTIQA',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 22.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'Platform Pendampingan Psiko-Spiritual',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 24.h),
                              Text(
                                'Deskripsi',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 12.h),
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
                                child: MarkdownBody(
                                  data: _convertHtmlToMarkdown(data.desc ?? ''),
                                  styleSheet: MarkdownStyleSheet(
                                    p: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.textSecondary,
                                      height: 1.6,
                                    ),
                                    strong: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    h3: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                      height: 2,
                                    ),
                                    listBullet: TextStyle(
                                      fontSize: 14.sp,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 32.h),
                              Column(
                                children: [
                                  Text(
                                    'Dibuat dengan ❤️ oleh IRTIQA Team',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    '© 2026 IRTIQA. All rights reserved.',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
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

  String _convertHtmlToMarkdown(String html) {
    // Simple conversion for basic tags used in the seeder
    return html
        .replaceAll('</p>', '\n\n')
        .replaceAll('<p>', '')
        .replaceAll('<strong>', '**')
        .replaceAll('</strong>', '**')
        .replaceAll('<h3>', '### ')
        .replaceAll('</h3>', '\n')
        .replaceAll('<ul>', '')
        .replaceAll('</ul>', '')
        .replaceAll('<li>', '- ')
        .replaceAll('</li>', '\n')
        .replaceAll('<br>', '\n')
        .replaceAll('&nbsp;', ' ')
        .trim();
  }
}
