import 'package:dio/dio.dart';
import 'package:irtiqa/app/core/api_client.dart';

class EducationProvider {
  Future<Response> getContents({
    int page = 1,
    String? category,
    String? search,
  }) async {
    final queryParams = <String, dynamic>{'page': page};

    if (category != null) {
      queryParams['category'] = category;
    }

    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    return await ApiClient.get(
      '/educational-contents',
      queryParameters: queryParams,
    );
  }

  Future<Response> getContentDetails(int id) async {
    return await ApiClient.get('/educational-contents/$id');
  }
}
