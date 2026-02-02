import 'package:get/get.dart';
import 'package:irtiqa/app/core/api_client.dart';
import 'package:dio/dio.dart' as dio;

class ConsultantApplicationController extends GetxController {
  var isLoading = false.obs;
  var myApplications = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMyApplications();
  }

  /// Load user's applications
  Future<void> loadMyApplications() async {
    try {
      isLoading.value = true;

      final response = await ApiClient.get(
        '/consultant-applications/my-applications',
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        myApplications.value = List<Map<String, dynamic>>.from(data ?? []);
      }
    } catch (e) {
      // Error loading applications: $e
    } finally {
      isLoading.value = false;
    }
  }

  /// Submit application
  Future<bool> submitApplication({
    required String fullName,
    required String phone,
    required String certificationType,
    required String certificationNumber,
    required String institution,
    required int experienceYears,
    required String specialization,
    required String motivation,
    String? certificationFile,
  }) async {
    try {
      isLoading.value = true;

      // Prepare form data
      final formData = dio.FormData.fromMap({
        'full_name': fullName,
        'phone': phone,
        'certification_type': certificationType,
        'certification_number': certificationNumber,
        'institution': institution,
        'experience_years': experienceYears,
        'specialization': specialization,
        'motivation': motivation,
      });

      // Add file if provided
      if (certificationFile != null) {
        formData.files.add(
          MapEntry(
            'certification_file',
            await dio.MultipartFile.fromFile(certificationFile),
          ),
        );
      }

      final response = await ApiClient.post(
        '/consultant-applications',
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Berhasil',
          'Aplikasi berhasil dikirim. Tim kami akan meninjau dalam 3-5 hari kerja.',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 5),
        );
        loadMyApplications();
        return true;
      } else {
        Get.snackbar(
          'Gagal',
          response.data['message'] ?? 'Terjadi kesalahan',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Tidak dapat terhubung ke server',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Get status label
  String getStatusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Menunggu Review';
      case 'approved':
        return 'Disetujui';
      case 'rejected':
        return 'Ditolak';
      default:
        return 'Tidak Diketahui';
    }
  }

  /// Get status color
  String getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return 'warning';
      case 'approved':
        return 'success';
      case 'rejected':
        return 'error';
      default:
        return 'info';
    }
  }
}
