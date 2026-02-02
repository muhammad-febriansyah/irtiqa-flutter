import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:irtiqa/app/core/app_colors.dart';
import 'package:irtiqa/app/modules/journal/controllers/journal_controller.dart';
import 'package:intl/intl.dart';

class JournalCreateView extends GetView<JournalController> {
  const JournalCreateView({super.key});

  @override
  Widget build(BuildContext context) {
    final dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );
    final contentController = TextEditingController();
    final selectedMood = 'neutral'.obs;
    final selectedTags = <String>[].obs;
    final tagController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text(
          'Tulis Jurnal',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date picker
            Text(
              'Tanggal',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  locale: Locale('id', 'ID'),
                );
                if (date != null) {
                  dateController.text = DateFormat('yyyy-MM-dd').format(date);
                }
              },
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Icon(
                      Iconsax.calendar,
                      color: AppColors.primary,
                      size: 20.sp,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        DateFormat(
                          'EEEE, dd MMMM yyyy',
                          'id_ID',
                        ).format(DateTime.parse(dateController.text)),
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Mood selector
            Text(
              'Bagaimana perasaanmu hari ini?',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 12.h),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMoodButton(
                    mood: 'very_bad',
                    emoji: '😢',
                    label: 'Sangat\nBuruk',
                    isSelected: selectedMood.value == 'very_bad',
                    onTap: () => selectedMood.value = 'very_bad',
                  ),
                  _buildMoodButton(
                    mood: 'bad',
                    emoji: '😔',
                    label: 'Buruk',
                    isSelected: selectedMood.value == 'bad',
                    onTap: () => selectedMood.value = 'bad',
                  ),
                  _buildMoodButton(
                    mood: 'neutral',
                    emoji: '😐',
                    label: 'Biasa',
                    isSelected: selectedMood.value == 'neutral',
                    onTap: () => selectedMood.value = 'neutral',
                  ),
                  _buildMoodButton(
                    mood: 'good',
                    emoji: '🙂',
                    label: 'Baik',
                    isSelected: selectedMood.value == 'good',
                    onTap: () => selectedMood.value = 'good',
                  ),
                  _buildMoodButton(
                    mood: 'very_good',
                    emoji: '😊',
                    label: 'Sangat\nBaik',
                    isSelected: selectedMood.value == 'very_good',
                    onTap: () => selectedMood.value = 'very_good',
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // Content
            Text(
              'Ceritakan apa yang kamu rasakan',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            TextField(
              controller: contentController,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'Tulis di sini...',
                hintStyle: TextStyle(color: AppColors.textMuted),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Tags
            Text(
              'Tag (Opsional)',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: tagController,
                    decoration: InputDecoration(
                      hintText: 'Tambah tag',
                      hintStyle: TextStyle(color: AppColors.textMuted),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                ElevatedButton(
                  onPressed: () {
                    if (tagController.text.isNotEmpty) {
                      selectedTags.add(tagController.text);
                      tagController.clear();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.all(16.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Icon(Iconsax.add, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Obx(
              () => selectedTags.isEmpty
                  ? SizedBox.shrink()
                  : Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: selectedTags.map((tag) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                tag,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 6.w),
                              InkWell(
                                onTap: () => selectedTags.remove(tag),
                                child: Icon(
                                  Icons.close,
                                  size: 16.sp,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ),

            SizedBox(height: 32.h),

            // Save button
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {
                          if (contentController.text.isEmpty) {
                            Get.snackbar(
                              'Perhatian',
                              'Silakan tulis isi jurnal',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            return;
                          }

                          final success = await controller.createEntry(
                            date: dateController.text,
                            mood: selectedMood.value,
                            content: contentController.text,
                            tags: selectedTags.isEmpty
                                ? null
                                : selectedTags.toList(),
                          );

                          if (success) {
                            Get.back();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: controller.isLoading.value
                      ? SizedBox(
                          height: 20.h,
                          width: 20.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          'Simpan Jurnal',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodButton({
    required String mood,
    required String emoji,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 65.w,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: TextStyle(fontSize: 28.sp)),
            SizedBox(height: 6.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10.sp,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
