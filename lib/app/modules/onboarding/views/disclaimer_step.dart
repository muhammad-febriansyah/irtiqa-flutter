import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:irtiqa/app/modules/onboarding/controllers/onboarding_controller.dart';

class DisclaimerStep extends GetView<OnboardingController> {
  const DisclaimerStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // Icon
          Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.info_outline,
                size: 60,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Title
          Text(
            'Selamat Datang di IRTIQA',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          Text(
            'Di sini, Anda didampingi secara tenang dan bertahap.',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
              fontSize: 16,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Disclaimer content
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kesepahaman Awal',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),

                Text(
                  'IRTIQA bersifat pendampingan dan edukasi.\nKami tidak menetapkan kepastian perkara ghaib dan tidak menggantikan tenaga medis atau fatwa ulama.',
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 20),

                Obx(
                  () => _buildDisclaimerCheckbox(
                    value: controller.understandNotGhaib.value,
                    onChanged: (val) =>
                        controller.understandNotGhaib.value = val ?? false,
                    text: 'Saya memahami IRTIQA bukan penentu perkara ghaib',
                  ),
                ),

                Obx(
                  () => _buildDisclaimerCheckbox(
                    value: controller.understandNotMedical.value,
                    onChanged: (val) =>
                        controller.understandNotMedical.value = val ?? false,
                    text: 'Saya memahami ini bukan pengganti medis atau fatwa',
                  ),
                ),

                Obx(
                  () => _buildDisclaimerCheckbox(
                    value: controller.willingToFollowProcess.value,
                    onChanged: (val) =>
                        controller.willingToFollowProcess.value = val ?? false,
                    text:
                        'Saya bersedia mengikuti proses bertahap dengan tenang',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Important note
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.amber[800]),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Layanan ini untuk usia minimal 17 tahun',
                    style: TextStyle(
                      color: Colors.amber[900],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Accept button
          Obx(
            () => SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () => controller.acceptDisclaimer(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: controller.isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text(
                        'Saya Mengerti',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Privacy policy link
          Center(
            child: TextButton(
              onPressed: () {
                Get.toNamed('/privacy/policy');
              },
              child: Text(
                'Baca Kebijakan Privasi',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDisclaimerCheckbox({
    required bool value,
    required ValueChanged<bool?> onChanged,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: CheckboxListTile(
        value: value,
        onChanged: onChanged,
        title: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            height: 1.4,
            color: Colors.black87,
          ),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
        dense: true,
        activeColor: Get.theme.primaryColor,
        checkboxShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
