import 'package:dio/dio.dart';
import 'package:irtiqa/app/core/api_client.dart';

class DreamProvider {
  Future<Response> getDreams({int page = 1}) async {
    return await ApiClient.get('/dreams', queryParameters: {'page': page});
  }

  Future<Response> createDream({
    required String title,
    required String content,
    String? emotionalState,
    List<String>? keywords,
    DateTime? dreamDate,
  }) async {
    return await ApiClient.post(
      '/dreams',
      data: {
        'title': title,
        'content': content,
        'emotional_state': emotionalState,
        'keywords': keywords,
        'dream_date': dreamDate?.toIso8601String(),
      },
    );
  }

  Future<Response> getDreamDetails(int id) async {
    return await ApiClient.get('/dreams/$id');
  }

  Future<Response> deleteDream(int id) async {
    return await ApiClient.delete('/dreams/$id');
  }
}
