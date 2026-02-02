import 'package:dio/dio.dart';
import 'package:irtiqa/app/core/api_client.dart';

class FaqProvider {
  Future<Response> getFaqs({String? category}) async {
    final queryParams = <String, dynamic>{};

    if (category != null) {
      queryParams['category'] = category;
    }

    return await ApiClient.get('/faqs', queryParameters: queryParams);
  }

  Future<Response> getFaqDetails(int id) async {
    return await ApiClient.get('/faqs/$id');
  }
}
