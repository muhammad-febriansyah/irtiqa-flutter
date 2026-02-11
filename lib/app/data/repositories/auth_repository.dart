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
    String? phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _authProvider.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      if (response.data['success'] == true) {
        // Don't save token yet - user needs to verify email first
        return {
          'success': true,
          'email': response.data['data']['email'],
          'otp_sent': response.data['data']['otp_sent'] ?? false,
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

        // Check for EMAIL_NOT_VERIFIED error
        if (responseData['error_code'] == 'EMAIL_NOT_VERIFIED') {
          return {
            'success': false,
            'error_code': 'EMAIL_NOT_VERIFIED',
            'message': responseData['message'],
            'email': responseData['data']?['email'],
            'otp_sent': responseData['data']?['otp_sent'] ?? false,
          };
        }

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

  /// Send OTP for email verification
  Future<Map<String, dynamic>> sendOtp({
    required String email,
    String type = 'email',
    String purpose = 'registration',
  }) async {
    try {
      final response = await _authProvider.sendOtp(
        email: email,
        type: type,
        purpose: purpose,
      );

      return {
        'success': response.data['success'] ?? false,
        'message': response.data['message'],
        'expires_at': response.data['expires_at'],
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'Gagal mengirim OTP',
      };
    }
  }

  /// Verify OTP code
  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otpCode,
    String purpose = 'registration',
  }) async {
    try {
      final response = await _authProvider.verifyOtp(
        email: email,
        otpCode: otpCode,
        purpose: purpose,
      );

      return response.data;
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'Verifikasi OTP gagal',
      };
    }
  }

  /// Save user data and token (helper method)
  Future<void> saveUserData(Map<String, dynamic> user, String token) async {
    ApiClient.saveToken(token);
    _storage.write('user_data', user);
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

  /// Request password reset - send OTP
  Future<Map<String, dynamic>> requestPasswordReset({
    required String identifier,
    required String type, // 'email' or 'whatsapp'
  }) async {
    try {
      final response = await ApiClient.post(
        '/auth/send-otp',
        data: {'email': identifier, 'type': type, 'purpose': 'forgot_password'},
      );

      return {
        'success': response.statusCode == 200,
        'message': response.data['message'],
        'data': response.data['data'],
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'Gagal mengirim kode OTP',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  /// Reset password with new password (after OTP verification)
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await ApiClient.post(
        '/auth/reset-password',
        data: {
          'email': email,
          'password': password,
          'password_confirmation': password,
        },
      );

      return {
        'success': response.statusCode == 200,
        'message': response.data['message'],
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'Gagal mereset kata sandi',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }

  bool get isLoggedIn => ApiClient.isAuthenticated;
}
