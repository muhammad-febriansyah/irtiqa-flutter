import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:irtiqa/app/core/app_colors.dart';
import 'package:irtiqa/app/modules/consultant_application/controllers/consultant_application_controller.dart';
import 'package:file_picker/file_picker.dart';

class ConsultantApplicationView
    extends GetView<ConsultantApplicationController> {
  const ConsultantApplicationView({super.key});

  @override
  Widget build(BuildContext context) {
    final fullNameController = TextEditingController();
    final phoneController = TextEditingController();
    final certNumberController = TextEditingController();
    final institutionController = TextEditingController();
    final experienceController = TextEditingController();
    final specializationController = TextEditingController();
    final motivationController = TextEditingController();

    final selectedCertType = 'psikolog'.obs;
    final selectedFile = Rx<PlatformFile?>(null);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text(
          'Daftar Konsultan',
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
            // Info box
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppColors.info.withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Iconsax.info_circle5,
                    color: AppColors.info,
                    size: 20.sp,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Aplikasi akan ditinjau dalam 3-5 hari kerja. Pastikan semua data yang Anda masukkan akurat.',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // Full name
            _buildTextField(
              controller: fullNameController,
              label: 'Nama Lengkap',
              hint: 'Sesuai ijazah/sertifikat',
              icon: Iconsax.user,
            ),

            SizedBox(height: 16.h),

            // Phone
            _buildTextField(
              controller: phoneController,
              label: 'Nomor Telepon',
              hint: '08xxxxxxxxxx',
              icon: Iconsax.call,
              keyboardType: TextInputType.phone,
            ),

            SizedBox(height: 16.h),

            // Certification type
            Text(
              'Jenis Sertifikasi',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Obx(
              () => Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.border),
                ),
                child: DropdownButton<String>(
                  value: selectedCertType.value,
                  isExpanded: true,
                  underline: SizedBox(),
                  icon: Icon(Icons.arrow_drop_down, color: AppColors.primary),
                  items: [
                    DropdownMenuItem(
                      value: 'psikolog',
                      child: Text('Psikolog'),
                    ),
                    DropdownMenuItem(
                      value: 'konselor',
                      child: Text('Konselor'),
                    ),
                    DropdownMenuItem(value: 'kyai', child: Text('Kyai/Ustadz')),
                    DropdownMenuItem(value: 'other', child: Text('Lainnya')),
                  ],
                  onChanged: (value) {
                    if (value != null) selectedCertType.value = value;
                  },
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Certification number
            _buildTextField(
              controller: certNumberController,
              label: 'Nomor Sertifikat/Ijazah',
              hint: 'Nomor registrasi',
              icon: Iconsax.card,
            ),

            SizedBox(height: 16.h),

            // Institution
            _buildTextField(
              controller: institutionController,
              label: 'Institusi Penerbit',
              hint: 'Nama universitas/lembaga',
              icon: Iconsax.building,
            ),

            SizedBox(height: 16.h),

            // Experience years
            _buildTextField(
              controller: experienceController,
              label: 'Pengalaman (Tahun)',
              hint: 'Contoh: 5',
              icon: Iconsax.calendar_1,
              keyboardType: TextInputType.number,
            ),

            SizedBox(height: 16.h),

            // Specialization
            _buildTextField(
              controller: specializationController,
              label: 'Spesialisasi',
              hint: 'Contoh: Konseling Keluarga, Trauma, dll',
              icon: Iconsax.star,
            ),

            SizedBox(height: 16.h),

            // Motivation
            _buildTextField(
              controller: motivationController,
              label: 'Motivasi Bergabung',
              hint: 'Ceritakan mengapa Anda ingin bergabung...',
              icon: Iconsax.message_text,
              maxLines: 4,
            ),

            SizedBox(height: 16.h),

            // File upload
            Text(
              'Unggah Sertifikat (Maks 5MB)',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Obx(
              () => InkWell(
                onTap: () async {
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
                  );
                  if (result != null) {
                    selectedFile.value = result.files.first;
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: selectedFile.value != null
                          ? AppColors.primary
                          : AppColors.border,
                      width: selectedFile.value != null ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        selectedFile.value != null
                            ? Iconsax.document_upload5
                            : Iconsax.document_upload,
                        color: selectedFile.value != null
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        size: 20.sp,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          selectedFile.value?.name ??
                              'Pilih file (PDF, JPG, PNG)',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: selectedFile.value != null
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                      if (selectedFile.value != null)
                        InkWell(
                          onTap: () => selectedFile.value = null,
                          child: Icon(
                            Icons.close,
                            color: AppColors.error,
                            size: 20.sp,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 32.h),

            // Submit button
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () async {
                          // Validation
                          if (fullNameController.text.isEmpty ||
                              phoneController.text.isEmpty ||
                              certNumberController.text.isEmpty ||
                              institutionController.text.isEmpty ||
                              experienceController.text.isEmpty ||
                              specializationController.text.isEmpty ||
                              motivationController.text.isEmpty) {
                            Get.snackbar(
                              'Perhatian',
                              'Silakan lengkapi semua field yang wajib',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            return;
                          }

                          final success = await controller.submitApplication(
                            fullName: fullNameController.text,
                            phone: phoneController.text,
                            certificationType: selectedCertType.value,
                            certificationNumber: certNumberController.text,
                            institution: institutionController.text,
                            experienceYears:
                                int.tryParse(experienceController.text) ?? 0,
                            specialization: specializationController.text,
                            motivation: motivationController.text,
                            certificationFile: selectedFile.value?.path,
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
                          'Kirim Aplikasi',
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.textMuted),
            prefixIcon: Icon(icon, color: AppColors.primary, size: 20.sp),
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
      ],
    );
  }
}
