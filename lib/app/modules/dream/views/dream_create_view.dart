import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../core/app_colors.dart';
import '../../../data/repositories/dream_repository.dart';
import '../../../widgets/crisis_warning_dialog.dart';
import '../../../core/risk_assessment.dart';
import 'package:url_launcher/url_launcher.dart';

class DreamCreateView extends StatefulWidget {
  const DreamCreateView({super.key});

  @override
  State<DreamCreateView> createState() => _DreamCreateViewState();
}

class _DreamCreateViewState extends State<DreamCreateView> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  final DreamRepository _repository = DreamRepository();

  DateTime? _selectedDate;
  String? _selectedDreamTime;
  String? _selectedPhysicalCondition;
  String? _selectedEmotionalCondition;
  bool _disclaimerChecked = false;
  bool _isLoading = false;

  final List<Map<String, String>> _dreamTimes = [
    {'value': 'dawn', 'label': 'Subuh'},
    {'value': 'morning', 'label': 'Pagi'},
    {'value': 'afternoon', 'label': 'Siang'},
    {'value': 'evening', 'label': 'Sore'},
    {'value': 'night', 'label': 'Malam'},
  ];

  final List<Map<String, String>> _physicalConditions = [
    {'value': 'healthy', 'label': 'Sehat'},
    {'value': 'sick', 'label': 'Sakit'},
    {'value': 'tired', 'label': 'Lelah'},
    {'value': 'stressed', 'label': 'Stress'},
  ];

  final List<Map<String, String>> _emotionalConditions = [
    {'value': 'calm', 'label': 'Tenang'},
    {'value': 'happy', 'label': 'Senang'},
    {'value': 'sad', 'label': 'Sedih'},
    {'value': 'anxious', 'label': 'Gelisah'},
    {'value': 'angry', 'label': 'Marah'},
  ];

  @override
  void dispose() {
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
                                _buildLabel('Tanggal Mimpi *'),
                                SizedBox(height: 8.h),
                                _buildDatePicker(),
                                SizedBox(height: 20.h),

                                _buildLabel('Waktu Mimpi (Opsional)'),
                                SizedBox(height: 8.h),
                                _buildDropdown(
                                  value: _selectedDreamTime,
                                  items: _dreamTimes,
                                  hint: 'Pilih waktu mimpi',
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedDreamTime = value;
                                    });
                                  },
                                  required: false,
                                ),
                                SizedBox(height: 20.h),

                                _buildLabel('Ceritakan Mimpi *'),
                                SizedBox(height: 8.h),
                                _buildTextArea(
                                  controller: _contentController,
                                  hint: 'Ceritakan secara singkat, tidak perlu detail berlebihan',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Mohon ceritakan mimpi Anda';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 20.h),

                                _buildLabel('Kondisi Fisik (Opsional)'),
                                SizedBox(height: 8.h),
                                _buildDropdown(
                                  value: _selectedPhysicalCondition,
                                  items: _physicalConditions,
                                  hint: 'Pilih kondisi fisik',
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedPhysicalCondition = value;
                                    });
                                  },
                                  required: false,
                                ),
                                SizedBox(height: 20.h),

                                _buildLabel('Kondisi Emosi (Opsional)'),
                                SizedBox(height: 8.h),
                                _buildDropdown(
                                  value: _selectedEmotionalCondition,
                                  items: _emotionalConditions,
                                  hint: 'Pilih kondisi emosi',
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedEmotionalCondition = value;
                                    });
                                  },
                                  required: false,
                                ),
                                SizedBox(height: 24.h),

                                _buildDisclaimerCheckbox(),
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
                                        borderRadius: BorderRadius.circular(16.r),
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

  Widget _buildDropdown({
    required String? value,
    required List<Map<String, String>> items,
    required String hint,
    required Function(String?) onChanged,
    bool required = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
        ),
        hint: Text(
          hint,
          style: TextStyle(color: AppColors.textMuted, fontSize: 14.sp),
        ),
        items: items.map((item) {
          return DropdownMenuItem(
            value: item['value'],
            child: Text(item['label'] ?? ''),
          );
        }).toList(),
        onChanged: onChanged,
        validator: required
            ? (value) {
                if (value == null) {
                  return 'Mohon pilih salah satu';
                }
                return null;
              }
            : null,
      ),
    );
  }

  Widget _buildDisclaimerCheckbox() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24.w,
            height: 24.h,
            child: Checkbox(
              value: _disclaimerChecked,
              onChanged: (value) {
                setState(() {
                  _disclaimerChecked = value ?? false;
                });
              },
              activeColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Saya memahami bahwa:',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'Tidak semua mimpi memiliki makna religius atau harus ditafsirkan. Sistem ini hanya memberikan perspektif awal berdasarkan prinsip anti-sugesti.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitForm() async {
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

      if (!_disclaimerChecked) {
        Get.snackbar(
          'Perhatian',
          'Mohon centang disclaimer terlebih dahulu',
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

      try {
        final result = await _repository.createDream(
          dreamContent: _contentController.text,
          dreamDate: _selectedDate!,
          dreamTime: _selectedDreamTime,
          physicalCondition: _selectedPhysicalCondition,
          emotionalCondition: _selectedEmotionalCondition,
          disclaimerChecked: _disclaimerChecked,
        );

        setState(() {
          _isLoading = false;
        });

        if (result != null) {
          // Check if risk assessment is needed
          final assessment = RiskAssessment.assess(result.dreamContent);
          final riskLevel = assessment['risk_level'] as String;

          if (riskLevel == RiskAssessment.riskCritical ||
              riskLevel == RiskAssessment.riskHigh) {
            _showCrisisWarning(result, riskLevel);
            return;
          }

          Get.snackbar(
            'Berhasil',
            'Mimpi berhasil disimpan',
            backgroundColor: Colors.green.withValues(alpha: 0.1),
            colorText: Colors.green,
            snackPosition: SnackPosition.TOP,
            margin: EdgeInsets.all(16.w),
            borderRadius: 12.r,
          );
          Get.back(result: true);
        } else {
          Get.snackbar(
            'Error',
            'Gagal menyimpan mimpi',
            backgroundColor: Colors.red.withValues(alpha: 0.1),
            colorText: Colors.red,
            snackPosition: SnackPosition.TOP,
            margin: EdgeInsets.all(16.w),
            borderRadius: 12.r,
          );
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        Get.snackbar(
          'Error',
          'Terjadi kesalahan: ${e.toString()}',
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          colorText: Colors.red,
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.all(16.w),
          borderRadius: 12.r,
        );
      }
    }
  }

  void _showCrisisWarning(dynamic dream, String riskLevel) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CrisisWarningDialog(
        riskLevel: riskLevel,
        onProceed: () {
          Get.back(); // Close dialog
          Get.back(result: true); // Back to list
        },
        onCallHotline: () async {
          final uri = Uri.parse('tel:119');
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        },
        onPanicButton: () {
          Get.back(); // Close dialog
          Get.toNamed('/emergency');
        },
      ),
    );
  }
}
