import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../data/models/app_settings_model.dart';

class RegisterController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  final SettingsRepository _settingsRepository = SettingsRepository();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final acceptTerms = false.obs;
  final Rx<AppSettingsModel?> appSettings = Rx<AppSettingsModel?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final settings = await _settingsRepository.getPublicSettings();
      if (settings != null) {
        appSettings.value = settings;
      } else {
        appSettings.value = _settingsRepository.getCachedSettings();
      }
    } catch (e) {
      appSettings.value = _settingsRepository.getCachedSettings();
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  Future<void> register() async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Kesalahan',
        'Nama wajib diisi',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        'Kesalahan',
        'Email wajib diisi',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar(
        'Kesalahan',
        'Masukkan alamat email yang valid',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (passwordController.text.isEmpty) {
      Get.snackbar(
        'Kesalahan',
        'Kata sandi wajib diisi',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (passwordController.text.length < 8) {
      Get.snackbar(
        'Kesalahan',
        'Kata sandi minimal 8 karakter',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (confirmPasswordController.text.isEmpty) {
      Get.snackbar(
        'Kesalahan',
        'Konfirmasi kata sandi wajib diisi',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Kesalahan',
        'Kata sandi tidak cocok',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (!acceptTerms.value) {
      Get.snackbar(
        'Kesalahan',
        'Harap setujui Syarat & Ketentuan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final result = await _authRepository.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        passwordConfirmation: confirmPasswordController.text,
      );

      if (result['success'] == true) {
        Get.snackbar(
          'Berhasil',
          result['message'] ?? 'Registrasi berhasil',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.offAllNamed('/onboarding');
      } else {
        if (result['errors'] != null) {
          final errors = result['errors'] as Map<String, dynamic>;
          final firstError = errors.values.first;
          final errorMessage = firstError is List
              ? firstError.first
              : firstError;

          Get.snackbar(
            'Kesalahan',
            errorMessage.toString(),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Kesalahan',
            result['message'] ?? 'Registrasi gagal',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Kesalahan',
        'Terjadi kesalahan yang tidak terduga',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void goToLogin() {
    Get.back();
  }
}
