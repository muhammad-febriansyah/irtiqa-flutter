import 'package:get/get.dart';
import '../../../data/models/consultation_model.dart';
import '../../../data/repositories/consultation_repository.dart';

class ConsultantController extends GetxController {
  final ConsultationRepository _repository = ConsultationRepository();

  final isLoading = false.obs;
  final queueTickets = <ConsultationModel>[].obs;
  final activeConsultations = <ConsultationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    isLoading.value = true;
    try {
      // Logic to fetch consultant specific tickets would go here
      // For now we'll reuse getConsultations but we should add a specific endpoint for consultants
      final tickets = await _repository.getConsultations();
      queueTickets.value = tickets.where((t) => t.status == 'waiting').toList();
      activeConsultations.value = tickets
          .where((t) => t.status == 'in_progress')
          .toList();
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  void acceptTicket(int id) async {
    // API call to accept ticket
  }

  void goToTicketDetail(int id) {
    Get.toNamed('/consultant/ticket/$id');
  }
}
