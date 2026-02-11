import 'package:get/get.dart';
import '../../../data/models/program_model.dart';
import '../../../data/repositories/program_repository.dart';

class ProgramController extends GetxController {
  final ProgramRepository _repository = ProgramRepository();

  final isLoading = false.obs;
  final programs = <ProgramModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadPrograms();
  }

  Future<void> loadPrograms() async {
    isLoading.value = true;
    try {
      final data = await _repository.getPrograms();
      programs.value = data;
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  void goToProgramDetail(int id) {
    Get.toNamed('/program/detail/$id');
  }
}
