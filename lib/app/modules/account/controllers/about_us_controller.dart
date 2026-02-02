import 'package:get/get.dart';
import '../../../data/models/about_us_model.dart';
import '../../../data/providers/about_us_provider.dart';

class AboutUsController extends GetxController {
  final AboutUsProvider _provider = AboutUsProvider();

  final RxBool isLoading = false.obs;
  final Rx<AboutUsModel?> aboutUs = Rx<AboutUsModel?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchAboutUs();
  }

  Future<void> fetchAboutUs() async {
    try {
      isLoading.value = true;
      final response = await _provider.getAboutUs();
      if (response.statusCode == 200 && response.data['success'] == true) {
        aboutUs.value = AboutUsModel.fromJson(response.data['data']);
      }
    } catch (e) {
      // Error fetching About Us: $e
    } finally {
      isLoading.value = false;
    }
  }
}
