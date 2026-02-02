import 'package:irtiqa/app/core/api_client.dart';

class PackageProvider {
  /// Get all active packages
  Future<Map<String, dynamic>> getPackages() async {
    try {
      final response = await ApiClient.get('/packages');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  /// Get package detail by ID
  Future<Map<String, dynamic>> getPackageDetail(int id) async {
    try {
      final response = await ApiClient.get('/packages/$id');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }
}
