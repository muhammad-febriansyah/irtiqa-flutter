import 'package:get/get.dart';
import '../../../data/repositories/dream_repository.dart';
import '../../../data/models/dream_model.dart';

class DreamController extends GetxController {
  final DreamRepository _repository = DreamRepository();

  final isLoading = false.obs;
  final dreams = <DreamModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDreams();
  }

  Future<void> loadDreams() async {
    try {
      isLoading.value = true;
      final result = await _repository.getDreams();
      dreams.value = result;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat data mimpi',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> goToCreateDream() async {
    final result = await Get.toNamed('/dream/create');
    if (result == true) {
      loadDreams();
    }
  }

  void goToDreamDetail(DreamModel dream) {
    Get.toNamed('/dream/detail', arguments: dream);
  }
}
