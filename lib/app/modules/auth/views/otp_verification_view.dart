import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pinput/pinput.dart';
import '../../../core/app_colors.dart';
import '../controllers/otp_verification_controller.dart';

class OtpVerificationView extends GetView<OtpVerificationController> {
  const OtpVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Back button
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Iconsax.arrow_left,
                      size: 24.sp,
                      color: AppColors.textPrimary,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                ),

                SizedBox(height: 24.h),

                // Icon
                Center(
                  child: Container(
                    width: 80.w,
                    height: 80.h,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Iconsax.sms,
                      size: 40.sp,
                      color: AppColors.primary,
                    ),
                  ),
                ),

                SizedBox(height: 32.h),

                // Title
                Text(
                  'Verifikasi OTP',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 12.h),

                // Subtitle
                Obx(
                  () => Text(
                    'Kode OTP telah dikirim ke\n${controller.email.value}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(height: 40.h),

                // PIN Input
                Obx(
                  () => Pinput(
                    length: 6,
                    controller: controller.otpController,
                    onCompleted: (pin) => controller.verifyOtp(),
                    defaultPinTheme: _defaultPinTheme(),
                    focusedPinTheme: _focusedPinTheme(),
                    submittedPinTheme: _submittedPinTheme(),
                    errorPinTheme: _errorPinTheme(),
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    showCursor: true,
                    enabled: !controller.isLoading.value,
                  ),
                ),

                SizedBox(height: 24.h),

                // Error message
                Obx(() {
                  if (controller.errorMessage.value.isEmpty) {
                    return SizedBox.shrink();
                  }
                  return Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: Colors.red.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Iconsax.info_circle,
                          size: 18.sp,
                          color: Colors.red,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            controller.errorMessage.value,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                SizedBox(height: 32.h),

                // Resend OTP
                Obx(() {
                  if (controller.canResend.value) {
                    return Column(
                      children: [
                        Text(
                          'Belum menerima kode?',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Resend via Email
                            OutlinedButton.icon(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : () => controller.resendOtp(type: 'email'),
                              icon: Icon(Iconsax.sms, size: 18.sp),
                              label: Text('Email'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                side: BorderSide(color: AppColors.primary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 12.h,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            // Resend via WhatsApp
                            OutlinedButton.icon(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : () =>
                                        controller.resendOtp(type: 'whatsapp'),
                              icon: Icon(Iconsax.call, size: 18.sp),
                              label: Text('WhatsApp'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.green,
                                side: BorderSide(color: Colors.green),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 12.h,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: Text(
                        'Kirim ulang dalam ${controller.countdown.value}s',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textMuted,
                        ),
                      ),
                    );
                  }
                }),

                SizedBox(height: 40.h),

                // Verify button
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed:
                          controller.isLoading.value ||
                              controller.otpController.text.length < 6
                          ? null
                          : controller.verifyOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        disabledBackgroundColor: AppColors.border.withValues(
                          alpha: 0.3,
                        ),
                      ),
                      child: controller.isLoading.value
                          ? SizedBox(
                              width: 24.w,
                              height: 24.h,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Verifikasi',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: controller.otpController.text.length < 6
                                    ? AppColors.textMuted
                                    : Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),

                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PinTheme _defaultPinTheme() {
    return PinTheme(
      width: 50.w,
      height: 60.h,
      textStyle: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border, width: 1.5),
      ),
    );
  }

  PinTheme _focusedPinTheme() {
    return _defaultPinTheme().copyWith(
      decoration: _defaultPinTheme().decoration!.copyWith(
        border: Border.all(color: AppColors.primary, width: 2),
      ),
    );
  }

  PinTheme _submittedPinTheme() {
    return _defaultPinTheme().copyWith(
      decoration: _defaultPinTheme().decoration!.copyWith(
        color: AppColors.primary.withValues(alpha: 0.1),
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  PinTheme _errorPinTheme() {
    return _defaultPinTheme().copyWith(
      decoration: _defaultPinTheme().decoration!.copyWith(
        border: Border.all(color: Colors.red, width: 1.5),
      ),
    );
  }
}
