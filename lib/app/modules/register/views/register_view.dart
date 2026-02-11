import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/app_colors.dart';
import '../../../core/api_client.dart';
import '../../../routes/app_pages.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: AppColors.background),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: AppColors.textPrimary,
                        size: 24.sp,
                      ),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20.h),

                      Obx(() {
                        final logoPath = controller.appSettings.value?.logo;
                        final logoUrl = logoPath != null && logoPath.isNotEmpty
                            ? ApiClient.getAssetUrl(logoPath)
                            : null;

                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: logoUrl != null && logoUrl.isNotEmpty
                              ? CachedNetworkImage(
                                  key: ValueKey(logoUrl),
                                  imageUrl: logoUrl,
                                  width: 100.w,
                                  height: 100.h,
                                  fit: BoxFit.contain,
                                  placeholder: (context, url) => SizedBox(
                                    width: 100.w,
                                    height: 100.h,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.primary,
                                        strokeWidth: 2.w,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                        'assets/images/logo.png',
                                        width: 100.w,
                                        height: 100.h,
                                      ),
                                )
                              : Image.asset(
                                  key: const ValueKey('fallback_logo'),
                                  'assets/images/logo.png',
                                  width: 100.w,
                                  height: 100.h,
                                ),
                        );
                      }),
                      SizedBox(height: 30.h),

                      Container(
                        padding: EdgeInsets.all(32.w),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(32.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Buat Akun',
                              style: TextStyle(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Daftar untuk memulai',
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: 28.h),

                            TextField(
                              controller: controller.nameController,
                              keyboardType: TextInputType.name,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                labelText: 'Nama Lengkap',
                                labelStyle: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14.sp,
                                ),
                                hintText: 'Masukkan nama lengkap Anda',
                                prefixIcon: Icon(
                                  Iconsax.user,
                                  size: 20.sp,
                                  color: AppColors.primary,
                                ),
                                filled: true,
                                fillColor: AppColors.primary.withValues(
                                  alpha: 0.05,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                  borderSide: BorderSide(
                                    color: AppColors.primary,
                                    width: 1.5.w,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 18.h,
                                ),
                              ),
                            ),
                            SizedBox(height: 14.h),

                            TextField(
                              controller: controller.emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14.sp,
                                ),
                                hintText: 'Masukkan email Anda',
                                prefixIcon: Icon(
                                  Iconsax.sms,
                                  size: 20.sp,
                                  color: AppColors.primary,
                                ),
                                filled: true,
                                fillColor: AppColors.primary.withValues(
                                  alpha: 0.05,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                  borderSide: BorderSide(
                                    color: AppColors.primary,
                                    width: 1.5.w,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 18.h,
                                ),
                              ),
                            ),
                            SizedBox(height: 14.h),

                            TextField(
                              controller: controller.phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: 'Nomor WhatsApp',
                                labelStyle: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14.sp,
                                ),
                                hintText: 'Contoh: 081234567890',
                                prefixIcon: Icon(
                                  Iconsax.call,
                                  size: 20.sp,
                                  color: AppColors.primary,
                                ),
                                filled: true,
                                fillColor: AppColors.primary.withValues(
                                  alpha: 0.05,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                  borderSide: BorderSide(
                                    color: AppColors.primary,
                                    width: 1.5.w,
                                  ),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 18.h,
                                ),
                              ),
                            ),
                            SizedBox(height: 14.h),

                            Obx(
                              () => TextField(
                                controller: controller.passwordController,
                                obscureText:
                                    !controller.isPasswordVisible.value,
                                decoration: InputDecoration(
                                  labelText: 'Kata Sandi',
                                  hintText: 'Buat kata sandi',
                                  prefixIcon: Icon(Iconsax.lock, size: 20.sp),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      controller.isPasswordVisible.value
                                          ? Iconsax.eye
                                          : Iconsax.eye_slash,
                                      size: 20.sp,
                                    ),
                                    onPressed:
                                        controller.togglePasswordVisibility,
                                  ),
                                  filled: true,
                                  fillColor: AppColors.primary.withValues(
                                    alpha: 0.05,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.r),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.r),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.r),
                                    borderSide: BorderSide(
                                      color: AppColors.primary,
                                      width: 1.5.w,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 14.h),

                            Obx(
                              () => TextField(
                                controller:
                                    controller.confirmPasswordController,
                                obscureText:
                                    !controller.isConfirmPasswordVisible.value,
                                decoration: InputDecoration(
                                  labelText: 'Konfirmasi Kata Sandi',
                                  hintText: 'Masukkan ulang kata sandi Anda',
                                  prefixIcon: Icon(Iconsax.lock_1, size: 20.sp),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      controller.isConfirmPasswordVisible.value
                                          ? Iconsax.eye
                                          : Iconsax.eye_slash,
                                      size: 20.sp,
                                    ),
                                    onPressed: controller
                                        .toggleConfirmPasswordVisibility,
                                  ),
                                  filled: true,
                                  fillColor: AppColors.primary.withValues(
                                    alpha: 0.05,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.r),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.r),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.r),
                                    borderSide: BorderSide(
                                      color: AppColors.primary,
                                      width: 1.5.w,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),

                            Obx(
                              () => InkWell(
                                onTap: () => controller.acceptTerms.value =
                                    !controller.acceptTerms.value,
                                borderRadius: BorderRadius.circular(8.r),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.h),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 24.w,
                                        height: 24.h,
                                        child: Checkbox(
                                          value: controller.acceptTerms.value,
                                          onChanged: (value) =>
                                              controller.acceptTerms.value =
                                                  value ?? false,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              4.r,
                                            ),
                                          ),
                                          activeColor: AppColors.primary,
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: RichText(
                                          text: TextSpan(
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              color: AppColors.textSecondary,
                                            ),
                                            children: [
                                              const TextSpan(
                                                text: 'Saya setuju dengan ',
                                              ),
                                              TextSpan(
                                                text: 'Syarat & Ketentuan',
                                                style: TextStyle(
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                recognizer: TapGestureRecognizer()
                                                  ..onTap = () => Get.toNamed(
                                                    Routes.TERMS_AND_CONDITIONS,
                                                  ),
                                              ),
                                              const TextSpan(text: ' dan '),
                                              TextSpan(
                                                text: 'Kebijakan Privasi',
                                                style: TextStyle(
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () =>
                                                          Get.toNamed(
                                                            Routes
                                                                .PRIVACY_POLICY,
                                                          ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 24.h),

                            Obx(
                              () => SizedBox(
                                width: double.infinity,
                                height: 56.h,
                                child: ElevatedButton(
                                  onPressed: controller.isLoading.value
                                      ? null
                                      : controller.register,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    disabledBackgroundColor:
                                        AppColors.textMuted,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.r),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: controller.isLoading.value
                                      ? SizedBox(
                                          width: 24.w,
                                          height: 24.h,
                                          child:
                                              const CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(Colors.white),
                                              ),
                                        )
                                      : Text(
                                          'Daftar',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primaryForeground,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 28.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sudah punya akun? ',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 15.sp,
                            ),
                          ),
                          GestureDetector(
                            onTap: controller.goToLogin,
                            child: Text(
                              'Masuk',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
