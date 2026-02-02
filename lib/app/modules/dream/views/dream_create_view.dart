import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../core/app_colors.dart';

class DreamCreateView extends StatefulWidget {
  const DreamCreateView({super.key});

  @override
  State<DreamCreateView> createState() => _DreamCreateViewState();
}

class _DreamCreateViewState extends State<DreamCreateView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedFeeling;
  bool _isLoading = false;

  final List<Map<String, String>> _feelings = [
    {'value': 'calm', 'label': 'Tenang'},
    {'value': 'confused', 'label': 'Bingung'},
    {'value': 'worried', 'label': 'Khawatir'},
    {'value': 'scared', 'label': 'Takut'},
    {'value': 'curious', 'label': 'Penasaran'},
    {'value': 'other', 'label': 'Lainnya'},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

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
              decoration: BoxDecoration(
                color: AppColors.primary,
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
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
                              'Ceritakan Mimpi',
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Container(
                          padding: EdgeInsets.all(14.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Iconsax.info_circle5,
                                size: 18.sp,
                                color: Colors.white,
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: Text(
                                  'Tidak semua mimpi memiliki makna khusus. Ceritakan secara singkat saja.',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
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
                        child: Form(
                          key: _formKey,
                          child: Container(
                            padding: EdgeInsets.all(24.w),
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(color: AppColors.border, width: 1),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('Ringkasan Singkat'),
                                SizedBox(height: 8.h),
                                _buildTextField(
                                  controller: _titleController,
                                  hint: 'Contoh: Mimpi tentang perjalanan',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Mohon isi judul mimpi';
                                    }
                                    return null;
                                  },
                                ),

                                SizedBox(height: 20.h),

                                _buildLabel('Tanggal Mimpi'),
                                SizedBox(height: 8.h),
                                _buildDatePicker(),

                                SizedBox(height: 20.h),

                                _buildLabel('Ceritakan Mimpi'),
                                SizedBox(height: 8.h),
                                _buildTextArea(
                                  controller: _contentController,
                                  hint:
                                      'Ceritakan secara singkat, tidak perlu detail berlebihan',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Mohon ceritakan mimpi Anda';
                                    }
                                    return null;
                                  },
                                ),

                                SizedBox(height: 20.h),

                                _buildLabel('Perasaan Setelah Mimpi'),
                                SizedBox(height: 8.h),
                                _buildDropdown(),

                                SizedBox(height: 32.h),

                                SizedBox(
                                  width: double.infinity,
                                  height: 52.h,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _submitForm,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          16.r,
                                        ),
                                      ),
                                    ),
                                    child: _isLoading
                                        ? SizedBox(
                                            width: 24.w,
                                            height: 24.h,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Text(
                                            'Simpan Mimpi',
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14.sp),
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: Color(0xFFEF4444).withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
    );
  }

  Widget _buildTextArea({
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: 8,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14.sp),
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: Color(0xFFEF4444).withValues(alpha: 0.5),
            width: 1,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _selectedDate ?? DateTime.now(),
          firstDate: DateTime.now().subtract(Duration(days: 365)),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(primary: AppColors.primary),
              ),
              child: child ?? const SizedBox(),
            );
          },
        );
        if (date != null) {
          setState(() {
            _selectedDate = date;
          });
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Row(
          children: [
            Icon(Iconsax.calendar, size: 20.sp, color: AppColors.textSecondary),
            SizedBox(width: 12.w),
            Text(
              _selectedDate != null
                  ? DateFormat('dd MMMM yyyy', 'id_ID').format(_selectedDate!)
                  : 'Pilih tanggal mimpi',
              style: TextStyle(
                fontSize: 14.sp,
                color: _selectedDate != null
                    ? AppColors.textPrimary
                    : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: DropdownButtonFormField<String>(
        initialValue: _selectedFeeling,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
        ),
        hint: Text(
          'Pilih perasaan',
          style: TextStyle(color: AppColors.textMuted, fontSize: 14.sp),
        ),
        items: _feelings.map((feeling) {
          return DropdownMenuItem(
            value: feeling['value'],
            child: Text(feeling['label'] ?? ''),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedFeeling = value;
          });
        },
        validator: (value) {
          if (value == null) {
            return 'Mohon pilih perasaan';
          }
          return null;
        },
      ),
    );
  }

  void _submitForm() {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      if (_selectedDate == null) {
        Get.snackbar(
          'Perhatian',
          'Mohon pilih tanggal mimpi',
          backgroundColor: const Color(0xFFF59E0B).withValues(alpha: 0.1),
          colorText: const Color(0xFFF59E0B),
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.all(16.w),
          borderRadius: 12.r,
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // Auto-classification logic
      final content = _contentController.text.toLowerCase();
      String classification = 'Umum';
      String recommendation =
          'Tetap tenang dan jangan terlalu dipikirkan secara berlebihan.';

      if (content.contains('hantu') ||
          content.contains('film') ||
          content.contains('terbang') ||
          content.contains('monster')) {
        classification = 'Khayali (Imajinasi)';
        recommendation =
            'Mimpi ini kemungkinan berasal dari sisa imajinasi atau tontonan. Sebaiknya diabaikan saja.';
      } else if (_selectedFeeling == 'worried' ||
          _selectedFeeling == 'scared' ||
          content.contains('kerja') ||
          content.contains('ujian') ||
          content.contains('masalah')) {
        classification = 'Emosional (Beban Harian)';
        recommendation =
            'Mimpi ini mencerminkan beban emosi atau pikiran dari keseharian Anda. Luangkan waktu untuk relaksasi.';
      } else if (content.length > 200 &&
          (_selectedFeeling == 'scared' || _selectedFeeling == 'confused')) {
        classification = 'Indikasi Sensitif';
        recommendation =
            'Ada pola kegelisahan yang cukup tinggi. Kami sarankan untuk berkonsultasi lebih lanjut jika mimpi ini berulang.';
      }

      Future.delayed(Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
        });

        _showClassificationResults(classification, recommendation);
      });
    }
  }

  void _showClassificationResults(String type, String advice) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Tanggapan Awal',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(Iconsax.info_circle5, color: AppColors.primary),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Klasifikasi:',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          type,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              advice,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            SizedBox(height: 32.h),
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: () {
                  Get.back(); // Close bottom sheet
                  Get.back(); // Back to list
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
                child: Text(
                  'Mengerti',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16.h),
          ],
        ),
      ),
    );
  }
}
