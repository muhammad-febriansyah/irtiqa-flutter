import 'package:get/get.dart';
import '../../../data/models/consultation_model.dart';
import '../../../data/repositories/consultation_repository.dart';

class ConsultationController extends GetxController {
  final ConsultationRepository _repository = ConsultationRepository();

  final isLoading = false.obs;
  final consultations = <ConsultationModel>[].obs;
  final currentTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadConsultations();
  }

  Future<void> loadConsultations() async {
    isLoading.value = true;
    try {
      final data = await _repository.getConsultations();
      consultations.value = data;
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  void changeTab(int index) {
    currentTab.value = index;
  }

  void goToConsultationDetail(int id) {
    Get.toNamed('/consultation/detail/$id');
  }

  Future<bool> createConsultation({
    required String subject,
    required String description,
    required String category,
    required String urgency,
  }) async {
    isLoading.value = true;
    try {
      // Mapping or finding category ID would be better, but let's assume 1 for now or fetch categories
      final result = await _repository.createConsultation(
        categoryId: 1, // Default to first category if not specified
        subject: subject,
        description: description,
        urgency: urgency,
      );

      if (result != null) {
        await loadConsultations();
        return true;
      }
      return false;
    } catch (_) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void goToCreateConsultation() {
    Get.toNamed('/consultation/create');
  }
}
