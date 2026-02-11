import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../data/models/app_settings_model.dart';

class LoginController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  final SettingsRepository _settingsRepository = SettingsRepository();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final Rx<AppSettingsModel?> appSettings = Rx<AppSettingsModel?>(null);

  @override
  void onInit() {
    super.onInit();
    // Defer navigation to after build phase to avoid setState during build error
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_authRepository.isLoggedIn) {
        Get.offAllNamed('/home');
      }
    });
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
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    if (emailController.text.isEmpty) {
      Get.snackbar(
        'Kesalahan',
        'Email wajib diisi',
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

    isLoading.value = true;

    try {
      final result = await _authRepository.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (result['success'] == true) {
        Get.snackbar(
          'Berhasil',
          result['message'] ?? 'Login berhasil',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        final user = await _authRepository.getCurrentUser();

        // Check if onboarding is completed
        if (user?.profile?.onboardingCompleted != true) {
          Get.offAllNamed('/onboarding');
          return;
        }

        // Role-based redirect
        final roles = user?.roles ?? [];

        if (roles.contains('admin')) {
          // Admin users go to admin dashboard
          Get.offAllNamed('/admin/dashboard');
        } else if (roles.contains('consultant') || roles.contains('kyai')) {
          // Consultant/Kyai users go to consultant dashboard
          Get.offAllNamed('/consultant/dashboard');
        } else {
          // Regular users go to home
          Get.offAllNamed('/home');
        }
      } else if (result['error_code'] == 'EMAIL_NOT_VERIFIED') {
        // Email not verified — navigate to OTP verification page
        Get.toNamed(
          '/otp-verification',
          arguments: {
            'email': result['email'] ?? emailController.text.trim(),
            'purpose': 'registration',
          },
        );
      } else {
        Get.snackbar(
          'Kesalahan',
          result['message'] ?? 'Login gagal',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
          margin: EdgeInsets.all(16.w),
          borderRadius: 12.r,
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Kesalahan',
        'Terjadi kesalahan yang tidak terduga',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        margin: EdgeInsets.all(16.w),
        borderRadius: 12.r,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void goToRegister() {
    Get.toNamed('/register');
  }

  void goToForgotPassword() {
    Get.toNamed('/forgot-password');
  }
}
