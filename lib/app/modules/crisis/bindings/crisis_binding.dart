import 'package:get/get.dart';
import 'package:irtiqa/app/modules/crisis/controllers/crisis_controller.dart';

class CrisisBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CrisisController>(() => CrisisController());
  }
}
