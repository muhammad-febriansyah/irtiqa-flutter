import 'package:get/get.dart';
import 'package:irtiqa/app/core/api_client.dart';

class JournalController extends GetxController {
  var isLoading = false.obs;
  var entries = <Map<String, dynamic>>[].obs;
  var statistics = <String, dynamic>{}.obs;
  var tags = <String>[].obs;

  // Filters
  var selectedMood = Rx<String?>(null);
  var selectedTag = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    loadEntries();
    loadStatistics();
    loadTags();
  }

  /// Load journal entries
  Future<void> loadEntries() async {
    try {
      isLoading.value = true;

      final queryParams = <String, dynamic>{};
      if (selectedMood.value != null) {
        queryParams['mood'] = selectedMood.value;
      }
      if (selectedTag.value != null) {
        queryParams['tag'] = selectedTag.value;
      }

      final response = await ApiClient.get('/journal', queryParameters: queryParams);

      if (response.statusCode == 200) {
        final data = response.data['data'];
        entries.value = List<Map<String, dynamic>>.from(data['data'] ?? []);
      }
    } catch (e) {
      // Error loading entries: $e
      Get.snackbar(
        'Error',
        'Tidak dapat memuat jurnal',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Load statistics
  Future<void> loadStatistics() async {
    try {
      final response = await ApiClient.get('/journal/statistics');

      if (response.statusCode == 200) {
        statistics.value = response.data['data'];
      }
    } catch (e) {
      // Error loading statistics: $e
    }
  }

  /// Load tags
  Future<void> loadTags() async {
    try {
      final response = await ApiClient.get('/journal/tags');

      if (response.statusCode == 200) {
        tags.value = List<String>.from(response.data['data'] ?? []);
      }
    } catch (e) {
      // Error loading tags: $e
    }
  }

  /// Create entry
  Future<bool> createEntry({
    required String date,
    required String mood,
    required String content,
    List<String>? tags,
  }) async {
    try {
      isLoading.value = true;

      final response = await ApiClient.post('/journal', data: {
        'entry_date': date,
        'mood': mood,
        'content': content,
        'tags': tags,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Berhasil',
          'Jurnal berhasil disimpan',
          snackPosition: SnackPosition.BOTTOM,
        );
        loadEntries();
        loadStatistics();
        loadTags();
        return true;
      } else {
        Get.snackbar(
          'Gagal',
          response.data['message'] ?? 'Terjadi kesalahan',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Tidak dapat terhubung ke server',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Update entry
  Future<bool> updateEntry({
    required int id,
    String? mood,
    String? content,
    List<String>? tags,
  }) async {
    try {
      isLoading.value = true;

      final data = <String, dynamic>{};
      if (mood != null) data['mood'] = mood;
      if (content != null) data['content'] = content;
      if (tags != null) data['tags'] = tags;

      final response = await ApiClient.put('/journal/$id', data: data);

      if (response.statusCode == 200) {
        Get.snackbar(
          'Berhasil',
          'Jurnal berhasil diperbarui',
          snackPosition: SnackPosition.BOTTOM,
        );
        loadEntries();
        loadStatistics();
        return true;
      } else {
        Get.snackbar(
          'Gagal',
          response.data['message'] ?? 'Terjadi kesalahan',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Tidak dapat terhubung ke server',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Delete entry
  Future<bool> deleteEntry(int id) async {
    try {
      isLoading.value = true;

      final response = await ApiClient.delete('/journal/$id');

      if (response.statusCode == 200) {
        Get.snackbar(
          'Berhasil',
          'Jurnal berhasil dihapus',
          snackPosition: SnackPosition.BOTTOM,
        );
        loadEntries();
        loadStatistics();
        return true;
      } else {
        Get.snackbar(
          'Gagal',
          response.data['message'] ?? 'Terjadi kesalahan',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Tidak dapat terhubung ke server',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Get mood emoji
  String getMoodEmoji(String mood) {
    switch (mood) {
      case 'very_good':
        return '😊';
      case 'good':
        return '🙂';
      case 'neutral':
        return '😐';
      case 'bad':
        return '😔';
      case 'very_bad':
        return '😢';
      default:
        return '😐';
    }
  }

  /// Get mood label
  String getMoodLabel(String mood) {
    switch (mood) {
      case 'very_good':
        return 'Sangat Baik';
      case 'good':
        return 'Baik';
      case 'neutral':
        return 'Biasa';
      case 'bad':
        return 'Buruk';
      case 'very_bad':
        return 'Sangat Buruk';
      default:
        return 'Tidak Diketahui';
    }
  }

  /// Apply filter
  void applyFilter({String? mood, String? tag}) {
    selectedMood.value = mood;
    selectedTag.value = tag;
    loadEntries();
  }

  /// Clear filter
  void clearFilter() {
    selectedMood.value = null;
    selectedTag.value = null;
    loadEntries();
  }
}
