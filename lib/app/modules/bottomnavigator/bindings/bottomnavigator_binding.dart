import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';
import '../../consultation/controllers/consultation_controller.dart';
import '../../consultant/controllers/consultant_controller.dart';
import '../../education/controllers/education_controller.dart';
import '../../account/controllers/account_controller.dart';
import '../controllers/bottomnavigator_controller.dart';

class BottomnavigatorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomnavigatorController>(() => BottomnavigatorController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ConsultationController>(() => ConsultationController());
    Get.lazyPut<ConsultantController>(() => ConsultantController());
    Get.lazyPut<EducationController>(() => EducationController());
    Get.lazyPut<AccountController>(() => AccountController());
  }
}
