import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/app_colors.dart';
import '../controllers/consultant_profile_controller.dart';

class ConsultantProfileEditView extends GetView<ConsultantProfileController> {
  const ConsultantProfileEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: [
            Container(
              height: 200.h,
              decoration: BoxDecoration(color: AppColors.primary),
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
                          'Edit Profil',
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
                        child: Container(
                          padding: EdgeInsets.all(24.w),
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: AppColors.border,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildAvatarSection(),
                              SizedBox(height: 32.h),
                              _buildLabel('Nama Lengkap'),
                              SizedBox(height: 8.h),
                              _buildTextField(
                                controller: controller.nameController,
                                hint: 'Masukkan nama lengkap',
                                icon: Iconsax.user,
                              ),
                              SizedBox(height: 20.h),
                              _buildLabel('Bio'),
                              SizedBox(height: 8.h),
                              _buildTextField(
                                controller: controller.bioController,
                                hint: 'Ceritakan tentang diri Anda',
                                icon: Iconsax.document_text,
                                maxLines: 4,
                              ),
                              SizedBox(height: 20.h),
                              _buildLabel('Nomor Sertifikat'),
                              SizedBox(height: 8.h),
                              _buildTextField(
                                controller: controller.certificationController,
                                hint: 'Masukkan nomor sertifikat',
                                icon: Iconsax.award,
                              ),
                              SizedBox(height: 20.h),
                              _buildLabel('Kota'),
                              SizedBox(height: 8.h),
                              _buildTextField(
                                controller: controller.cityController,
                                hint: 'Masukkan kota',
                                icon: Iconsax.location,
                              ),
                              SizedBox(height: 20.h),
                              _buildLabel('Provinsi'),
                              SizedBox(height: 8.h),
                              _buildTextField(
                                controller: controller.provinceController,
                                hint: 'Masukkan provinsi',
                                icon: Iconsax.map,
                              ),
                              SizedBox(height: 24.h),
                              _buildSpecializationsSection(),
                              SizedBox(height: 32.h),
                              Obx(
                                () => SizedBox(
                                  width: double.infinity,
                                  height: 52.h,
                                  child: ElevatedButton(
                                    onPressed: controller.isSaving.value
                                        ? null
                                        : controller.updateProfile,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          16.r,
                                        ),
                                      ),
                                    ),
                                    child: controller.isSaving.value
                                        ? SizedBox(
                                            width: 24.w,
                                            height: 24.h,
                                            child:
                                                const CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2,
                                                ),
                                          )
                                        : Text(
                                            'Simpan Perubahan',
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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

  Widget _buildAvatarSection() {
    return Obx(() {
      final user = controller.user.value;

      return Center(
        child: GestureDetector(
          onTap: controller.pickAndUploadAvatar,
          child: Stack(
            children: [
              Container(
                width: 100.w,
                height: 100.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.background,
                  border: Border.all(color: AppColors.border, width: 2),
                  image: user?.avatarUrl != null
                      ? DecorationImage(
                          image: NetworkImage(user!.avatarUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: user?.avatarUrl == null
                    ? Center(
                        child: Text(
                          user?.name.substring(0, 1).toUpperCase() ?? 'C',
                          style: TextStyle(
                            fontSize: 40.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(
                    Iconsax.camera5,
                    size: 16.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSpecializationsSection() {
    return Obx(() {
      final categories = controller.categories;
      final selectedIds = controller.selectedCategoryIds;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('Spesialisasi'),
          SizedBox(height: 8.h),
          Text(
            'Pilih bidang spesialisasi Anda',
            style: TextStyle(fontSize: 12.sp, color: AppColors.textMuted),
          ),
          SizedBox(height: 12.h),
          if (categories.isEmpty)
            const Center(child: CircularProgressIndicator())
          else
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: categories.map((category) {
                final isSelected = selectedIds.contains(category.id);
                return GestureDetector(
                  onTap: () => controller.toggleCategory(category.id),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.background,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isSelected)
                          Icon(
                            Iconsax.tick_circle5,
                            size: 16.sp,
                            color: Colors.white,
                          ),
                        if (isSelected) SizedBox(width: 6.w),
                        Text(
                          category.name,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textPrimary,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      );
    });
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14.sp),
        prefixIcon: Icon(icon, size: 20.sp, color: AppColors.textSecondary),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
    );
  }
}
