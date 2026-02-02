import 'package:get/get.dart';
import 'package:irtiqa/app/data/models/package_model.dart';
import 'package:irtiqa/app/data/repositories/package_repository.dart';

class PackageController extends GetxController {
  final PackageRepository _repository = PackageRepository();

  final packages = <PackageModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final selectedPackage = Rx<PackageModel?>(null);

  @override
  void onInit() {
    super.onInit();
    loadPackages();
  }

  Future<void> loadPackages() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      packages.value = await _repository.getPackages();
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Gagal memuat paket: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadPackageDetail(int id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      selectedPackage.value = await _repository.getPackageDetail(id);
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Gagal memuat detail paket: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void selectPackage(PackageModel package) {
    selectedPackage.value = package;
  }

  List<PackageModel> get featuredPackages {
    return packages.where((p) => p.isFeatured).toList();
  }

  List<PackageModel> get regularPackages {
    return packages.where((p) => !p.isFeatured).toList();
  }
}
