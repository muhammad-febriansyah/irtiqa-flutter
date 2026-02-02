import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../modules/bottomnavigator/controllers/bottomnavigator_controller.dart';

class HomeController extends GetxController {
  final GetStorage _storage = GetStorage();
  final isLoading = false.obs;
  final userName = Rx<String>('Pengguna');

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() {
    final userData = _storage.read('user_data');
    if (userData != null && userData['name'] != null) {
      userName.value = userData['name'];
    }
  }

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Selamat Pagi';
    } else if (hour < 15) {
      return 'Selamat Siang';
    } else if (hour < 18) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }

  void goToConsultation() {
    try {
      final bottomNavController = Get.find<BottomnavigatorController>();
      bottomNavController.changePage(1);
    } catch (_) {}
  }

  void goToEducation() {
    try {
      final bottomNavController = Get.find<BottomnavigatorController>();
      bottomNavController.changePage(2);
    } catch (_) {}
  }

  void goToDream() {
    Get.toNamed('/dream/education-gate');
  }
}
