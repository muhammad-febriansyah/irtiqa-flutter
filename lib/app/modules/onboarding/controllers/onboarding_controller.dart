import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:irtiqa/app/data/models/user_model.dart';
import 'package:irtiqa/app/core/api_client.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/models/app_settings_model.dart';

class OnboardingController extends GetxController {
  final storage = GetStorage();
  final SettingsRepository _settingsRepository = SettingsRepository();
  final AuthRepository _authRepository = AuthRepository();

  // Observable states
  var currentStep = 0.obs;
  var isLoading = false.obs;
  var disclaimerAccepted = false.obs;
  var ageVerified = false.obs;
  final Rx<AppSettingsModel?> appSettings = Rx<AppSettingsModel?>(null);

  // Disclaimer checklist
  var understandNotGhaib = false.obs;
  var understandNotMedical = false.obs;
  var willingToFollowProcess = false.obs;

  bool get canAcceptDisclaimer =>
      understandNotGhaib.value &&
      understandNotMedical.value &&
      willingToFollowProcess.value;

  // Register form data
  var registerName = ''.obs;
  var registerEmail = ''.obs;
  var registerPhone = ''.obs;
  var registerGender = 'prefer_not_to_say'.obs;
  var registerPassword = ''.obs;
  var registerPasswordConfirm = ''.obs;
  var registerPasswordVisible = false.obs;
  var acceptTerms = false.obs;

  // Form data
  var birthDate = Rx<DateTime?>(null);
  var pseudonym = ''.obs;
  var province = ''.obs;
  var city = ''.obs;
  var primaryConcern = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Reset ke step 0
    currentStep.value = 0;

