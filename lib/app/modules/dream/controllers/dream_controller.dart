import 'package:get/get.dart';

class DreamController extends GetxController {
  final isLoading = false.obs;
  final dreams = [].obs;

  @override
  void onInit() {
    super.onInit();
    loadDreams();
  }

  void loadDreams() {
    isLoading.value = false;
  }

  void goToCreateDream() {
    Get.toNamed('/dream/create');
  }

  void goToDreamDetail(dynamic dream) {
    Get.toNamed('/dream/detail', arguments: dream);
  }
}
