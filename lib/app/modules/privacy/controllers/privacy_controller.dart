import 'package:get/get.dart';
import 'package:irtiqa/app/core/api_client.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/models/privacy_policy_model.dart';

class PrivacyController extends GetxController {
  final storage = GetStorage();

  var isLoading = false.obs;
  final Rx<PrivacyPolicyModel?> privacyPolicy = Rx<PrivacyPolicyModel?>(null);
  final Rx<PrivacyPolicyModel?> termsAndConditions = Rx<PrivacyPolicyModel?>(
    null,
  );
  var dataRetentionInfo = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadPrivacyPolicy();
    loadTermsAndConditions();
    loadDataRetentionInfo();
  }

  /// Load privacy policy
  Future<void> loadPrivacyPolicy() async {
    try {
      isLoading.value = true;
      final response = await ApiClient.get('/privacy/policy');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final policyData = response.data['data'];
        privacyPolicy.value = PrivacyPolicyModel.fromJson(policyData);
      }
    } catch (e) {
      // Error loading privacy policy: $e
    } finally {
      isLoading.value = false;
    }
  }

  /// Load terms and conditions
  Future<void> loadTermsAndConditions() async {
    try {
      isLoading.value = true;
      final response = await ApiClient.get('/privacy/terms');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final termsData = response.data['data'];
        termsAndConditions.value = PrivacyPolicyModel.fromJson(termsData);
      }
    } catch (e) {
      // Error loading terms: $e
    } finally {
      isLoading.value = false;
    }
  }

  /// Load data retention info
  Future<void> loadDataRetentionInfo() async {
    try {
      final response = await ApiClient.get('/privacy/retention-info');

      if (response.statusCode == 200) {
        dataRetentionInfo.value = response.data['data'];
      }
    } catch (e) {
      // Error loading retention info: $e
    }
  }

  /// Export user data
  Future<void> exportMyData() async {
    try {
      isLoading.value = true;

      final response = await ApiClient.get('/privacy/my-data');

      if (response.statusCode == 200) {
        Get.snackbar(
          'Berhasil',
          'Data Anda telah disiapkan. Silakan unduh dari link yang dikirim ke email.',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 5),
        );
      } else {
        Get.snackbar(
          'Gagal',
          response.data['message'] ?? 'Terjadi kesalahan',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Tidak dapat terhubung ke server',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete account
  Future<bool> deleteAccount(String password) async {
    try {
      isLoading.value = true;

      final response = await ApiClient.delete(
        '/privacy/delete-account',
        data: {'password': password},
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          'Akun Dihapus',
          'Akun Anda telah dihapus. Terima kasih telah menggunakan IRTIQA.',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 5),
        );

        // Clear storage and logout
        storage.erase();
        await Future.delayed(Duration(seconds: 2));
        Get.offAllNamed('/login');
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
}
