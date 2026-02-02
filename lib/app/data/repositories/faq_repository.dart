import 'package:dio/dio.dart';
import '../models/faq_model.dart';
import '../providers/faq_provider.dart';

class FaqRepository {
  final FaqProvider _provider = FaqProvider();

  Future<List<FaqModel>> getFaqs({String? category}) async {
    try {
      final response = await _provider.getFaqs(category: category);

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] as List;
        return data.map((json) => FaqModel.fromJson(json)).toList();
      }

      return [];
    } on DioException {
      return [];
    }
  }

  Future<FaqModel?> getFaqDetails(int id) async {
    try {
      final response = await _provider.getFaqDetails(id);

      if (response.data['success'] == true) {
        return FaqModel.fromJson(response.data['data']);
      }

      return null;
    } on DioException {
      return null;
    }
  }
}
