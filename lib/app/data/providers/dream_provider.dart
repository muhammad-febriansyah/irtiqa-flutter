import 'package:dio/dio.dart';
import 'package:irtiqa/app/core/api_client.dart';

class DreamProvider {
  Future<Response> getDreams({int page = 1}) async {
    return await ApiClient.get('/dreams', queryParameters: {'page': page});
  }

  Future<Response> createDream({
    required String dreamContent,
    required DateTime dreamDate,
    String? dreamTime,
    String? physicalCondition,
    String? emotionalCondition,
    required bool disclaimerChecked,
  }) async {
    return await ApiClient.post(
      '/dreams',
      data: {
        'dream_content': dreamContent,
        'dream_date': dreamDate.toIso8601String().split('T')[0],
        'dream_time': dreamTime,
        'physical_condition': physicalCondition,
        'emotional_condition': emotionalCondition,
        'disclaimer_checked': disclaimerChecked,
      },
    );
  }

  Future<Response> getDreamDetails(int id) async {
    return await ApiClient.get('/dreams/$id');
  }

  Future<Response> updateDream({
    required int id,
    String? dreamContent,
    DateTime? dreamDate,
    String? dreamTime,
    String? physicalCondition,
    String? emotionalCondition,
  }) async {
    return await ApiClient.put('/dreams/$id', data: {
      if (dreamContent != null) 'dream_content': dreamContent,
      if (dreamDate != null) 'dream_date': dreamDate.toIso8601String().split('T')[0],
      if (dreamTime != null) 'dream_time': dreamTime,
      if (physicalCondition != null) 'physical_condition': physicalCondition,
      if (emotionalCondition != null) 'emotional_condition': emotionalCondition,
    });
  }

  Future<Response> deleteDream(int id) async {
    return await ApiClient.delete('/dreams/$id');
  }
}
