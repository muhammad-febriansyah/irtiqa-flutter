import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/repositories/auth_repository.dart';

class AccountController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  final GetStorage _storage = GetStorage();

  final user = Rx<Map<String, dynamic>?>(null);

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() {
    final userData = _storage.read('user_data');
    if (userData != null) {
      user.value = Map<String, dynamic>.from(userData);
    }
  }

  void goToProfile() {
    Get.toNamed('/account/profile/edit');
  }

  void goToSettings() {
    Get.snackbar('Info', 'Halaman Pengaturan akan segera hadir');
  }

  void goToHelp() {
    Get.toNamed('/account/help');
  }

  void goToAbout() {
    Get.toNamed('/account/about');
  }

  void goToPrivacyPolicy() {
    Get.toNamed('/privacy/policy');
  }

  void goToTermsAndConditions() {
    Get.toNamed('/privacy/terms');
  }

  Future<void> logout() async {
    Get.dialog(
      AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          TextButton(
            onPressed: () async {
              Get.back();
              await _authRepository.logout();
              Get.offAllNamed('/login');
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}
