import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';

class BottomnavigatorController extends GetxController {
  final currentIndex = 0.obs;
  final currentUser = Rx<UserModel?>(null);
  final AuthRepository _authRepository = AuthRepository();

  @override
  void onInit() {
    super.onInit();
    loadCurrentUser();
  }

  Future<void> loadCurrentUser() async {
    currentUser.value = await _authRepository.getCurrentUser();
  }

  bool get isConsultant => currentUser.value?.isConsultant ?? false;

  void changePage(int index) {
    currentIndex.value = index;
  }
}
