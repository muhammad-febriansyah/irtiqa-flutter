import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/app_colors.dart';
import '../controllers/account_controller.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: [
            Container(
              height: 240.h,
              decoration: BoxDecoration(
                color: AppColors.primary,
              ),
            ),

            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 32.h),
                      child: Obx(() {
                        final userData = controller.user.value;
                        return Column(
                          children: [
                            Container(
                              width: 90.w,
                              height: 90.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.card,
                                border: Border.all(
                                  color: AppColors.border,
                                  width: 3,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  userData?['name']
                                          ?.substring(0, 1)
                                          .toUpperCase() ??
                                      'U',
                                  style: TextStyle(
                                    fontSize: 36.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              userData?['name'] ?? 'Pengguna',
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Text(
                                userData?['email'] ?? '',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.white.withValues(alpha: 0.95),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: [
                          _buildMenuSection(
                            title: 'Akun',
                            items: [
                              _buildMenuItem(
                                icon: Iconsax.user,
                                title: 'Profil',
                                subtitle: 'Kelola informasi pribadi Anda',
                                onTap: controller.goToProfile,
                                color: AppColors.primary,
                              ),
                              _buildMenuItem(
                                icon: Iconsax.setting_2,
                                title: 'Pengaturan',
                                subtitle: 'Preferensi aplikasi',
                                onTap: controller.goToSettings,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          _buildMenuSection(
                            title: 'Bantuan & Info',
                            items: [
                              _buildMenuItem(
                                icon: Iconsax.message_question,
                                title: 'Bantuan',
                                subtitle:
                                    'Kami siap membantu penggunaan aplikasi',
                                onTap: controller.goToHelp,
                                color: AppColors.primary,
                              ),
                              _buildMenuItem(
                                icon: Iconsax.info_circle,
                                title: 'Tentang IRTIQA',
                                subtitle:
                                    'Pendampingan dengan adab dan kehati-hatian',
                                onTap: controller.goToAbout,
                                color: AppColors.primary,
                              ),
                              _buildMenuItem(
                                icon: Iconsax.shield_tick,
                                title: 'Kebijakan Privasi',
                                subtitle: 'Perlindungan data dan privasi Anda',
                                onTap: controller.goToPrivacyPolicy,
                                color: const Color(0xFFF59E0B),
                              ),
                              _buildMenuItem(
                                icon: Iconsax.document_text,
                                title: 'Syarat & Ketentuan',
                                subtitle: 'Ketentuan penggunaan layanan',
                                onTap: controller.goToTermsAndConditions,
                                color: const Color(0xFF8B5CF6),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),

                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: const Color(0xFFEF4444).withValues(alpha: 0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: controller.logout,
                                borderRadius: BorderRadius.circular(16.r),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Iconsax.logout,
                                        size: 20.sp,
                                        color: const Color(0xFFEF4444),
                                      ),
                                      SizedBox(width: 10.w),
                                      Text(
                                        'Keluar',
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFFEF4444),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection({
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 12.h),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: [
              Container(
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Icon(icon, size: 22.sp, color: color),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Iconsax.arrow_right_3,
                size: 18.sp,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
