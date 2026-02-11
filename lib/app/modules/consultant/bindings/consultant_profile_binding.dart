import 'package:get/get.dart';
import '../controllers/consultant_profile_controller.dart';
import '../../../data/repositories/consultant_profile_repository.dart';

class ConsultantProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConsultantProfileRepository>(
      () => ConsultantProfileRepository(),
    );
    Get.lazyPut<ConsultantProfileController>(
      () => ConsultantProfileController(),
    );
  }
}
