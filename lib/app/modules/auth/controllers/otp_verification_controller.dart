import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';

class OtpVerificationController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  final otpController = TextEditingController();

  final email = ''.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final countdown = 60.obs;
  final canResend = false.obs;

  Timer? _timer;

  final purpose = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Get email and purpose from arguments
    final args = Get.arguments ?? {};
    email.value = args['email'] ?? '';
    purpose.value = args['purpose'] ?? 'registration';
    startCountdown();
  }

  @override
  void onClose() {
    otpController.dispose();
    _timer?.cancel();
    super.onClose();
  }

  /// Start countdown timer for resend OTP
  void startCountdown() {
    canResend.value = false;
    countdown.value = 60;

    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  /// Verify OTP
  Future<void> verifyOtp() async {
    if (otpController.text.length < 6) {
      errorMessage.value = 'Kode OTP harus 6 digit';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _authRepository.verifyOtp(
        email: email.value,
        otpCode: otpController.text,
        purpose: purpose.value,
      );

      isLoading.value = false;

      if (result['success'] == true) {
        // Save user data and token
        final user = result['data']['user'];
        final token = result['data']['token'];

        // Save to storage (handled by auth repository)
        await _authRepository.saveUserData(user, token);

        // Show success message
        Get.snackbar(
          'Berhasil',
          'Email berhasil diverifikasi!',
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          colorText: Colors.green,
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.all(16),
          borderRadius: 12,
        );

        // Return to previous page (onboarding) with success result
        await Future.delayed(Duration(milliseconds: 500));
        Get.back(result: true);
      } else {
        errorMessage.value = result['message'] ?? 'Verifikasi OTP gagal';
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Terjadi kesalahan. Silakan coba lagi.';
    }
  }

  /// Resend OTP
  Future<void> resendOtp({String type = 'email'}) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _authRepository.sendOtp(
        email: email.value,
        type: type,
        purpose: purpose.value,
      );

      isLoading.value = false;

      if (result['success'] == true) {
        // Clear OTP input
        otpController.clear();

        // Restart countdown
        startCountdown();

        final channel = type == 'whatsapp' ? 'WhatsApp' : 'email';
        Get.snackbar(
          'Berhasil',
          'Kode OTP baru telah dikirim ke $channel Anda',
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          colorText: Colors.green,
          snackPosition: SnackPosition.TOP,
          margin: EdgeInsets.all(16),
          borderRadius: 12,
        );
      } else {
        errorMessage.value =
            result['message'] ?? 'Gagal mengirim ulang OTP';
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'Terjadi kesalahan. Silakan coba lagi.';
    }
  }
}
