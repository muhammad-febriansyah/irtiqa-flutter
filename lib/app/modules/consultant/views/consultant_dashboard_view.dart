import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/app_colors.dart';

class ConsultantDashboardView extends StatelessWidget {
  const ConsultantDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsGrid(),
                  SizedBox(height: 24.h),
                  _buildSectionHeader(
                    'Ruang Konsultasi Awal (Ticketing)',
                    () => Get.toNamed('/consultant/queue'),
                  ),
                  SizedBox(height: 12.h),
                  _buildTicketQueueList(),
                  SizedBox(height: 24.h),
                  _buildSectionHeader(
                    'Ruang Pembimbingan (Aktif)',
                    () => Get.toNamed('/consultant/active'),
                  ),
                  SizedBox(height: 12.h),
                  _buildActiveConsultations(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120.h,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.primary,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Dashboard Konsultan',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        background: Container(
          color: AppColors.primary,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Iconsax.notification, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16.w,
      mainAxisSpacing: 16.w,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard('Antrean', '12', Iconsax.ticket, Colors.amber),
        _buildStatCard('Aktif', '5', Iconsax.message_text5, Colors.blue),
        _buildStatCard('Selesai', '48', Iconsax.tick_circle5, Colors.green),
        _buildStatCard('Siaga', '2', Iconsax.warning_2, Colors.red),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 20.sp),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            'Lihat Semua',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTicketQueueList() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        children: [
          _buildQueueItem(
            'Ticket #1024',
            'Mimpi yg mengganggu',
            'Tinggi',
            '2 jam yang lalu',
          ),
          Divider(),
          _buildQueueItem(
            'Ticket #1025',
            'Waswas dlm ibadah',
            'Sedang',
            '5 jam yang lalu',
          ),
        ],
      ),
    );
  }

  Widget _buildQueueItem(
    String id,
    String subject,
    String priority,
    String time,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Iconsax.message_text,
              color: AppColors.primary,
              size: 18.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
                Text(
                  id,
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12.sp),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                priority,
                style: TextStyle(
                  color: priority == 'Tinggi' ? Colors.red : Colors.amber,
                  fontWeight: FontWeight.bold,
                  fontSize: 11.sp,
                ),
              ),
              Text(
                time,
                style: TextStyle(color: AppColors.textMuted, fontSize: 10.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveConsultations() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Center(
        child: Text(
          'Daftar pendampingan aktif akan muncul di sini',
          style: TextStyle(color: AppColors.textMuted),
        ),
      ),
    );
  }
}
