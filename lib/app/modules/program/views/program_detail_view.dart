import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../core/app_colors.dart';
import '../../../data/models/program_model.dart';
import '../../../data/repositories/program_repository.dart';

class ProgramDetailView extends StatefulWidget {
  const ProgramDetailView({super.key});

  @override
  State<ProgramDetailView> createState() => _ProgramDetailViewState();
}

class _ProgramDetailViewState extends State<ProgramDetailView> {
  final ProgramRepository _repository = ProgramRepository();
  final isLoading = true.obs;
  final Rx<ProgramModel?> program = Rx<ProgramModel?>(null);

  @override
  void initState() {
    super.initState();
    _loadProgramDetails();
  }

  Future<void> _loadProgramDetails() async {
    isLoading.value = true;
    try {
      final id = int.parse(Get.parameters['id'] ?? '0');
      final data = await _repository.getProgramDetails(id);
      program.value = data;
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Detail Program',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Obx(() {
        if (isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (program.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.close_circle, size: 64.sp, color: AppColors.textMuted),
                SizedBox(height: 16.h),
                Text(
                  'Data tidak ditemukan',
                  style: TextStyle(fontSize: 16.sp, color: AppColors.textSecondary),
                ),
              ],
            ),
          );
        }

        final p = program.value!;
        final statusColor = _getStatusColor(p.status);

        return SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusCard(p, statusColor),
              SizedBox(height: 16.h),
              _buildProgressCard(p),
              SizedBox(height: 16.h),
              _buildInfoCard(p),
              SizedBox(height: 16.h),
              if (p.isActive || p.isCompleted) _buildChatButton(p.id),
              SizedBox(height: 16.h),
              if (p.isActive) _buildCompleteButton(p.id),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatusCard(ProgramModel p, Color statusColor) {
    return Container(
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: statusColor.withValues(alpha: 0.3), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6.w,
                      height: 6.h,
                      decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      p.statusText,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Icon(Iconsax.crown_1, size: 16.sp, color: Colors.amber),
              SizedBox(width: 4.w),
              Text(
                'Program Pembimbingan',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            p.programNumber ?? 'Program #${p.id}',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(ProgramModel p) {
    return Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progress Program',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${p.progressPercentage}%',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          LinearProgressIndicator(
            value: p.progressPercentage / 100,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 8.h,
            borderRadius: BorderRadius.circular(4.r),
          ),
          SizedBox(height: 8.h),
          Text(
            p.progressText,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(ProgramModel p) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informasi Program',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          _buildInfoRow(Iconsax.task_square, 'Judul', p.title),
          if (p.description != null) ...[
            SizedBox(height: 12.h),
            _buildInfoRow(Iconsax.document_text, 'Deskripsi', p.description!),
          ],
          if (p.goals.isNotEmpty) ...[
            SizedBox(height: 12.h),
            _buildGoalsList(p.goals),
          ],
          if (p.startDate != null) ...[
            SizedBox(height: 12.h),
            _buildInfoRow(
              Iconsax.calendar,
              'Mulai',
              DateFormat('dd MMMM yyyy').format(p.startDate!),
            ),
          ],
          if (p.endDate != null) ...[
            SizedBox(height: 12.h),
            _buildInfoRow(
              Iconsax.calendar,
              'Berakhir',
              DateFormat('dd MMMM yyyy').format(p.endDate!),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18.sp, color: AppColors.primary),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textPrimary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGoalsList(List<String> goals) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Iconsax.flag, size: 18.sp, color: AppColors.primary),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tujuan',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4.h),
              ...goals.map((goal) => Padding(
                    padding: EdgeInsets.only(bottom: 4.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('• ', style: TextStyle(color: AppColors.textPrimary)),
                        Expanded(
                          child: Text(
                            goal,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textPrimary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChatButton(int programId) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Get.toNamed('/chat', arguments: {
            'id': programId,
            'type': 'program',
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.message_text, size: 20.sp, color: Colors.white),
            SizedBox(width: 8.w),
            Text(
              'Buka Chat',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompleteButton(int programId) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => _showCompleteDialog(programId),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          side: BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          'Selesaikan Program',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  void _showCompleteDialog(int programId) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Selesaikan Program?',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Apakah Anda yakin program ini sudah selesai?',
          style: TextStyle(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Batal', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              final success = await _repository.completeProgram(programId);
              if (success) {
                await _loadProgramDetails();
                Get.snackbar(
                  'Berhasil',
                  'Program telah diselesaikan',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              } else {
                Get.snackbar(
                  'Gagal',
                  'Gagal menyelesaikan program',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Ya, Selesaikan'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'in_progress':
        return const Color(0xFF3B82F6);
      case 'completed':
        return AppColors.primary;
      case 'cancelled':
        return const Color(0xFFEF4444);
      default:
        return AppColors.textMuted;
    }
  }
}
