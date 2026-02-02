import 'package:dio/dio.dart';
import '../models/dream_model.dart';
import '../providers/dream_provider.dart';

class DreamRepository {
  final DreamProvider _provider = DreamProvider();

  Future<List<DreamModel>> getDreams({int page = 1}) async {
    try {
      final response = await _provider.getDreams(page: page);

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] as List;
        return data.map((json) => DreamModel.fromJson(json)).toList();
      }

      return [];
    } on DioException {
      return [];
    }
  }

  Future<DreamModel?> createDream({
    required String title,
    required String content,
    String? emotionalState,
    List<String>? keywords,
    DateTime? dreamDate,
  }) async {
    try {
      final response = await _provider.createDream(
        title: title,
        content: content,
        emotionalState: emotionalState,
        keywords: keywords,
        dreamDate: dreamDate,
      );

      if (response.data['success'] == true) {
        return DreamModel.fromJson(response.data['data']);
      }

      return null;
    } on DioException {
      rethrow;
    }
  }

  Future<DreamModel?> getDreamDetails(int id) async {
    try {
      final response = await _provider.getDreamDetails(id);

      if (response.data['success'] == true) {
        return DreamModel.fromJson(response.data['data']);
      }

      return null;
    } on DioException {
      return null;
    }
  }

  Future<bool> deleteDream(int id) async {
    try {
      final response = await _provider.deleteDream(id);
      return response.data['success'] == true;
    } on DioException {
      return false;
    }
  }
}
