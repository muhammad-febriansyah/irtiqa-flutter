import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../models/app_settings_model.dart';
import '../providers/settings_provider.dart';

class SettingsRepository {
  final SettingsProvider _settingsProvider = SettingsProvider();
  late final GetStorage _storage;

  SettingsRepository() {
    _storage = GetStorage();
  }

  Future<AppSettingsModel?> getPublicSettings() async {
    try {
      final response = await _settingsProvider.getPublicSettings();

      if (response.data['success'] == true) {
        final settings = AppSettingsModel.fromJson(response.data['data']);

        try {
          await _storage.write('app_settings', response.data['data']);
        } catch (_) {
        }

        return settings;
      }

      return null;
    } on DioException {
      return getCachedSettings();
    } catch (e) {
      return getCachedSettings();
    }
  }

  AppSettingsModel? getCachedSettings() {
    try {
      final cachedData = _storage.read('app_settings');
      if (cachedData != null) {
        return AppSettingsModel.fromJson(cachedData);
      }
    } catch (_) {
    }
    return null;
  }
}
