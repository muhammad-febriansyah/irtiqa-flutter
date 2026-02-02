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

  // Form data
  var birthDate = Rx<DateTime?>(null);
  var pseudonym = ''.obs;
  var province = ''.obs;
  var city = ''.obs;
  var primaryConcern = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Load settings first
    await _loadSettings();

    // Check if user is already logged in
    if (_authRepository.isLoggedIn) {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        if (user.profile?.onboardingCompleted == true) {
          Get.offAllNamed('/home');
          return;
        } else {
          Get.offAllNamed('/onboarding');
          return;
        }
      }
    }

    // If not logged in, stay on welcome/check onboarding status
    checkOnboardingStatus();
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
        final user = storage.read('user');
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

    try {
      isLoading.value = true;

      final response = await ApiClient.post('/onboarding/accept-disclaimer', data: {
        'disclaimer_type': 'onboarding',
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        disclaimerAccepted.value = true;
        nextStep();
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

    try {
      isLoading.value = true;

      final response = await ApiClient.post('/onboarding/verify-age', data: {
        'birth_date': birthDate.value!.toIso8601String().split('T')[0],
      });

      if (response.statusCode == 200) {
        ageVerified.value = true;
        nextStep();
        return true;
      } else if (response.statusCode == 403) {
        Get.snackbar(
          'Maaf',
          response.data['message'] ?? 'Usia Anda belum memenuhi syarat',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 5),
        );
        return false;
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

  /// Complete onboarding
  Future<bool> completeOnboarding() async {
    try {
      isLoading.value = true;

      final response = await ApiClient.post('/onboarding/complete', data: {
        'pseudonym': pseudonym.value.isEmpty ? null : pseudonym.value,
        'province': province.value.isEmpty ? null : province.value,
        'city': city.value.isEmpty ? null : city.value,
        'primary_concern': primaryConcern.value.isEmpty
            ? null
            : primaryConcern.value,
      });

      if (response.statusCode == 200) {
        // Update user data in storage
        final userData = response.data['data']['user'];
        storage.write('user', userData);

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

  void nextStep() {
    if (currentStep.value < 2) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }
}
