import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/educational_content_model.dart';
import '../../../data/models/faq_model.dart';
import '../../../data/repositories/education_repository.dart';
import '../../../data/repositories/faq_repository.dart';

class EducationController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final EducationRepository _educationRepository = EducationRepository();
  final FaqRepository _faqRepository = FaqRepository();

  late TabController tabController;
  final isLoading = false.obs;
  final articles = <EducationalContentModel>[].obs;
  final faqs = <FaqModel>[].obs;
  final selectedCategory = Rx<String?>(null);

  final categories = [
    {'value': 'psycho_spiritual', 'label': 'Psiko-Spiritual'},
    {'value': 'dream_sleep', 'label': 'Mimpi & Tidur'},
    {'value': 'waswas_worship', 'label': 'Waswas & Ibadah'},
    {'value': 'family_children', 'label': 'Keluarga & Anak'},
    {'value': 'facing_trials', 'label': 'Adab Menghadapi Ujian'},
  ];

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    loadArticles();
    loadFaqs();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<void> loadArticles({String? category}) async {
    isLoading.value = true;
    try {
      final data = await _educationRepository.getContents(category: category);
      articles.value = data;
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadFaqs({String? category}) async {
    isLoading.value = true;
    try {
      final data = await _faqRepository.getFaqs(category: category);
      faqs.value = data;
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  void filterByCategory(String? category) {
    selectedCategory.value = category;
    loadArticles(category: category);
    loadFaqs(category: category);
  }

  void goToArticleDetail(int id) {
    Get.toNamed('/education/article/$id');
  }

  void goToFaqDetail(int id) {
    Get.toNamed('/education/faq/$id');
  }
}
