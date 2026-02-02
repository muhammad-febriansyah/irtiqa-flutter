import 'package:irtiqa/app/data/models/package_model.dart';
import 'package:irtiqa/app/data/providers/package_provider.dart';

class PackageRepository {
  final PackageProvider _provider = PackageProvider();

  Future<List<PackageModel>> getPackages() async {
    try {
      final response = await _provider.getPackages();

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> data = response['data'];
        return data.map((json) => PackageModel.fromJson(json)).toList();
      }

      throw Exception('Failed to load packages');
    } catch (e) {
      rethrow;
    }
  }

  Future<PackageModel> getPackageDetail(int id) async {
    try {
      final response = await _provider.getPackageDetail(id);

      if (response['success'] == true && response['data'] != null) {
        return PackageModel.fromJson(response['data']);
      }

      throw Exception('Failed to load package detail');
    } catch (e) {
      rethrow;
    }
  }
}
