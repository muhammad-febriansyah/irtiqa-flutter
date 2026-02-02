import 'package:get/get.dart';
import '../controllers/dream_controller.dart';

class DreamBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DreamController>(() => DreamController());
  }
}
