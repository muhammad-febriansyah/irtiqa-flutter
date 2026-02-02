import 'package:get/get.dart';
import 'package:irtiqa/app/modules/consultant_application/controllers/consultant_application_controller.dart';

class ConsultantApplicationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConsultantApplicationController>(
      () => ConsultantApplicationController(),
    );
  }
}
