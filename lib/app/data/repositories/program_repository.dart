import 'package:dio/dio.dart';
import '../models/message_model.dart';
import '../models/program_model.dart';
import '../providers/program_provider.dart';

class ProgramRepository {
  final ProgramProvider _provider = ProgramProvider();

  Future<List<ProgramModel>> getPrograms({int page = 1}) async {
    try {
      final response = await _provider.getPrograms(page: page);

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] as List;
        return data.map((json) => ProgramModel.fromJson(json)).toList();
      }

      return [];
    } on DioException {
      return [];
    }
  }

  Future<ProgramModel?> getProgramDetails(int id) async {
    try {
      final response = await _provider.getProgramDetails(id);

      if (response.data['success'] == true) {
        return ProgramModel.fromJson(response.data['data']);
      }

      return null;
    } on DioException {
      return null;
    }
  }

  Future<ProgramModel?> createProgram({
    required int packageId,
    required int consultantId,
    required String title,
    String? description,
    List<String>? goals,
  }) async {
    try {
      final response = await _provider.createProgram(
        packageId: packageId,
        consultantId: consultantId,
        title: title,
        description: description,
        goals: goals,
      );

      if (response.data['success'] == true) {
        return ProgramModel.fromJson(response.data['data']);
      }

      return null;
    } on DioException {
      rethrow;
    }
  }

  Future<List<MessageModel>> getMessages(int programId) async {
    try {
      final response = await _provider.getMessages(programId);

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] as List;
        return data.map((json) => MessageModel.fromJson(json)).toList();
      }

      return [];
    } on DioException {
      return [];
    }
  }

  Future<MessageModel?> sendMessage(int programId, String content) async {
    try {
      final response = await _provider.sendMessage(programId, content);

      if (response.data['success'] == true) {
        return MessageModel.fromJson(response.data['data']);
      }

      return null;
    } on DioException {
      rethrow;
    }
  }

  Future<bool> completeProgram(int id) async {
    try {
      final response = await _provider.completeProgram(id);
      return response.data['success'] == true;
    } on DioException {
      return false;
    }
  }
}
