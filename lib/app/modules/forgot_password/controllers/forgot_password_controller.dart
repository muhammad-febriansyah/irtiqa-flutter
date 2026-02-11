import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';

class ForgotPasswordController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final identifierController = TextEditingController();
  final selectedMethod = 'email'.obs;
  final isLoading = false.obs;

  @override
  void onClose() {
    identifierController.dispose();
    super.onClose();
  }

  Future<void> sendResetCode() async {
    // Validation
    if (identifierController.text.trim().isEmpty) {
      Get.snackbar(
        'Perhatian',
        'Silakan masukkan email atau nomor WhatsApp',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return;
    }

    isLoading.value = true;

    try {
      final result = await _authRepository.requestPasswordReset(
        identifier: identifierController.text.trim(),
        type: selectedMethod.value,
      );

      if (result['success'] == true) {
        Get.snackbar(
          'Berhasil',
          result['message'] ?? 'Kode OTP telah dikirim',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigate to OTP verification for password reset
        final otpResult = await Get.toNamed(
          '/otp-verification',
          arguments: {
            'email': identifierController.text.trim(),
            'purpose': 'forgot_password',
            'type': selectedMethod.value,
          },
        );

        // If OTP verified, navigate to reset password page
        if (otpResult == true) {
          // Navigate to reset password page (will be created)
          await _showResetPasswordDialog();
        }
      } else {
        Get.snackbar(
          'Gagal',
          result['message'] ?? 'Gagal mengirim kode OTP',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _showResetPasswordDialog() async {
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final isPasswordVisible = false.obs;
    final isConfirmPasswordVisible = false.obs;

    await Get.dialog(
      AlertDialog(
        title: const Text('Reset Kata Sandi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(
              () => TextField(
                controller: newPasswordController,
                obscureText: !isPasswordVisible.value,
                decoration: InputDecoration(
                  labelText: 'Kata Sandi Baru',
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () =>
                        isPasswordVisible.value = !isPasswordVisible.value,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => TextField(
                controller: confirmPasswordController,
                obscureText: !isConfirmPasswordVisible.value,
                decoration: InputDecoration(
                  labelText: 'Konfirmasi Kata Sandi',
                  suffixIcon: IconButton(
                    icon: Icon(
                      isConfirmPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () => isConfirmPasswordVisible.value =
                        !isConfirmPasswordVisible.value,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              if (newPasswordController.text.isEmpty ||
                  confirmPasswordController.text.isEmpty) {
                Get.snackbar(
                  'Perhatian',
                  'Silakan isi semua field',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }

              if (newPasswordController.text !=
                  confirmPasswordController.text) {
                Get.snackbar(
                  'Perhatian',
                  'Kata sandi tidak cocok',
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }

              Get.back(); // Close dialog
              await _resetPassword(newPasswordController.text);
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    newPasswordController.dispose();
    confirmPasswordController.dispose();
  }

  Future<void> _resetPassword(String newPassword) async {
    isLoading.value = true;

    try {
      final result = await _authRepository.resetPassword(
        email: identifierController.text.trim(),
        password: newPassword,
      );

      if (result['success'] == true) {
        Get.snackbar(
          'Berhasil',
          'Kata sandi berhasil direset. Silakan login dengan kata sandi baru.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        // Navigate to login
        await Future.delayed(const Duration(seconds: 1));
        Get.offAllNamed('/login');
      } else {
        Get.snackbar(
          'Gagal',
          result['message'] ?? 'Gagal mereset kata sandi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
