import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../core/app_colors.dart';
import '../../../data/models/dream_model.dart';

class DreamDetailView extends StatelessWidget {
  const DreamDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final DreamModel dream = Get.arguments;

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
                          constraints: BoxConstraints(),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          'Detail Mimpi',
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
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Column(
                          children: [
                            _buildClassificationCard(dream),
                            SizedBox(height: 20.h),
                            _buildDreamContentCard(dream),
                            SizedBox(height: 20.h),
                            _buildGuidanceCard(dream),
                          ],
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

  Widget _buildClassificationCard(DreamModel dream) {
    final Color color = _getClassificationColor(dream.classification);

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getClassificationIcon(dream.classification),
              size: 40.sp,
              color: color,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            dream.classificationText,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            _getClassificationDescription(dream.classification),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDreamContentCard(DreamModel dream) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Iconsax.calendar, size: 16.sp, color: AppColors.textMuted),
              SizedBox(width: 8.w),
              Text(
                DateFormat('dd MMMM yyyy').format(dream.dreamDate),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          if (dream.dreamTime != null) ...[
            Row(
              children: [
                Icon(Iconsax.clock, size: 16.sp, color: AppColors.textMuted),
                SizedBox(width: 8.w),
                Text(
                  dream.dreamTimeText,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
          ],
          Text(
            dream.dreamContent,
            style: TextStyle(
              fontSize: 15.sp,
              color: AppColors.textPrimary,
              height: 1.6,
            ),
          ),
          if (dream.physicalCondition != null || dream.emotionalCondition != null) ...[
            SizedBox(height: 16.h),
            Divider(color: AppColors.border),
            SizedBox(height: 16.h),
            if (dream.physicalCondition != null)
              Row(
                children: [
                  Icon(Iconsax.health, size: 16.sp, color: AppColors.textMuted),
                  SizedBox(width: 8.w),
                  Text(
                    'Kondisi Fisik: ${dream.physicalConditionText}',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            if (dream.physicalCondition != null && dream.emotionalCondition != null)
              SizedBox(height: 8.h),
            if (dream.emotionalCondition != null)
              Row(
                children: [
                  Icon(Iconsax.heart, size: 16.sp, color: AppColors.textMuted),
                  SizedBox(width: 8.w),
                  Text(
                    'Kondisi Emosi: ${dream.emotionalConditionText}',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildGuidanceCard(DreamModel dream) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Iconsax.info_circle5, size: 20.sp, color: AppColors.primary),
              SizedBox(width: 10.w),
              Text(
                'Saran & Amalan',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ..._getGuidancePoints(dream.classification).map(
            (point) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16.sp,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      point,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (dream.classification == 'sensitive_indication') ...[
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.toNamed('/consultation/create'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Ajukan Pendampingan',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getClassificationColor(String? classification) {
    switch (classification) {
      case 'khayali_nafsani':
        return Colors.amber;
      case 'emotional':
        return Colors.blue;
      case 'sensitive_indication':
        return Colors.orange;
      case 'needs_consultation':
        return Colors.red;
      default:
        return AppColors.textMuted;
    }
  }

  IconData _getClassificationIcon(String? classification) {
    switch (classification) {
      case 'khayali_nafsani':
        return Iconsax.sun_15;
      case 'emotional':
        return Iconsax.heart5;
      case 'sensitive_indication':
        return Iconsax.warning_25;
      case 'needs_consultation':
        return Iconsax.message_text5;
      default:
        return Iconsax.info_circle5;
    }
  }

  String _getClassificationDescription(String? classification) {
    switch (classification) {
      case 'khayali_nafsani':
        return 'Mimpi ini kemungkinan berasal dari pikiran atau aktivitas harian Anda (Adhghatsu Ahlam).';
      case 'emotional':
        return 'Mimpi ini berkaitan dengan kondisi emosional atau psikologis yang sedang Anda alami.';
      case 'sensitive_indication':
        return 'Terdapat indikasi kegelisahan yang perlu dipahami secara lebih mendalam dan tenang.';
      default:
        return 'Mimpi Anda sedang dalam peninjauan sistem.';
    }
  }

  List<String> _getGuidancePoints(String? classification) {
    switch (classification) {
      case 'khayali_nafsani':
        return [
          'Tidak perlu merasa cemas atau mencari tafsir berlebihan.',
          'Sempurnakan adab sebelum tidur (wudhu, doa, posisi miring kanan).',
          'Perbanyak dzikir ringan sebelum beristirahat.',
        ];
      case 'emotional':
        return [
          'Luangkan waktu untuk relaksasi dan menenangkan pikiran.',
          'Cobalah menulis jurnal perasaan untuk melepaskan beban emosi.',
          'Lakukan muhasabah (evaluasi diri) dengan cara yang positif.',
        ];
      case 'sensitive_indication':
        return [
          'Tetap tenang dan jangan menyimpulkan secara tergesa-gesa.',
          'Fokuslah pada amalan wajib dan dzikir pagi-petang.',
          'Jika kegelisahan berlanjut, disarankan untuk berkonsultasi.',
        ];
      default:
        return ['Jaga ketenangan dan fokus pada dzikir rutin.'];
    }
  }
}
