import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/consultant_profile_model.dart';
import '../../../data/models/consultation_category_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/consultant_profile_repository.dart';
import '../../../core/app_colors.dart';

class ConsultantProfileController extends GetxController {
  final ConsultantProfileRepository _repository = ConsultantProfileRepository();
  final ImagePicker _imagePicker = ImagePicker();

  // Observable state
  final isLoading = false.obs;
  final isSaving = false.obs;
  final consultant = Rx<ConsultantProfileModel?>(null);
  final user = Rx<UserModel?>(null);
  final categories = <ConsultationCategoryModel>[].obs;
  final selectedCategoryIds = <int>[].obs;

  // Form controllers
  final nameController = TextEditingController();
  final bioController = TextEditingController();
  final certificationController = TextEditingController();
  final cityController = TextEditingController();
  final provinceController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
    loadCategories();
  }

  @override
  void onClose() {
    nameController.dispose();
    bioController.dispose();
    certificationController.dispose();
    cityController.dispose();
    provinceController.dispose();
    super.onClose();
  }

  /// Load consultant profile data
  Future<void> loadProfile() async {
    isLoading.value = true;
    try {
      final result = await _repository.getProfile();

      if (result['success'] == true) {
        consultant.value = result['consultant'];
        user.value = result['user'];
        selectedCategoryIds.value = List<int>.from(
          result['selectedCategories'],
        );

        // Populate form controllers
        nameController.text = user.value?.name ?? '';
        bioController.text = consultant.value?.bio ?? '';
        certificationController.text = consultant.value?.certification ?? '';
        cityController.text = consultant.value?.city ?? '';
        provinceController.text = consultant.value?.province ?? '';
      } else {
        _showErrorSnackbar(result['message']);
      }
    } catch (e) {
      _showErrorSnackbar('Gagal memuat profil');
    } finally {
      isLoading.value = false;
    }
  }

  /// Load consultation categories
  Future<void> loadCategories() async {
    try {
      final result = await _repository.getCategories();

      if (result['success'] == true) {
        categories.value = result['categories'];
      }
    } catch (e) {
      // Silently fail for categories
    }
  }

  /// Update profile
  Future<void> updateProfile() async {
    isSaving.value = true;
    try {
      final result = await _repository.updateProfile(
        name: nameController.text.trim(),
        bio: bioController.text.trim(),
        certification: certificationController.text.trim(),
        city: cityController.text.trim(),
        province: provinceController.text.trim(),
      );

      if (result['success'] == true) {
        _showSuccessSnackbar(result['message']);
        await loadProfile(); // Reload to get updated data
        Get.back(); // Go back to profile view
      } else {
        _showErrorSnackbar(result['message']);
      }
    } catch (e) {
      _showErrorSnackbar('Gagal memperbarui profil');
    } finally {
      isSaving.value = false;
    }
  }

  /// Pick and upload avatar
  Future<void> pickAndUploadAvatar() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        isSaving.value = true;
        final result = await _repository.updateAvatar(image);

        if (result['success'] == true) {
          _showSuccessSnackbar(result['message']);
          await loadProfile(); // Reload to get updated avatar
        } else {
          _showErrorSnackbar(result['message']);
        }
        isSaving.value = false;
      }
    } catch (e) {
      isSaving.value = false;
      _showErrorSnackbar('Gagal mengunggah avatar');
    }
  }

  /// Toggle category selection
  void toggleCategory(int categoryId) {
    if (selectedCategoryIds.contains(categoryId)) {
      selectedCategoryIds.remove(categoryId);
    } else {
      selectedCategoryIds.add(categoryId);
    }
  }

  /// Update specializations
  Future<void> updateSpecializations() async {
    if (selectedCategoryIds.isEmpty) {
      _showErrorSnackbar('Pilih minimal satu spesialisasi');
      return;
    }

    isSaving.value = true;
    try {
      final result = await _repository.updateSpecializations(
        selectedCategoryIds.toList(),
      );

      if (result['success'] == true) {
        _showSuccessSnackbar(result['message']);
        await loadProfile(); // Reload to get updated specializations
        Get.back(); // Go back to profile view
      } else {
        _showErrorSnackbar(result['message']);
      }
    } catch (e) {
      _showErrorSnackbar('Gagal memperbarui spesialisasi');
    } finally {
      isSaving.value = false;
    }
  }

  /// Show success snackbar
  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'Berhasil',
      message,
      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
      colorText: AppColors.primary,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }

  /// Show error snackbar
  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red.withValues(alpha: 0.1),
      colorText: Colors.red,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }
}
