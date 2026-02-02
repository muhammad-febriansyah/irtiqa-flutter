import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/app_colors.dart';
import '../../home/views/home_view.dart';
import '../../consultation/views/consultation_view.dart';
import '../../education/views/education_view.dart';
import '../../account/views/account_view.dart';
import '../../consultant/views/consultant_dashboard_view.dart';
import '../controllers/bottomnavigator_controller.dart';

class BottomnavigatorView extends GetView<BottomnavigatorController> {
  const BottomnavigatorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isConsultant = controller.isConsultant;

      final List<Widget> pages = isConsultant
          ? [
              const ConsultantDashboardView(),
              const ConsultationView(), // Reuse or create specialized queue view
              const EducationView(),
              const AccountView(),
            ]
          : [
              const HomeView(),
              const ConsultationView(),
              const EducationView(),
              const AccountView(),
            ];

      return Scaffold(
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: pages,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            border: Border(
              top: BorderSide(color: AppColors.border, width: 1),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    icon: isConsultant ? Iconsax.status_up : Iconsax.home,
                    label: isConsultant ? 'Dashboard' : 'Beranda',
                    index: 0,
                  ),
                  _buildNavItem(
                    icon: isConsultant ? Iconsax.ticket : Iconsax.message,
                    label: isConsultant ? 'Antrean' : 'Pendampingan',
                    index: 1,
                  ),
                  _buildNavItem(icon: Iconsax.book, label: 'Edukasi', index: 2),
                  _buildNavItem(icon: Iconsax.user, label: 'Akun', index: 3),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = controller.currentIndex.value == index;

    return GestureDetector(
      onTap: () => controller.changePage(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24.sp,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppColors.primary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
