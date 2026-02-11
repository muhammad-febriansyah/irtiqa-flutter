import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import '../core/app_colors.dart';
import '../core/risk_assessment.dart';

class CrisisWarningDialog extends StatelessWidget {
  final String riskLevel;
  final VoidCallback onProceed;
  final VoidCallback onCallHotline;
  final VoidCallback? onPanicButton;

  const CrisisWarningDialog({
    super.key,
    required this.riskLevel,
    required this.onProceed,
    required this.onCallHotline,
    this.onPanicButton,
  });

  @override
  Widget build(BuildContext context) {
    final isCritical = riskLevel == RiskAssessment.riskCritical;
    final isHigh = riskLevel == RiskAssessment.riskHigh;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Warning icon
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: isCritical
                    ? Colors.red.withValues(alpha: 0.1)
                    : isHigh
                        ? Colors.orange.withValues(alpha: 0.1)
                        : Colors.blue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isCritical
                    ? Iconsax.danger
                    : isHigh
                        ? Iconsax.warning_2
                        : Iconsax.info_circle,
                size: 48.sp,
                color: isCritical
                    ? Colors.red
                    : isHigh
                        ? Colors.orange
                        : Colors.blue,
              ),
            ),

            SizedBox(height: 20.h),

            // Title
            Text(
              isCritical
                  ? 'Kondisi Darurat Terdeteksi'
                  : isHigh
                      ? 'Perhatian Khusus Diperlukan'
                      : 'Informasi Penting',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 16.h),

            // Message
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: isCritical
                    ? Colors.red.withValues(alpha: 0.05)
                    : isHigh
                        ? Colors.orange.withValues(alpha: 0.05)
                        : Colors.blue.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                RiskAssessment.getWarningMessage(riskLevel),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 20.h),

            // Recommended actions
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Langkah yang Disarankan:',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  ...RiskAssessment.getRecommendedActions(riskLevel)
                      .map((action) => Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 4.h),
                                  width: 6.w,
                                  height: 6.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Text(
                                    action,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: AppColors.textSecondary,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Action buttons
            if (isCritical || isHigh) ...[
              // Call hotline button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onCallHotline,
                  icon: Icon(Iconsax.call, size: 20.sp),
                  label: Text(
                    'Hubungi Hotline (119)',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              SizedBox(height: 12.h),

              // Panic button
              if (onPanicButton != null)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onPanicButton,
                    icon: Icon(Iconsax.danger, size: 20.sp),
                    label: Text(
                      'Tombol Darurat',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: BorderSide(color: Colors.red, width: 2),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 12.h),
            ],

            // Proceed button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: onProceed,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Lanjutkan Kirim Konsultasi',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