    // Load settings saja
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSettings();
    });
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

  /// Check if user has completed onboarding
  Future<void> checkOnboardingStatus() async {
    try {
      final response = await ApiClient.get('/onboarding/disclaimer-status');

      if (response.statusCode == 200) {
        final data = response.data['data'];
        disclaimerAccepted.value = data['status']['onboarding'] ?? false;

        // If already completed, skip to home
        final user = storage.read('user_data'); // Fix: gunakan 'user_data'
        if (user != null) {
          final userModel = UserModel.fromJson(user);
          if (userModel.profile?.onboardingCompleted == true) {
            Get.offAllNamed('/bottomnavigator');
          }
        }
      }
    } catch (e) {
      // Error checking onboarding status: $e
    }
  }

  /// Accept disclaimer
  Future<bool> acceptDisclaimer() async {
    if (!canAcceptDisclaimer) {
      Get.snackbar(
        'Perhatian',
        'Silakan centang semua poin kesepahaman untuk melanjutkan',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    // No API call needed for unauthenticated users
    // Just mark as accepted and continue
    disclaimerAccepted.value = true;
    nextStep();
    return true;
  }

  /// Verify age
  Future<bool> verifyAge() async {
    if (birthDate.value == null) {
      Get.snackbar(
        'Perhatian',
        'Silakan pilih tanggal lahir Anda',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    // Calculate age
    final now = DateTime.now();
    final age = now.year - birthDate.value!.year;
    final hasHadBirthdayThisYear =
        now.month > birthDate.value!.month ||
        (now.month == birthDate.value!.month &&
            now.day >= birthDate.value!.day);
    final actualAge = hasHadBirthdayThisYear ? age : age - 1;

    // Check minimum age (17 years)
    if (actualAge < 17) {
      Get.snackbar(
        'Maaf',
        'Layanan ini hanya untuk pengguna berusia minimal 17 tahun',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );
      return false;
    }

    // Age verified, continue to next step
    ageVerified.value = true;
    nextStep();
    return true;
  }

  /// Complete onboarding
  Future<bool> completeOnboarding() async {
    try {
      isLoading.value = true;

      final response = await ApiClient.post(
        '/onboarding/complete',
        data: {
          'pseudonym': pseudonym.value.isEmpty ? null : pseudonym.value,
          'province': province.value.isEmpty ? null : province.value,
          'city': city.value.isEmpty ? null : city.value,
          'primary_concern': primaryConcern.value.isEmpty
              ? null
              : primaryConcern.value,
        },
      );

      if (response.statusCode == 200) {
        // Update user data in storage
        final userData = response.data['data']['user'];
        storage.write('user_data', userData); // Fix: gunakan 'user_data'

        Get.snackbar(
          'Selamat Datang!',
          'Selamat datang di IRTIQA. Semoga perjalanan Anda membawa ketenangan.',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3),
        );

        // Navigate to home
        await Future.delayed(Duration(seconds: 1));
        Get.offAllNamed('/bottomnavigator');
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

  /// Register and continue to next step
  Future<bool> registerAndContinue() async {
    // Validation
    if (registerName.value.trim().isEmpty) {
      Get.snackbar(
        'Perhatian',
        'Nama wajib diisi',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (registerEmail.value.trim().isEmpty) {
      Get.snackbar(
        'Perhatian',
        'Email wajib diisi',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (!GetUtils.isEmail(registerEmail.value.trim())) {
      Get.snackbar(
        'Perhatian',
        'Format email tidak valid',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    // Validate phone number (optional but if filled must be valid)
    if (registerPhone.value.trim().isNotEmpty) {
      final phone = registerPhone.value.trim();
      // Check if phone starts with 08 or +62 and has 10-15 digits
      if (!RegExp(r'^(08|\+62)[0-9]{8,13}$').hasMatch(phone)) {
        Get.snackbar(
          'Perhatian',
          'Format nomor WhatsApp tidak valid. Contoh: 081234567890 atau +6281234567890',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 4),
        );
        return false;
      }
    }

    if (registerPassword.value.length < 8) {
      Get.snackbar(
        'Perhatian',
        'Kata sandi minimal 8 karakter',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (registerPassword.value != registerPasswordConfirm.value) {
      Get.snackbar(
        'Perhatian',
        'Konfirmasi kata sandi tidak cocok',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (!acceptTerms.value) {
      Get.snackbar(
        'Perhatian',
        'Harap setujui Syarat & Ketentuan',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    try {
      isLoading.value = true;

      final response = await ApiClient.post(
        '/auth/register',
        data: {
          'name': registerName.value.trim(),
          'email': registerEmail.value.trim(),
          'phone': registerPhone.value.trim().isEmpty
              ? null
              : registerPhone.value.trim(),
          'password': registerPassword.value,
          'password_confirmation': registerPasswordConfirm.value,
          // Add required fields from previous steps
          'birth_date': birthDate.value != null
              ? birthDate.value!.toIso8601String().split('T')[0]
              : null,
          'gender': registerGender.value,
          'province': province.value.isEmpty ? null : province.value,
          'city': city.value.isEmpty ? null : city.value,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Debug: Print full response
        print('=== REGISTER RESPONSE ===');
        print('Status: ${response.statusCode}');
        print('Data: ${response.data}');

        final data = response.data['data'];
        final email = data['email'];
        final otpSent = data['otp_sent'] ?? false;

        print('Email: $email');
        print('OTP Sent: $otpSent');
        print('========================');

        if (otpSent) {
          Get.snackbar(
            'Berhasil',
            'Registrasi berhasil! Silakan cek email untuk kode OTP.',
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 3),
          );

          // Navigate to OTP verification
          final result = await Get.toNamed(
            '/otp-verification',
            arguments: {'email': email, 'purpose': 'registration'},
          );

          // If OTP verified successfully, continue to onboarding
          if (result == true) {
            nextStep();
          }
          return result == true;
        } else {
          Get.snackbar(
            'Peringatan',
            'Registrasi berhasil tapi OTP gagal dikirim. Silakan hubungi admin.',
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 5),
          );
          return false;
        }
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

  void nextStep() {
    if (currentStep.value < 3) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }
}
