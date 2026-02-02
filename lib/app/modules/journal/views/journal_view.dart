import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:irtiqa/app/core/app_colors.dart';
import 'package:irtiqa/app/modules/journal/controllers/journal_controller.dart';
import 'package:intl/intl.dart';

class JournalView extends GetView<JournalController> {
  const JournalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Header gradient
          Container(
            height: 200.h,
            decoration: BoxDecoration(
              color: AppColors.primary,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Jurnal Harian',
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                'Catat perasaan dan pikiranmu',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            child: Icon(
                              Iconsax.book5,
                              size: 28.sp,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Statistics card
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Obx(() => _buildStatisticsCard()),
                ),

                SizedBox(height: 20.h),

                // Entries list
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value &&
                        controller.entries.isEmpty) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (controller.entries.isEmpty) {
                      return _buildEmptyState();
                    }

                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      itemCount: controller.entries.length,
                      itemBuilder: (context, index) {
                        final entry = controller.entries[index];
                        return _buildEntryCard(entry);
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed('/journal/create'),
        backgroundColor: AppColors.primary,
        icon: Icon(Iconsax.add, color: Colors.white),
        label: Text(
          'Tulis Jurnal',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildStatisticsCard() {
    final stats = controller.statistics;
    final streakDays = stats['streak_days'] ?? 0;
    final totalEntries = stats['total_entries'] ?? 0;

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatItem(
              icon: Iconsax.calendar_15,
              value: '$streakDays',
              label: 'Hari Berturut',
              color: AppColors.primary,
            ),
          ),
          Container(width: 1, height: 40.h, color: AppColors.divider),
          Expanded(
            child: _buildStatItem(
              icon: Iconsax.book_15,
              value: '$totalEntries',
              label: 'Total Jurnal',
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, size: 24.sp, color: color),
        SizedBox(height: 8.h),
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
          style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildEntryCard(Map<String, dynamic> entry) {
    final date = DateTime.parse(entry['entry_date']);
    final mood = entry['mood'];
    final content = entry['content'];
    final tags = List<String>.from(entry['tags'] ?? []);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                controller.getMoodEmoji(mood),
                style: TextStyle(fontSize: 24.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(date),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      controller.getMoodLabel(mood),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Iconsax.more, size: 20.sp),
                onPressed: () => _showOptionsMenu(entry),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            content,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textPrimary,
              height: 1.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (tags.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: tags.map((tag) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.book, size: 80.sp, color: AppColors.textMuted),
          SizedBox(height: 16.h),
          Text(
            'Belum Ada Jurnal',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Mulai catat perasaan dan pikiranmu hari ini',
            style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  void _showOptionsMenu(Map<String, dynamic> entry) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Iconsax.edit, color: AppColors.primary),
              title: Text('Edit Jurnal'),
              onTap: () {
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Iconsax.trash, color: AppColors.error),
              title: Text('Hapus Jurnal'),
              onTap: () {
                Get.back();
                _confirmDelete(entry['id']);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(int id) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text('Hapus Jurnal?'),
        content: Text('Jurnal yang dihapus tidak dapat dikembalikan.'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Batal')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteEntry(id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
