import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import '../../../core/app_colors.dart';
import '../../../data/models/consultation_model.dart';
import '../../../data/repositories/consultation_repository.dart';

class ConsultationDetailView extends StatefulWidget {
  const ConsultationDetailView({super.key});

  @override
  State<ConsultationDetailView> createState() => _ConsultationDetailViewState();
}

class _ConsultationDetailViewState extends State<ConsultationDetailView> {
  final ConsultationRepository _repository = ConsultationRepository();
  final isLoading = true.obs;
  final Rx<ConsultationModel?> consultation = Rx<ConsultationModel?>(null);

  @override
  void initState() {
    super.initState();
    _loadConsultationDetails();
  }

  Future<void> _loadConsultationDetails() async {
    isLoading.value = true;
    try {
      final id = int.parse(Get.parameters['id'] ?? '0');
      final data = await _repository.getConsultationDetails(id);
      consultation.value = data;
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
          'Detail Pendampingan',
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

        if (consultation.value == null) {
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

        final c = consultation.value!;
        final statusColor = _getStatusColor(c.status);

        return SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusCard(c, statusColor),
              SizedBox(height: 16.h),
              _buildInfoCard(c),
              SizedBox(height: 16.h),
              if (c.status == 'in_progress' || c.status == 'completed')
                _buildChatButton(c.id),
              SizedBox(height: 16.h),
              if (c.status == 'waiting' || c.status == 'in_progress')
                _buildCancelButton(c.id),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatusCard(ConsultationModel c, Color statusColor) {
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
                      c.statusText,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: c.isInitialFree
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: c.isInitialFree
                        ? Colors.green.withValues(alpha: 0.3)
                        : Colors.blue.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  c.isInitialFree ? 'Gratis' : 'Program',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: c.isInitialFree ? Colors.green : Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            c.ticketNumber ?? 'Ticket #${c.id}',
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

  Widget _buildInfoCard(ConsultationModel c) {
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
            'Informasi Pendampingan',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          _buildInfoRow(Iconsax.task_square, 'Subjek', c.subject),
          SizedBox(height: 12.h),
          _buildInfoRow(Iconsax.document_text, 'Deskripsi', c.problemDescription),
          SizedBox(height: 12.h),
          _buildInfoRow(
            Iconsax.calendar,
            'Dibuat',
            DateFormat('dd MMMM yyyy, HH:mm').format(c.createdAt),
          ),
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

  Widget _buildChatButton(int consultationId) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Get.toNamed('/chat', arguments: {
            'id': consultationId,
            'type': 'consultation',
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

  Widget _buildCancelButton(int consultationId) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => _showCancelDialog(consultationId),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          side: BorderSide(color: Colors.red, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        child: Text(
          'Batalkan Pendampingan',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  void _showCancelDialog(int consultationId) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Batalkan Pendampingan?',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Apakah Anda yakin ingin membatalkan pendampingan ini?',
          style: TextStyle(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Tidak', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              final success = await _repository.cancelConsultation(consultationId);
              if (success) {
                Get.back();
                Get.snackbar(
                  'Berhasil',
                  'Pendampingan telah dibatalkan',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              } else {
                Get.snackbar(
                  'Gagal',
                  'Gagal membatalkan pendampingan',
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'waiting':
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
