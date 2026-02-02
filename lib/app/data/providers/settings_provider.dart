import 'package:dio/dio.dart';
import '../../core/api_client.dart';

class SettingsProvider {
  Future<Response> getPublicSettings() async {
    return await ApiClient.get('/settings/public');
  }

  Future<Response> getSettingsByGroup(String group) async {
    return await ApiClient.get('/settings/group/$group');
  }
}
