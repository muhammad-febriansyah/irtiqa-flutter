import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../data/models/app_settings_model.dart';

class SplashController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  final SettingsRepository _settingsRepository = SettingsRepository();

  final Rx<AppSettingsModel?> appSettings = Rx<AppSettingsModel?>(null);
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
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

    // Skip splash delay - langsung check auth
    // await Future.delayed(const Duration(seconds: 2));

    if (_authRepository.isLoggedIn) {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        if (user.profile?.onboardingCompleted == true) {
          Get.offAllNamed('/home');
        } else {
          Get.offAllNamed('/onboarding');
        }
      } else {
        Get.offAllNamed('/welcome');
      }
    } else {
      Get.offAllNamed('/welcome');
    }
  }
}
