import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';
import '../../core/api_client.dart';

class AuthRepository {
  final AuthProvider _authProvider = AuthProvider();
  final GetStorage _storage = GetStorage();

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _authProvider.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      if (response.data['success'] == true) {
        final token = response.data['data']['token'];
        final user = UserModel.fromJson(response.data['data']['user']);

        ApiClient.saveToken(token);
        _storage.write('user_data', response.data['data']['user']);

        return {
          'success': true,
          'user': user,
          'message': response.data['message'],
        };
      }

      return {
        'success': false,
        'message': response.data['message'] ?? 'Registration failed',
      };
    } on DioException catch (e) {
      String errorMessage = 'Terjadi kesalahan jaringan';

      if (e.response?.data != null) {
        final responseData = e.response!.data;

        if (responseData['message'] != null) {
          final message = responseData['message'].toString();

          if (message.contains('credentials are incorrect') ||
              message.contains('provided credentials')) {
            errorMessage = 'Email atau kata sandi yang Anda masukkan salah';
          } else if (message.contains('validation')) {
            errorMessage = 'Data yang Anda masukkan tidak valid';
          } else if (message.contains('already exists') ||
              message.contains('has already been taken')) {
            errorMessage = 'Email sudah terdaftar';
          } else {
            errorMessage = message;
          }
        }
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Koneksi timeout. Silakan coba lagi';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage =
            'Tidak dapat terhubung ke server. Periksa koneksi internet Anda';
      }

      return {
        'success': false,
        'message': errorMessage,
        'errors': e.response?.data['errors'],
      };
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authProvider.login(
        email: email,
        password: password,
      );

      if (response.data['success'] == true) {
        final token = response.data['data']['token'];
        final user = UserModel.fromJson(response.data['data']['user']);

        ApiClient.saveToken(token);
        _storage.write('user_data', response.data['data']['user']);

        return {
          'success': true,
          'user': user,
          'message': response.data['message'],
        };
      }

      return {
        'success': false,
        'message': response.data['message'] ?? 'Login failed',
      };
    } on DioException catch (e) {
      String errorMessage = 'Terjadi kesalahan jaringan';

      if (e.response?.data != null) {
        final responseData = e.response!.data;

        if (responseData['message'] != null) {
          final message = responseData['message'].toString();

          if (message.contains('credentials are incorrect') ||
              message.contains('provided credentials')) {
            errorMessage = 'Email atau kata sandi yang Anda masukkan salah';
          } else if (message.contains('validation')) {
            errorMessage = 'Data yang Anda masukkan tidak valid';
          } else if (message.contains('Unauthenticated')) {
            errorMessage = 'Sesi Anda telah berakhir';
          } else {
            errorMessage = message;
          }
        }
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Koneksi timeout. Silakan coba lagi';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage =
            'Tidak dapat terhubung ke server. Periksa koneksi internet Anda';
      }

      return {
        'success': false,
        'message': errorMessage,
        'errors': e.response?.data['errors'],
      };
    }
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      await _authProvider.logout();

      ApiClient.removeToken();
      _storage.remove('user_data');

      return {'success': true, 'message': 'Logged out successfully'};
    } on DioException {
      ApiClient.removeToken();
      _storage.remove('user_data');

      return {'success': true, 'message': 'Logged out'};
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final userData = _storage.read('user_data');
      if (userData != null) {
        return UserModel.fromJson(userData);
      }

      final response = await _authProvider.getCurrentUser();
      if (response.data['success'] == true) {
        final user = UserModel.fromJson(response.data['data']);
        _storage.write('user_data', response.data['data']);
        return user;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  bool get isLoggedIn => ApiClient.isAuthenticated;
}
