import 'package:dio/dio.dart';
import '../models/educational_content_model.dart';
import '../providers/education_provider.dart';

class EducationRepository {
  final EducationProvider _provider = EducationProvider();

  Future<List<EducationalContentModel>> getContents({
    int page = 1,
    String? category,
    String? search,
  }) async {
    try {
      final response = await _provider.getContents(
        page: page,
        category: category,
        search: search,
      );

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] as List;
        return data
            .map((json) => EducationalContentModel.fromJson(json))
            .toList();
      }

      return [];
    } on DioException {
      return [];
    }
  }

  Future<EducationalContentModel?> getContentDetails(int id) async {
    try {
      final response = await _provider.getContentDetails(id);

      if (response.data['success'] == true) {
        return EducationalContentModel.fromJson(response.data['data']);
      }

      return null;
    } on DioException {
      return null;
    }
  }
}
