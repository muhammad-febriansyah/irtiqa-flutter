import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../models/consultant_profile_model.dart';
import '../models/consultation_category_model.dart';
import '../models/user_model.dart';
import '../../core/api_client.dart';

class ConsultantProfileRepository {
  /// Get consultant profile data
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await ApiClient.get('/consultant/profile');

      if (response.data['success'] == true) {
        final data = response.data['data'];

        return {
          'success': true,
          'consultant': ConsultantProfileModel.fromJson(data['consultant']),
          'user': UserModel.fromJson(data['user']),
          'selectedCategories': List<int>.from(
            data['selected_categories'] ?? [],
          ),
        };
      }

      return {
        'success': false,
        'message': response.data['message'] ?? 'Gagal mengambil data profil',
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'Terjadi kesalahan jaringan',
      };
    }
  }

  /// Update consultant profile
  Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? bio,
    String? certification,
    String? city,
    String? province,
  }) async {
    try {
      final response = await ApiClient.put(
        '/consultant/profile',
        data: {
          if (name != null) 'name': name,
          if (bio != null) 'bio': bio,
          if (certification != null) 'certification': certification,
          if (city != null) 'city': city,
          if (province != null) 'province': province,
        },
      );

      if (response.data['success'] == true) {
        return {
          'success': true,
          'message': response.data['message'] ?? 'Profil berhasil diperbarui',
          'data': response.data['data'],
        };
      }

      return {
        'success': false,
        'message': response.data['message'] ?? 'Gagal memperbarui profil',
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'Terjadi kesalahan jaringan',
        'errors': e.response?.data['errors'],
      };
    }
  }

  /// Update consultant avatar
  Future<Map<String, dynamic>> updateAvatar(XFile imageFile) async {
    try {
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.name,
        ),
      });

      final response = await ApiClient.post(
        '/consultant/profile/avatar',
        data: formData,
      );

      if (response.data['success'] == true) {
        return {
          'success': true,
          'message': response.data['message'] ?? 'Avatar berhasil diperbarui',
          'avatar': response.data['data']['avatar'],
          'avatarUrl': response.data['data']['avatar_url'],
        };
      }

      return {
        'success': false,
        'message': response.data['message'] ?? 'Gagal memperbarui avatar',
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'Terjadi kesalahan jaringan',
        'errors': e.response?.data['errors'],
      };
    }
  }

  /// Update consultant specializations
  Future<Map<String, dynamic>> updateSpecializations(
    List<int> categoryIds,
  ) async {
    try {
      final response = await ApiClient.put(
        '/consultant/profile/specializations',
        data: {'categories': categoryIds},
      );

      if (response.data['success'] == true) {
        return {
          'success': true,
          'message':
              response.data['message'] ?? 'Spesialisasi berhasil diperbarui',
          'specialization': response.data['data']['specialization'],
        };
      }

      return {
        'success': false,
        'message': response.data['message'] ?? 'Gagal memperbarui spesialisasi',
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'Terjadi kesalahan jaringan',
        'errors': e.response?.data['errors'],
      };
    }
  }

  /// Get all consultation categories
  Future<Map<String, dynamic>> getCategories() async {
    try {
      final response = await ApiClient.get('/consultant/profile/categories');

      if (response.data['success'] == true) {
        final categories = (response.data['data'] as List)
            .map((json) => ConsultationCategoryModel.fromJson(json))
            .toList();

        return {'success': true, 'categories': categories};
      }

      return {
        'success': false,
        'message': response.data['message'] ?? 'Gagal mengambil kategori',
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'Terjadi kesalahan jaringan',
      };
    }
  }
}
