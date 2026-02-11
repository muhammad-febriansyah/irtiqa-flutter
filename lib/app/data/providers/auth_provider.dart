import 'package:dio/dio.dart';
import '../../core/api_client.dart';

class AuthProvider {
  Future<Response> register({
    required String name,
    required String email,
    String? phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    return await ApiClient.post('/auth/register', data: {
      'name': name,
      'email': email,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
      'password': password,
      'password_confirmation': passwordConfirmation,
    });
  }

  Future<Response> login({
    required String email,
    required String password,
  }) async {
    return await ApiClient.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
  }

  Future<Response> logout() async {
    return await ApiClient.post('/auth/logout');
  }

  Future<Response> getCurrentUser() async {
    return await ApiClient.get('/auth/me');
  }

  Future<Response> updateProfile({
    String? name,
    String? email,
  }) async {
    return await ApiClient.put('/auth/profile', data: {
      if (name != null) 'name': name,
      if (email != null) 'email': email,
    });
  }

  Future<Response> changePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  }) async {
    return await ApiClient.put('/auth/password', data: {
      'current_password': currentPassword,
      'password': password,
      'password_confirmation': passwordConfirmation,
    });
  }

  Future<Response> forgotPassword({required String email}) async {
    return await ApiClient.post('/auth/forgot-password', data: {
      'email': email,
    });
  }

  Future<Response> resetPassword({
    required String token,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    return await ApiClient.post('/auth/reset-password', data: {
      'token': token,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
    });
  }

  /// Send OTP for verification
  Future<Response> sendOtp({
    required String email,
    String type = 'email',
    String purpose = 'registration',
  }) async {
    return await ApiClient.post('/auth/otp/send', data: {
      'email': email,
      'type': type,
      'purpose': purpose,
    });
  }

  /// Verify OTP code
  Future<Response> verifyOtp({
    required String email,
    required String otpCode,
    String purpose = 'registration',
  }) async {
    return await ApiClient.post('/auth/otp/verify', data: {
      'email': email,
      'otp_code': otpCode,
      'purpose': purpose,
    });
  }
}
