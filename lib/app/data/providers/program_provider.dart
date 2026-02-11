import 'package:dio/dio.dart';
import 'package:irtiqa/app/core/api_client.dart';

class ProgramProvider {
  Future<Response> getPrograms({int page = 1}) async {
    return await ApiClient.get(
      '/programs',
      queryParameters: {'page': page},
    );
  }

  Future<Response> getProgramDetails(int id) async {
    return await ApiClient.get('/programs/$id');
  }

  Future<Response> createProgram({
    required int packageId,
    required int consultantId,
    required String title,
    String? description,
    List<String>? goals,
  }) async {
    return await ApiClient.post(
      '/programs',
      data: {
        'package_id': packageId,
        'consultant_id': consultantId,
        'title': title,
        'description': description,
        'goals': goals,
      },
    );
  }

  Future<Response> updateProgram(
    int id, {
    String? title,
    String? description,
    List<String>? goals,
  }) async {
    return await ApiClient.put('/programs/$id', data: {
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (goals != null) 'goals': goals,
    });
  }

  Future<Response> getMessages(int programId) async {
    return await ApiClient.get('/programs/$programId/messages');
  }

  Future<Response> sendMessage(int programId, String content) async {
    return await ApiClient.post(
      '/programs/$programId/messages',
      data: {'content': content},
    );
  }

  Future<Response> completeProgram(int id) async {
    return await ApiClient.post('/programs/$id/complete');
  }
}
